/*
 * Copyright (C) 2014, The OpenURP Software.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.openurp.std.info.web.action.admin

import org.beangle.commons.bean.Properties
import org.beangle.commons.collection.{Collections, Order}
import org.beangle.commons.lang.{Objects, Strings}
import org.beangle.data.dao.OqlBuilder
import org.beangle.data.model.Entity
import org.beangle.web.action.annotation.mapping
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.edu.model.{Direction, Major}
import org.openurp.base.model.{Campus, Department, Project}
import org.openurp.base.std.model.{Grade, Squad, Student, StudentState}
import org.openurp.code.edu.model.{EducationLevel, EducationMode}
import org.openurp.code.std.model.{StdAlterReason, StdAlterType, StudentStatus}
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.alter.model.{AlterMeta, StdAlteration, StdAlterationItem}
import org.openurp.std.info.app.model.StdAlterConfig

import java.time.{Instant, LocalDate}

/**
 * 学籍异动维护
 */
class AlterationAction extends RestfulAction[StdAlteration], ProjectSupport {

  override protected def indexSetting(): Unit = {
    given project: Project = getProject

    put("project", project)
    put("campuses", findInSchool(classOf[Campus]))
    put("modes", getCodes(classOf[StdAlterType]))
    put("reasons", getCodes(classOf[StdAlterReason]))
    put("currentSemester", getSemester)
  }

  def firstStep(): View = {
    given project: Project = getProject

    put("departments", getDeparts)
    val majorQuery = OqlBuilder.from(classOf[Major]).where("major.project=:project", project)
    put("majors", entityDao.search(majorQuery))
    val directionQuery = OqlBuilder.from(classOf[Direction]).where("direction.project=:project", project)
    put("directions", entityDao.search(directionQuery))
    put("levels", getCodes(classOf[EducationLevel]))
    put("educationModes", getCodes(classOf[EducationMode]))
    val ac = OqlBuilder.from(classOf[StdAlterConfig], "ac").where("ac.project=:project", project)
    put("alterConfigs", entityDao.search(ac))
    forward()
  }

  /**
   * 新建异动信息第二步：根据选择的学生，显示异动页面
   *
   * @return
   */
  def secondStep(): View = {
    val students = entityDao.find(classOf[Student], longIds("student"))
    if (students.isEmpty) return forward("没有选择需要异动的学生")
    val states = students.map(_.state)

    given project: Project = getProject

    put("students", students)
    put("studentStates", states)
    put("modes", getCodes(classOf[StdAlterType]))
    put("reasons", getCodes(classOf[StdAlterReason]))
    put("statuses", getCodes(classOf[StudentStatus]))
    put("departments", project.departments)
    put("squades", entityDao.findBy(classOf[Squad], "project", project))

    val alterConfig = entityDao.get(classOf[StdAlterConfig], longId("alterConfig"))
    val columnValues = Strings.split(alterConfig.attributes)
    if (columnValues.length > 0) {
      for (column <- columnValues) {
        if ("department" == column) put("departmentConfig", true)
        else if ("major" == column) put("majorConfig", true)
        else if ("grade" == column) put("gradeConfig", true)
        else if ("squad" == column) put("squadConfig", true)
      }
      put("config", true)
    }
    put("minBeginOn", students.sortBy(_.beginOn).head.beginOn)
    put("maxEndOn", students.sortBy(_.endOn).head.endOn)
    put("graduateOnConfig", alterConfig.alterGraduateOn)
    if (alterConfig.alterGraduateOn) {
      put("maxGraduateOn", students.sortBy(_.graduateOn).head.graduateOn)
    }
    put("alterConfig", alterConfig)
    forward("form")
  }

  def listStudents(): View = {
    given project: Project = getProject

    val builder = OqlBuilder.from(classOf[Student], "student")
      .where("student.project = :project", project)
      .where("student.state.department in (:departments)", getDeparts).limit(getPageLimit)
    populateConditions(builder)
    var stdCodes = get("stdCodes").orNull
    if (Strings.isNotEmpty(stdCodes)) {
      stdCodes = Strings.replace(stdCodes, "\n", ",")
      stdCodes = Strings.replace(stdCodes, "，", ",")
      stdCodes = Strings.replace(stdCodes, "+", ",")
      stdCodes = Strings.replace(stdCodes, " ", ",")
      val codes = Strings.split(stdCodes, ",")
      if (codes.length > 1) builder.where("student.code in (:stdCodes)", codes)
      else if (codes.length == 1) builder.where("student.code like :stdCode", "%" + codes(0) + "%")
    }
    val date = LocalDate.now
    getBoolean("active") foreach { active =>
      if (active) builder.where("student.beginOn<= :now and student.endOn>=:now and student.registed=true", date)
      else builder.where("student.beginOn> :now or student.endOn<:now or student.registed=false", date)
    }

    getBoolean("inschool") foreach { inschool =>
      builder.join("student.states", "ss")
      if (inschool) builder.where("ss.beginOn<=:now and ss.endOn>=:now and ss.inschool = true", date)
      else builder.where("ss.beginOn>:now or ss.endOn<:now or (ss.beginOn<=:now and ss.endOn>=:now and ss.inschool is false)", date)
    }
    populateConditions(builder)
    val orderBy = get(Order.OrderStr).orNull
    builder.orderBy(if (Strings.isEmpty(orderBy)) "student.code" else orderBy)
    put("students", entityDao.search(builder))
    forward()
  }

  @throws[Exception]
  @mapping(method = "post")
  override def save(): View = {
    val project = getProject

    val students = entityDao.find(classOf[Student], longIds("student"))
    val alterConfig = entityDao.get(classOf[StdAlterConfig], longId("alterConfig"))

    val alteration = populateEntity(classOf[StdAlteration], "stdAlteration")
    if (null == alteration.endOn) alteration.endOn = alteration.beginOn
    val semester = semesterService.get(project, alteration.beginOn)
    if (null == semester) return forward("当前时间不在有效学期内")
    val stdAlterType = entityDao.get(classOf[StdAlterType], alteration.alterType.id)
    alteration.semester = semester
    alteration.updatedAt = Instant.now
    alteration.alterType = stdAlterType
    alteration.effective = true
    alteration.reason foreach { r =>
      if (r.persisted) alteration.reason = Some(entityDao.get(classOf[StdAlterReason], r.id))
    }

    val successes = Collections.newBuffer[StdAlteration]
    val errors = Collections.newMap[Student, String]
    val status = populateEntity(classOf[StudentState], "status")
    status.inschool = alterConfig.inschool
    status.status = alterConfig.status
    val graduateOn = getDate("graduateOn")
    for (student <- students) {
      val alter = cloneTo(alteration, student)
      val targetState = student.state.get
      graduateOn foreach { g =>
        addItem(alter, AlterMeta.GraduateOn, student.graduateOn, g)
      }
      diff(alter, targetState, status)
      entityDao.saveOrUpdate(alter)
      val msg = applyStd(alter, student)
      if Strings.isEmpty(msg) then successes += alter else errors.put(student, msg)
    }
    put("successes", successes)
    put("errors", errors)
    forward("results")
  }

  private def diff(alteration: StdAlteration, state: StudentState, changed: StudentState): Unit = {
    addItem(alteration, AlterMeta.Grade, state.grade, changed.grade)
    addItem(alteration, AlterMeta.Department, state.department, changed.department)
    addItem(alteration, AlterMeta.Major, state.major, changed.major)
    addItem(alteration, AlterMeta.Direction, state.direction.orNull, changed.direction.orNull)
    addItem(alteration, AlterMeta.Squad, state.squad.orNull, changed.squad.orNull)
    addItem(alteration, AlterMeta.Status, state.status, changed.status)
    addItem(alteration, AlterMeta.Inschool, state.inschool, changed.inschool)
  }

  private def addItem(alteration: StdAlteration, meta: AlterMeta, older: Any, newer: Any): Unit = {
    if ((newer != null) && !Objects.equals(older, newer)) {
      val item = new StdAlterationItem()
      item.alteration = alteration
      item.meta = meta
      if (null != older) {
        val kv = getValues(meta, older)
        item.oldvalue = Some(kv._1)
        item.oldtext = Some(kv._2)
      }
      if (null != newer) {
        val kv = getValues(meta, newer)
        item.newvalue = Some(kv._1)
        item.newtext = Some(kv._2)
      }
      alteration.items += item
    }
  }

  private def getValues(meta: AlterMeta, obj: Any): (String, String) = {
    obj match {
      case a: String => (a, a)
      case b: Boolean => (b.toString, b.toString)
      case c: LocalDate => (c.toString, c.toString)
      case g: Grade =>
        val grade = entityDao.get(classOf[Grade], g.id)
        (grade.id.toString, grade.name)
      case d: Department =>
        val depart = entityDao.get(classOf[Department], d.id)
        (depart.id.toString, depart.name)
      case m: Major =>
        val major = entityDao.get(classOf[Major], m.id)
        (major.id.toString, major.name)
      case di: Direction =>
        val direction = entityDao.get(classOf[Direction], di.id)
        (direction.id.toString, direction.name)
      case s: Squad =>
        val squad = entityDao.get(classOf[Squad], s.id)
        (squad.id.toString, squad.name)
      case ss: StudentStatus =>
        val status = entityDao.get(classOf[StudentStatus], ss.id)
        (status.id.toString, status.name)
      case _ => throw new RuntimeException("Cannot identify object type " + obj.getClass.getName)
    }
  }

  def enable(): View = {
    val successes = Collections.newBuffer[StdAlteration]
    val errors = Collections.newMap[Student, String]
    val alterations = entityDao.find(classOf[StdAlteration], longIds("stdAlteration"))
    alterations foreach { a =>
      val msg = applyStd(a, a.std)
      if Strings.isEmpty(msg) then successes += a else errors.put(a.std, msg)
    }
    forward("results")
  }

  private def cloneTo(template: StdAlteration, std: Student): StdAlteration = {
    val n = new StdAlteration
    n.std = std
    n.semester = template.semester
    n.reason = template.reason
    n.endOn = template.endOn
    n.beginOn = template.beginOn
    n.alterType = template.alterType
    n.effective = template.effective
    n.updatedAt = template.updatedAt
    n.remark = template.remark
    n.code = Instant.now.getEpochSecond.toString
    n
  }

  private def applyStd(alteration: StdAlteration, std: Student): String = {
    std.states.find(x => !alteration.beginOn.isBefore(x.beginOn) && !alteration.endOn.isAfter(x.endOn)) match
      case None => "无法进行异动，找不到对应的学籍状态"
      case Some(target) =>
        val alterConfig = entityDao.findBy(classOf[StdAlterConfig], "alterType", alteration.alterType).head
        val state = generateState(target, alteration.beginOn, alteration.endOn, alterConfig)
        alteration.items foreach { item =>
          item.meta match {
            case AlterMeta.Grade => state.grade = entityDao.get(classOf[Grade], item.newvalue.get.toLong)
            case AlterMeta.Department => state.department = entityDao.get(classOf[Department], item.newvalue.get.toInt)
            case AlterMeta.Major => state.major = entityDao.get(classOf[Major], item.newvalue.get.toLong)
            case AlterMeta.Direction =>
              item.newvalue match
                case None => state.direction = None
                case Some(id) => state.direction = Some(entityDao.get(classOf[Direction], id.toLong))
            case AlterMeta.Squad =>
              item.newvalue match
                case None => state.squad = None
                case Some(id) => state.squad = Some(entityDao.get(classOf[Squad], id.toLong))
            case AlterMeta.Inschool =>
              state.inschool = item.newvalue.get.toBoolean
            case AlterMeta.Status => state.status = entityDao.get(classOf[StudentStatus], item.newvalue.get.toInt)
            case AlterMeta.GraduateOn => state.std.graduateOn = LocalDate.parse(item.newvalue.get)
          }
        }
        state.std.calcCurrentState()
        entityDao.saveOrUpdate(state, target, state.std)
        ""
  }

  private def generateState(state: StudentState, beginOn: LocalDate, endOn: LocalDate, alterConfig: StdAlterConfig): StudentState = { // 向后切
    if (beginOn == state.beginOn && endOn == state.endOn) {
      if (alterConfig.alterEndOn) state.endOn = endOn
      state.std.endOn = endOn
      state
    } else {
      val newState = new StudentState
      newState.std = state.std
      newState.beginOn = beginOn
      newState.endOn = state.endOn //保留被阶段状态的结束时间
      newState.grade = state.grade
      newState.department = state.department
      newState.major = state.major
      newState.direction = state.direction
      newState.squad = state.squad
      newState.status = state.status
      newState.campus = state.campus
      newState.inschool = state.inschool
      newState.remark = Some(alterConfig.alterType.name)
      if (beginOn == state.beginOn) {
        state.beginOn = endOn.plusDays(1)
      } else {
        state.endOn = beginOn.minusDays(1)
      }
      state.std.states += newState
      newState
    }
  }

}

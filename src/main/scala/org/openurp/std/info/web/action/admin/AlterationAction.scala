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

import org.beangle.commons.collection.{Collections, Order}
import org.beangle.commons.lang.{Enums, Objects, Strings}
import org.beangle.data.dao.OqlBuilder
import org.beangle.webmvc.annotation.mapping
import org.beangle.webmvc.support.action.{ExportSupport, RestfulAction}
import org.beangle.webmvc.view.View
import org.openurp.base.edu.model.{Major, MajorDirection}
import org.openurp.base.hr.model.Teacher
import org.openurp.base.model.{Department, Project}
import org.openurp.base.std.model.{Grade, Squad, Student, StudentState}
import org.openurp.code.edu.model.{EducationLevel, EducationMode}
import org.openurp.code.std.model.{StdAlterReason, StdAlterType, StudentStatus}
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.alter.config.AlterConfig
import org.openurp.std.alter.model.{AlterMeta, StdAlteration, StdAlterationItem}
import org.openurp.std.info.service.StdAlterationService

import java.time.{Instant, LocalDate}

/**
 * 学籍异动维护
 */
class AlterationAction extends RestfulAction[StdAlteration], ExportSupport[StdAlteration], ProjectSupport {

  var stdAlterationService: StdAlterationService = _

  override protected def indexSetting(): Unit = {
    given project: Project = getProject

    put("project", project)
    put("levels", project.levels) // 培养层次
    put("departments", getDeparts)
    put("majors", findInProject(classOf[Major]))

    put("modes", getCodes(classOf[StdAlterType]))
    put("reasons", getCodes(classOf[StdAlterReason]))
    put("semester", getSemester)
    put("metas", AlterMeta.values)
  }

  override protected def getQueryBuilder: OqlBuilder[StdAlteration] = {
    val query = super.getQueryBuilder
    getInt("meta.id") foreach { metaId =>
      query.where("exists(from stdAlteration.items as item where item.meta=:meta)", Enums.of(classOf[AlterMeta], metaId))
    }
    getDate("alterFromDate") foreach { d =>
      query.where("stdAlteration.alterOn >= :fromDate", d)
    }
    getDate("alterToDate") foreach { d =>
      query.where("stdAlteration.alterOn <= :toDate", d)
    }
    query
  }

  def firstStep(): View = {
    given project: Project = getProject

    put("departments", getDeparts)
    val majorQuery = OqlBuilder.from(classOf[Major]).where("major.project=:project", project)
    put("majors", entityDao.search(majorQuery))
    val directionQuery = OqlBuilder.from(classOf[MajorDirection]).where("direction.project=:project", project)
    put("directions", entityDao.search(directionQuery))
    put("levels", getCodes(classOf[EducationLevel]))
    put("educationModes", getCodes(classOf[EducationMode]))
    val ac = OqlBuilder.from(classOf[AlterConfig], "ac").where("ac.project=:project", project)
    put("alterConfigs", entityDao.search(ac))
    forward()
  }

  /**
   * 新建异动信息第二步：根据选择的学生，显示异动页面
   *
   * @return
   */
  def secondStep(): View = {
    val students = entityDao.find(classOf[Student], getLongIds("student"))
    if (students.isEmpty) return forward("没有选择需要异动的学生")
    val states = students.map(_.state)

    given project: Project = getProject

    put("students", students)
    put("studentStates", states)
    put("modes", getCodes(classOf[StdAlterType]))
    put("reasons", getCodes(classOf[StdAlterReason]))
    put("statuses", getCodes(classOf[StudentStatus]))
    put("grades", entityDao.findBy(classOf[Grade], "project", project))
    put("departments", project.departments)
    put("majors", entityDao.findBy(classOf[Major], "project", project))
    put("directions", entityDao.findBy(classOf[MajorDirection], "project", project))
    put("squads", entityDao.findBy(classOf[Squad], "project", project))

    val alterConfig = entityDao.get(classOf[AlterConfig], getLongId("alterConfig"))
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
    put("minBeginOn", students.minBy(_.beginOn).beginOn)
    put("maxEndOn", students.minBy(_.endOn).endOn)
    put("alterConfig", alterConfig)
    put("project", project)
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
    var orderBy = get(Order.OrderStr).orNull
    orderBy = if (Strings.isEmpty(orderBy)) "student.code" else orderBy
    if (orderBy.startsWith("student")) {
      builder.orderBy(orderBy)
    }
    put("students", entityDao.search(builder))
    forward()
  }

  @throws[Exception]
  @mapping(method = "post")
  override def save(): View = {
    val project = getProject

    val students = entityDao.find(classOf[Student], getLongIds("student"))
    val alterConfig = entityDao.get(classOf[AlterConfig], getLongId("alterConfig"))

    val alteration = populateEntity(classOf[StdAlteration], "stdAlteration")
    val semester = semesterService.get(project, alteration.alterOn)
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
    for (student <- students) {
      val alter = cloneTo(alteration, student)
      val targetState = student.state.get
      diff(alter, targetState, status)
      entityDao.saveOrUpdate(alter)
      val msg = stdAlterationService.apply(alter, student)
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
    getDate("graduateOn") foreach { graduateOn =>
      addItem(alteration, AlterMeta.GraduateOn, state.std.graduateOn, graduateOn)
    }
    getDate("endOn") foreach { endOn =>
      addItem(alteration, AlterMeta.EndOn, state.std.endOn, endOn)
    }
    getLong("tutor.id") foreach { tutorId =>
      addItem(alteration, AlterMeta.Tutor, state.std.majorTutors.headOption, entityDao.get(classOf[Teacher], tutorId))
    }
    getLong("advisor.id") foreach { advisorId =>
      addItem(alteration, AlterMeta.Advisor, state.std.thesisTutor.orNull, entityDao.get(classOf[Teacher], advisorId))
    }
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
      case di: MajorDirection =>
        val direction = entityDao.get(classOf[MajorDirection], di.id)
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
    val alterations = entityDao.find(classOf[StdAlteration], getLongIds("stdAlteration"))
    alterations foreach { a =>
      val msg = stdAlterationService.apply(a, a.std)
      if Strings.isEmpty(msg) then successes += a else errors.put(a.std, msg)
    }
    put("successes", successes)
    put("errors", errors)
    forward("results")
  }

  private def cloneTo(template: StdAlteration, std: Student): StdAlteration = {
    val n = new StdAlteration
    n.std = std
    n.semester = template.semester
    n.reason = template.reason
    n.alterOn = template.alterOn
    n.alterType = template.alterType
    n.effective = template.effective
    n.updatedAt = template.updatedAt
    n.remark = template.remark
    n
  }

}

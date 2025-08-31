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

package org.openurp.std.info.web.helper

import org.beangle.commons.collection.Collections
import org.beangle.commons.conversion.string.TemporalConverter
import org.beangle.commons.lang.Strings
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.doc.transfer.importer.{AbstractImporter, ImportListener, ImportResult, MultiEntityImporter}
import org.openurp.base.hr.model.Teacher
import org.openurp.base.model.{Person, Project}
import org.openurp.base.service.UserRepo
import org.openurp.base.std.model.{Student, StudentState, Tutorship}
import org.openurp.std.info.model.{Contact, Examinee}

import java.time.format.DateTimeFormatter
import java.time.{Instant, LocalDate}
import java.util

class StudentImporterListener(entityDao: EntityDao, userRepo: UserRepo, project: Project) extends ImportListener {

  final private val STUDENT_CODE: String = "student.code"
  final private val PERSON_FORMATEDNAME: String = "student.name"
  final private val PERSON_GENDER: String = "person.gender.code"
  final private val PERSON_BIRTHDAY: String = "person.birthday"
  final private val PERSON_NATION: String = "person.nation.code"
  final private val PERSON_CODE: String = "person.code"
  final private val PERSON_IDTYPE: String = "person.idType.code"
  final private val PERSON_POLITICALSTATUS: String = "person.politicalStatus.code"
  final private val STATE_GRADE: String = "state.grade.code"
  final private val STUDENT_STUDYTYPE: String = "student.studyType.code"
  final private val STUDENT_DURATION: String = "student.duration"
  final private val STATE_DEPARTMENT: String = "state.department.code"
  final private val STUDENT_EDUCATION: String = "student.level.code"
  final private val STUDENT_STDTYPE: String = "student.stdType.code"
  final private val STATE_MAJOR: String = "state.major.code"
  final private val STATE_DIRECTION: String = "state.direction.code"
  final private val STATE_CAMPUS: String = "state.campus.code"
  final private val STATE_ADMINCLASS: String = "state.squad.code"
  final private val STUDENT_REGISTED: String = "student.registed"
  final private val STATE_INSCHOOL: String = "state.inschool"
  final private val STUDENT_BEGINON: String = "student.beginOn"
  final private val STUDENT_ENDON: String = "student.endOn"
  final private val STUDENT_GRADUATE_ON: String = "student.graduateOn"
  final private val STATE_STATUS: String = "state.status.code"
  var sdf = DateTimeFormatter.ofPattern("yyyyMMdd")
  var entityCacheMap = Collections.newMap[String, Any]

  override def onStart(tr: ImportResult): Unit = {}

  override def onFinish(tr: ImportResult): Unit = {}

  override def onItemStart(tr: ImportResult): Unit = {
    val data = tr.transfer.curData
    val code = data.get(STUDENT_CODE).orNull.asInstanceOf[String]
    val personCode = data.get(PERSON_CODE).orNull.asInstanceOf[String]
    val newMap = Collections.newMap[String, AnyRef]
    var person: Person = null
    val stdBuilder = OqlBuilder.from(classOf[Student], "std")
    stdBuilder.where("std.code=:code", code)
    stdBuilder.where("std.project=:project", project)
    val stds = entityDao.search(stdBuilder)
    if (stds.nonEmpty) {
      val student = stds(0)
      newMap.put("student", student)
      student.state.foreach(state => {
        newMap.put("state", state)
      })
      entityDao.findBy(classOf[Contact], "std", student).foreach { c => newMap.put("contact", c) }
      entityDao.findBy(classOf[Examinee], "std", student).foreach { c => newMap.put("examinee", c) }
      person = student.person
    } else {
      if (Strings.isBlank(personCode)) {
        person = entityDao.findBy(classOf[Person], "code", List(personCode)).headOption.orNull
      }
    }
    if null != person then newMap.put("person", person)

    tr.transfer.current_=(newMap)
    if (stds.isEmpty) {
      checkMustBe(tr, PERSON_CODE)
      if (null == person || !person.persisted) {
        checkMustBe(tr, STUDENT_CODE, PERSON_FORMATEDNAME, PERSON_GENDER, PERSON_CODE, PERSON_IDTYPE,
          STATE_GRADE, STUDENT_STUDYTYPE, STUDENT_DURATION, STATE_DEPARTMENT, STUDENT_EDUCATION, STUDENT_STDTYPE, STATE_MAJOR, STATE_CAMPUS,
          STUDENT_REGISTED, STUDENT_BEGINON, STUDENT_ENDON, STATE_STATUS, STUDENT_GRADUATE_ON)
      } else { // 如果已经存在该学生的Person信息，则有关person的字段将忽略
        checkMustBe(tr, STUDENT_CODE, STATE_GRADE, STUDENT_STUDYTYPE, STUDENT_DURATION, STATE_DEPARTMENT, STUDENT_EDUCATION, STUDENT_STDTYPE, STATE_MAJOR, STATE_CAMPUS,
          STUDENT_REGISTED, STUDENT_BEGINON, STUDENT_ENDON, STATE_STATUS, STUDENT_GRADUATE_ON)
      }
    }
    // 检查带格式的字段值
    checkLength(tr, 18, PERSON_CODE)
    checkLength(tr, 100, STUDENT_CODE, PERSON_FORMATEDNAME)
    checkLength(tr, 7, STATE_GRADE)
    checkFormatByFloat(tr, STUDENT_DURATION)
    checkBoolean(tr, STUDENT_REGISTED, STATE_INSCHOOL)
    // 检查“学籍生效日期”和“学籍失效日期”之区间
    val beginOn = TemporalConverter.convert(data.get(STUDENT_BEGINON).orNull.asInstanceOf[String], classOf[LocalDate])
    val endOn = TemporalConverter.convert(data.get(STUDENT_ENDON).orNull.asInstanceOf[String], classOf[LocalDate])
    if (null != beginOn && (beginOn.isAfter(endOn) || beginOn == endOn)) {
      tr.addFailure("所填写的“" + tr.transfer.asInstanceOf[AbstractImporter].description(STUDENT_BEGINON) + "”和“" + tr.transfer.asInstanceOf[AbstractImporter].description(STUDENT_ENDON) + "”之日期区间无效！", STUDENT_BEGINON + "[" + sdf.format(beginOn) + "], " + STUDENT_ENDON + "[" + sdf.format(endOn) + "]")
    }
  }

  private def checkMustBe(tr: ImportResult, fieldNames: String*): Unit = {
    fieldNames.foreach(fieldName => {
      val value = tr.transfer.curData.get(fieldName).orNull
      if value == null then
        tr.addFailure("“" + fieldName + tr.transfer.asInstanceOf[AbstractImporter].description(fieldName) + "”没有填写！", "")
    })
  }

  private def checkLength(tr: ImportResult, length: Int, fieldNames: String*): Unit = {
    fieldNames.foreach(fieldName => {
      val value = tr.transfer.curData.get(fieldName).orNull.asInstanceOf[String]
      if (value != null && value.length > length) {
        tr.addFailure("所填“" + tr.transfer.asInstanceOf[AbstractImporter].description(fieldName) + "”的长度不符合要求！", "[" + value + "]")
      }
    })
  }

  private def checkFormatByFloat(tr: ImportResult, fieldNames: String*): Unit = {
    fieldNames.foreach(fieldName => {
      val value = tr.transfer.curData.get(fieldName).orNull.asInstanceOf[String]
      if (value != null) {
        try tr.transfer.curData.put(fieldName, value.toFloat)
        catch {
          case e: Exception =>
            tr.addFailure("所填“" + tr.transfer.asInstanceOf[AbstractImporter].description(fieldName) + "”格式错误！", "[" + value + "]")
        }
      }
    })
  }

  private def checkBoolean(tr: ImportResult, fieldNames: String*): Unit = {
    fieldNames.foreach(fieldName => {
      val value = tr.transfer.curData.get(fieldName).orNull.asInstanceOf[String]
      if (value != null) {
        if (util.Arrays.asList("Y", "N").contains(value)) {
          tr.transfer.curData.put(fieldName, value.equals("Y"))
        }
        else tr.addFailure("所填“" + tr.transfer.asInstanceOf[AbstractImporter].description(fieldName) + "”格式错误！", "[" + value + "]")
      }
    })
  }

  private def getStdUserCode(data: collection.Map[String, Any], std: Student): String = {
    data.get("user.code") match
      case Some(code) =>
        if (Strings.isNotBlank(code.toString)) {
          code.toString.trim()
        } else {
          if std.user == null then std.code else std.user.code
        }
      case None =>
        if std.user == null then std.code else std.user.code
  }

  override def onItemFinish(tr: ImportResult): Unit = {
    val data = tr.transfer.curData
    val mImporter = transfer.asInstanceOf[MultiEntityImporter]
    val student = mImporter.getCurrent("student").asInstanceOf[Student]
    val person = mImporter.getCurrent("person").asInstanceOf[Person]
    val state = mImporter.getCurrent("state").asInstanceOf[StudentState]
    val examinee = mImporter.getCurrent("examinee").asInstanceOf[Examinee]
    val contact = mImporter.getCurrent("contact").asInstanceOf[Contact]
    if (!student.persisted) {
      val personCode = data.get(PERSON_CODE).orNull.asInstanceOf[String]
      val stdName = data.get(PERSON_FORMATEDNAME).orNull.asInstanceOf[String]
      person.code = personCode
      person.name = stdName
      person.updatedAt = Instant.now()
      student.gender = person.gender
      student.project = project
      student.person = person
      student.updatedAt = Instant.now()

      state.beginOn = student.beginOn
      state.endOn = student.endOn
      student.maxEndOn = student.endOn
      putStateInStudent(student, state)
      student.calcCurrentState()
    }
    userRepo.createUser(student, getStdUserCode(data, student), None)
    entityDao.saveOrUpdate(person, student)

    val tutorCodes = data.get("tutor.code").orNull.asInstanceOf[String]
    updateTutors(student, tutorCodes, tr)

    val advisorCode = data.get("advisor.code").orNull.asInstanceOf[String]
    updateAdvisor(student, advisorCode, tr)
    entityDao.saveOrUpdate(student)

    if (null != contact) {
      contact.std = student
      contact.updatedAt = Instant.now
      entityDao.saveOrUpdate(contact)
    }
    if (null != examinee) {
      examinee.std = student
      examinee.updatedAt = Instant.now
      entityDao.saveOrUpdate(examinee)
    }
  }

  /** 更新学生导师
   *
   * @param std
   * @param staffCodeName
   * @param tr
   * @return
   */
  private def updateTutors(std: Student, staffCodeName: String, tr: ImportResult): Unit = {
    if Strings.isNotBlank(staffCodeName) then
      val query = OqlBuilder.from(classOf[Teacher], "t")
      query.where("t.staff.school = :school", project.school)
      val names = Strings.split(staffCodeName, ",")
      if (names.length == 1) {
        query.where("t.staff.code = :code or t.staff.name = :name", staffCodeName, staffCodeName)
      } else {
        query.where("t.staff.code in(:codes) or t.staff.name in (:names)", names, names)
      }
      val tutors = entityDao.search(query)
      if (tutors.nonEmpty) {
        std.updateTutors(tutors, Tutorship.Major)
      } else {
        tr.addFailure("找不到导师", staffCodeName)
      }
  }

  private def updateAdvisor(std: Student, staffCodeName: String, tr: ImportResult): Unit = {
    if Strings.isNotBlank(staffCodeName) then
      val query = OqlBuilder.from(classOf[Teacher], "t")
      query.where("t.staff.school = :school", project.school)
      query.where("t.staff.code = :code or t.staff.name =:name", staffCodeName, staffCodeName)
      val tutors = entityDao.search(query)
      if (tutors.size == 1) {
        std.updateTutors(tutors, Tutorship.Thesis)
      } else {
        tr.addFailure("找不到指导老师", staffCodeName)
      }
  }

  private def putStateInStudent(student: Student, state: StudentState): Unit = {
    state.squad.foreach(squad =>
      if state.department == null then state.department = squad.department
      if state.major == null then state.major = squad.major.orNull
      if state.direction.isEmpty then state.direction = squad.direction
      if null == state.campus then state.campus = squad.campus.orNull
    )
    if (!state.persisted) state.inschool = true
    state.std = student
    student.states += state
  }
}

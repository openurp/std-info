/*
 * Copyright (C) 2005, The OpenURP Software.
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

package org.openurp.std.info.listener

import org.beangle.commons.collection.Collections
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.data.transfer.importer.{AbstractImporter, ImportListener, ImportResult, MultiEntityImporter}
import org.openurp.base.code.model.UserCategory
import org.openurp.base.edu.model._
import org.openurp.base.model.{Person, User}
import org.openurp.base.service.UrpUserService
import org.openurp.edu.eams.security.EamsUserCategory
import org.openurp.std.info.model.{Contact, Examinee}

import java.time.format.DateTimeFormatter
import java.time.{Instant, LocalDate}
import java.util
import scala.util.control.Breaks.{break, breakable}

class StudentImporterListener(entityDao: EntityDao, urpUserService: UrpUserService, currProject: Project) extends ImportListener {

  override def onStart(tr: ImportResult): Unit = {}

  override def onFinish(tr: ImportResult): Unit = {}

  var sdf = DateTimeFormatter.ofPattern("yyyyMMdd")
  var entityCacheMap = Collections.newMap[String, Any]

  final private val STUDENT_CODE: String = "stdCode"
  final private val PERSON_FORMATEDNAME: String = "stdName"
  final private val PERSON_GENDER: String = "person.gender.name"
  final private val PERSON_BIRTHDAY: String = "person.birthday"
  final private val PERSON_NATION: String = "person.nation"
  final private val PERSON_CODE: String = "personCode"
  final private val PERSON_IDTYPE: String = "person.idType.name"
  final private val PERSON_POLITICALSTATUS: String = "person.politicalStatus.name"
  final private val STATE_GRADE: String = "state.grade"
  final private val STUDENT_STUDYTYPE: String = "student.studyType.name"
  final private val STUDENT_DURATION: String = "student.duration"
  final private val STATE_DEPARTMENT: String = "state.department.name"
  final private val STUDENT_EDUCATION: String = "student.level.name"
  final private val STUDENT_STDTYPE: String = "student.stdType.name"
  final private val STATE_MAJOR: String = "state.major.name"
  final private val STATE_DIRECTION: String = "state.direction.name"
  final private val STATE_CAMPUS: String = "state.campus.name"
  final private val STATE_ADMINCLASS: String = "state.squad.name"
  final private val STUDENT_REGISTED: String = "student.registed"
  final private val STATE_INSCHOOL: String = "state.inschool"
  final private val STUDENT_BEGINON: String = "student.beginOn"
  final private val STUDENT_ENDON: String = "student.endOn"
  final private val STUDENT_GRADUATE_ON: String = "student.graduateOn"
  final private val STATE_STATUS: String = "state.status.name"

  override def onItemStart(tr: ImportResult): Unit = {
    val code = tr.transfer.curData.get(STUDENT_CODE).orNull.asInstanceOf[String]
    val personCode = tr.transfer.curData.get(PERSON_CODE).orNull.asInstanceOf[String]
    val newMap = Collections.newMap[String, AnyRef]
    val stdBuilder = OqlBuilder.from(classOf[Student], "std")
    stdBuilder.where("std.user.code=:code", code)
    stdBuilder.where("std.project=:project", currProject)
    val stds = entityDao.search(stdBuilder)
    if (stds.nonEmpty) {
      val student = stds(0)
      newMap.put("student", student)
      student.state.foreach(state => {
        newMap.put("state", state)
      })
    }
    val people = entityDao.findBy(classOf[Person], "code", List(personCode))
    if (people.nonEmpty) {
      newMap.put("person", people(0))
    }
    tr.transfer.current_=(newMap)
    checkMustBe(tr, PERSON_CODE)
    checkLength(tr, 18, PERSON_CODE)
    //   原来的importer.getDescriptions().get(fieldName) 可以尝试换成tr.transfer.asInstanceOf[AbstractImporter].description()
    if (people.isEmpty) {
      checkMustBe(tr, STUDENT_CODE, PERSON_FORMATEDNAME, PERSON_GENDER, PERSON_BIRTHDAY, PERSON_CODE, PERSON_IDTYPE,
        STATE_GRADE, STUDENT_STUDYTYPE, STUDENT_DURATION, STATE_DEPARTMENT, STUDENT_EDUCATION, STUDENT_STDTYPE, STATE_MAJOR, STATE_CAMPUS,
        STUDENT_REGISTED, STATE_INSCHOOL, STUDENT_BEGINON, STUDENT_ENDON, STATE_STATUS, STUDENT_GRADUATE_ON)
    }
    else {
      // 如果已经存在该学生的Person信息，则有关person的字段将忽略
      checkMustBe(tr, STUDENT_CODE, STATE_GRADE, STUDENT_STUDYTYPE, STUDENT_DURATION, STATE_DEPARTMENT, STUDENT_EDUCATION, STUDENT_STDTYPE, STATE_MAJOR, STATE_CAMPUS,
        STUDENT_REGISTED, STATE_INSCHOOL, STUDENT_BEGINON, STUDENT_ENDON, STATE_STATUS, STUDENT_GRADUATE_ON)
    }
    // 检查带格式的字段值
    checkLength(tr, 100, STUDENT_CODE, PERSON_FORMATEDNAME)
    checkLength(tr, 7, STATE_GRADE)
    checkFormatByFloat(tr, STUDENT_DURATION)
    checkBoolean(tr, STUDENT_REGISTED, STATE_INSCHOOL)
    // 检查“学籍生效日期”和“学籍失效日期”之区间
    val beginOn = LocalDate.parse(tr.transfer.curData.get(STUDENT_BEGINON).orNull.asInstanceOf[String], sdf)
    val endOn = LocalDate.parse(tr.transfer.curData.get(STUDENT_ENDON).orNull.asInstanceOf[String], sdf)
    if (beginOn.isAfter(endOn) || beginOn == endOn) {
      tr.addFailure("所填写的“" + tr.transfer.asInstanceOf[AbstractImporter].description(STUDENT_BEGINON) + "”和“" + tr.transfer.asInstanceOf[AbstractImporter].description(STUDENT_ENDON) + "”之日期区间无效！", STUDENT_BEGINON + "[" + sdf.format(beginOn) + "], " + STUDENT_ENDON + "[" + sdf.format(endOn) + "]")
    }
  }

  override def onItemFinish(tr: ImportResult): Unit = {
    val student = tr.transfer.asInstanceOf[MultiEntityImporter].getCurrent("student").asInstanceOf[Student]
    val person = transfer.asInstanceOf[MultiEntityImporter].getCurrent("person").asInstanceOf[Person]
    val state = transfer.asInstanceOf[MultiEntityImporter].getCurrent("state").asInstanceOf[StudentState]
    val personCode = transfer.curData.get(PERSON_CODE).orNull.asInstanceOf[String]
    val stdName = transfer.curData.get(PERSON_FORMATEDNAME).orNull.asInstanceOf[String]
    person.code = personCode
    person.name.formatedName = stdName
    person.updatedAt = Instant.now()
    student.person = person
    student.project = currProject
    student.updatedAt = Instant.now()
    state.beginOn = student.beginOn
    state.endOn = Option(student.endOn)
    putStateInStudent(student, state)
    if (student.studyOn == null) {
      student.studyOn = student.beginOn
    }
    try pointCurrentState(student)
    catch {
      case e: Exception =>
        e.printStackTrace()
    }
    putPersonInStudent(student, person, state)
    entityDao.saveOrUpdate(person)
    entityDao.saveOrUpdate(student.user, student)
    val mobile = tr.transfer.curData.get("contact.mobile").orNull.asInstanceOf[String]
    val email = tr.transfer.curData.get("contact.email").orNull.asInstanceOf[String]
    val address = tr.transfer.curData.get("contact.address").orNull.asInstanceOf[String]
    if (mobile != null || email != null || address != null) {
      val contacts = entityDao.findBy(classOf[Contact], "std", List(student))
      val contact = if (!contacts.isEmpty) contacts(0) else new Contact
      contact.std = student
      contact.updatedAt = Instant.now
      if (mobile != null) {
        contact.mobile = Option(mobile)
        student.user.mobile = Option(mobile)
      }
      if (email != null) {
        contact.email = Option(email)
        student.user.email = Option(email)
      }
      if (address != null) {
        contact.address = Option(address)
      }
      entityDao.saveOrUpdate(contact)
    }
    val examNo = tr.transfer.curData.get("examinee.examNo").orNull.asInstanceOf[String]
    val examineeCode = tr.transfer.curData.get("examinee.code").orNull.asInstanceOf[String]
    if (examineeCode != null || examNo != null) {
      val examinees = entityDao.findBy(classOf[Examinee], "std", List(student))
      val examinee = if (!examinees.isEmpty) examinees(0) else new Examinee
      examinee.std = student
      examinee.updatedAt = Instant.now
      if (examineeCode != null) {
        examinee.code = examineeCode
      }
      if (examNo != null) {
        examinee.examNo = Option(examNo)
      }
      entityDao.saveOrUpdate(examinee)
    }
    if (null != urpUserService) {
      //Fixme xinzhou 权限系统里面创建账户方法先忽略
      //      urpUserService.createStudentUser(student)
    }
  }

  /**
   * 将学籍状态记录日志中的某个符合要求学籍状态记录置为当前学籍状态
   *
   * @throws Exception
   */
  @throws[Exception]
  def pointCurrentState(std: Student): Unit = {
    if (std.states.isEmpty) throw new IllegalArgumentException("states is empty!!!")
    val f = DateTimeFormatter.ofPattern("yyyyMMdd")
    val now = f.format(LocalDate.now()).toLong
    val nowDate = LocalDate.now()
    var distance = Long.MaxValue
    var last: StudentState = null
    breakable {
      std.states.foreach(state => {
        if (nowDate.isAfter(state.beginOn) && (state.endOn.isEmpty || nowDate.isBefore(state.endOn.get))) {
          last = state
          break //todo: break is not supported
        }
        state.endOn.foreach(endOn => {
          val middle = (f.format(endOn).toLong + f.format(state.beginOn).toLong) / 2
          val d = Math.abs(now - middle)
          if (d < distance) {
            distance = d
            last = state
          }
        })
      })
    }
    std.state = Option(last)
  }

  private def checkMustBe(tr: ImportResult, fieldNames: String*): Unit = {
    fieldNames.foreach(fieldName => {
      val value = tr.transfer.curData.get(fieldName).orNull.asInstanceOf[String]
      if (value == null) {
        tr.addFailure("“" + tr.transfer.asInstanceOf[AbstractImporter].description(fieldName) + "”没有填写！", "[" + value + "]")
      }
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

  private def putPersonInStudent(student: Student, person: Person, state: StudentState): Unit = {
    val stdCode = transfer.curData.get(STUDENT_CODE).orNull.asInstanceOf[String]
    val stdName = transfer.curData.get(PERSON_FORMATEDNAME).orNull.asInstanceOf[String]
    if (null == student.user || !student.user.persisted) {
      val userBuilder = OqlBuilder.from(classOf[User], "user")
      userBuilder.where("user.code=:code", stdCode)
      userBuilder.where("user.school=:school", currProject.school)
      val users = entityDao.search(userBuilder)
      val user = users.headOption match {
        case Some(value) => value
        case None => {
          val newUser = new User
          newUser.school = currProject.school
          newUser.code = stdCode
          val category = entityDao.get(classOf[UserCategory], EamsUserCategory.STD_USER)
          newUser.category = category
          newUser.email = Option(newUser.code + "@unkown.com")
          newUser.beginOn = student.beginOn
          newUser.endOn = Option(student.endOn)
          newUser
        }
      }
      user.department = state.department
      user.name = stdName
      user.gender = person.gender
      user.updatedAt = Instant.now()
      student.user = user
    }
  }

  private def putStateInStudent(student: Student, state: StudentState): Unit = {
    state.squad.foreach(squad => {
      if (state.department == null) {
        state.department = squad.department
      }
      if (state.major == null) {
        squad.major.foreach(major => {
          state.major = major
        })
      }
      if (state.direction.isEmpty) {
        state.direction = squad.direction
      }
      if (null == state.campus) {
        state.campus = squad.campus
      }
    })
    state.std = student
    student.states.+=:(state)
  }
}

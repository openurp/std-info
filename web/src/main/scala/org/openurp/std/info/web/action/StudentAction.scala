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

package org.openurp.std.info.web.action

import org.beangle.commons.collection.{Collections, Order}
import org.beangle.commons.lang.Strings
import org.beangle.data.dao.{Condition, OqlBuilder}
import org.beangle.data.excel.schema.ExcelSchema
import org.beangle.data.model.Entity
import org.beangle.data.transfer.importer.listener.ForeignerListener
import org.beangle.data.transfer.importer.{DefaultEntityImporter, ImportSetting, MultiEntityImporter}
import org.beangle.web.action.annotation.response
import org.beangle.web.action.view.{Stream, View}
import org.beangle.webmvc.support.helper.PopulateHelper
import org.openurp.base.edu.code.model.{StdLabel, StdType}
import org.openurp.base.edu.model.*
import org.openurp.base.model.{Campus, Department, Person, User}
import org.openurp.base.service.UrpUserService
import org.openurp.base.std.model.{Squad, Student, StudentState}
import org.openurp.code.edu.model.{EducationLevel, StudyType}
import org.openurp.code.person.model.{Gender, IdType, Nation, PoliticalStatus}
import org.openurp.code.std.model.StudentStatus
import org.openurp.edu.eams.security.EamsUserCategory
import org.openurp.std.info.listener.StudentImporterListener
import org.openurp.std.info.model.{Contact, Graduation, Home}

import java.io.{ByteArrayInputStream, ByteArrayOutputStream}
import java.time.format.DateTimeFormatter
import java.time.{Instant, LocalDate}
import scala.util.control.Breaks.{break, breakable}

/**
 * 学籍维护
 */
class StudentAction extends StudentSearchAction {

  var urpUserService: UrpUserService = _

  def add: View = {
    putBasecodeInStdInfo()
    putBasecodeInPersonInfo()
    putBasecodeInStudentState()
    put("project", getProject)
    forward()
  }

  def checkStudentCodeAjax: View = {
    val query = OqlBuilder.from(classOf[Student], "student")
    query.where("student.project = :project", getProject)
    get("personCode").foreach(personCode => {
      query.where("student.person.code = :personCode", personCode)
    })
    put("isOk", entityDao.search(query).isEmpty)
    forward("checkCodeAjax")
  }

  def loadPersonAjax: View = {
    val builder = OqlBuilder.from(classOf[Person], "person")
    get("code").foreach { code => builder.where("person.code = :code", code) }
    put("person", entityDao.unique(builder))
    forward()
  }

  def saveAddInfo: View = {
    val student = populateEntity(classOf[Student], "student")
    val person = student.person
    if (person.persisted) {
      student.person = entityDao.get(classOf[Person], person.id)
    } else {
      person.updatedAt = Instant.now()
    }
    val project = getProject
    val userBuilder = OqlBuilder.from(classOf[User], "user")
    userBuilder.where("user.code=:code", student.user.code)
    userBuilder.where("user.school=:school", project.school)
    val users = entityDao.search(userBuilder)
    val user = users.headOption match {
      case Some(value) => value
      case None =>
        val newUser = new User
        newUser.school = project.school
        newUser.code = student.user.code
        newUser.category.id = EamsUserCategory.STD_USER
        newUser.email = Option(newUser.code + "@unkown.com")
        newUser.beginOn = student.beginOn
        newUser.endOn = Option(student.endOn)
        newUser
    }
    user.department = student.state.get.department
    user.name = student.user.name
    user.gender = student.user.gender
    user.updatedAt = Instant.now()
    person.name.formatedName = user.name
    student.user = user
    val state = student.state.get
    state.beginOn = student.beginOn
    state.endOn = Option(student.endOn)
    student.states += state
    student.updatedAt = Instant.now()
    entityDao.saveOrUpdate(student.user, student.person, student)
    urpUserService.createStudentUser(student)
    redirect("add", "&isOk=" + true, "info.save.success")
  }

  override def editSetting(entity: Student): Unit = {
    put("now", DateTimeFormatter.ofPattern("yyyyMMdd").format(LocalDate.now()).toInt)
    putBasecodeInStdInfo()
    putBasecodeInPersonInfo()
    putEditRestriction()
    super.editSetting(entity)
  }

  //Fixme xinzhou 编辑学籍状态页面专业没有load出来(major3select)
  def studentStateEdit: View = {
    put("student", entityDao.get(classOf[Student], longId("student")))
    putBasecodeInStudentState()
    putEditRestriction()
    getBoolean("isEdit").foreach(isEdit => {
      if (isEdit) {
        val state = populateEntity(classOf[StudentState], "state")
        put("state", state)
      }
    })
    forward("include/studentStateForm")
  }

  def stateDateCheckAjax: View = {
    val student = populateStudentStates(null)
    if (student.states.isEmpty) {
      put("isOk", true)
    }
    else {
      val id = longId("id")
      val beginOn = getDate("beginOn").orNull
      val endOn = getDate("endOn").orNull
      //      put("isOk", studentManager.stateDateCheck(student, id, beginOn, endOn))
    }
    forward("include/stateDateCheckAjax")
  }

  def studentStateSave: View = {
    var student: Student = null
    getBoolean("isClose").foreach { isClose =>
      isClose match {
        case true => student = entityDao.get(classOf[Student], longId("student"))
        case false =>
          student = populateStudentStates(null)
          getBoolean("isRemove").foreach(isRemove => {
            if (isRemove) {
              student.states += (populateEntity(classOf[StudentState], "state"))
            }
          })
          populateLabels(student)
      }
    }
    initStudentStates(student)
    forwardToEdit(student)
  }

  protected def forwardToEdit(student: Student): View = {
    put("student", student)
    getStudentData(student, false)
    putBasecodeInStdInfo()
    putEditRestriction()
    put("now", DateTimeFormatter.ofPattern("yyyyMMdd").format(LocalDate.now()).toInt)
    forward("form")
  }
  //

  /**
   * 得到学生的详细信息
   *
   * @param student TODO
   * @param isPut   TODO
   */
  protected def getStudentData(student: Student, isPut: Boolean): Unit = {
    var std = student
    if (null == std) {
      getLong("student.id").foreach(studentId => {
        std = entityDao.get(classOf[Student], studentId)
      })
    }
    if (null != std) {
      val contacts = entityDao.findBy(classOf[Contact], "std", List(std))
      val homes = entityDao.findBy(classOf[Home], "std", List(std))
      val stdGraduations = entityDao.findBy(classOf[Graduation], "std", List(std))
      if (isPut) {
        put("student", std)
      }
      if (contacts.nonEmpty) {
        put("stdContact", contacts(0))
      }
      if (homes.nonEmpty) {
        put("stdHome", homes(0))
      }
      if (stdGraduations.nonEmpty) {
        put("stdGraduation", stdGraduations(0))
      }
    }
  }

  protected def initStudentStates(student: Student): Unit = {
    val cacheMap = Collections.newMap[String, Any]
    student.states.foreach(state => {
      state.department = loadRealEntity(cacheMap, state.department).asInstanceOf[Department]
      state.major = loadRealEntity(cacheMap, state.major).asInstanceOf[Major]
      state.direction.foreach(direction => state.direction = Option(loadRealEntity(cacheMap, direction).asInstanceOf[Direction]))
      state.squad.foreach(squad => state.squad = Option(loadRealEntity(cacheMap, squad).asInstanceOf[Squad]))
      state.status = loadRealEntity(cacheMap, state.status).asInstanceOf[StudentStatus]
      state.campus = loadRealEntity(cacheMap, state.campus).asInstanceOf[Campus]
    })
  }

  protected def loadRealEntity[T](cacheMap: collection.mutable.Map[String, Any], entity: Entity[T]): Entity[T] = {
    if (null == entity) {
      return null
    }
    try {
      entity.getClass.getDeclaredField("handler")
      return entity
    } catch {
      case e: NoSuchFieldException =>
    }
    val key = entity.getClass.getName + "_" + entity.id
    var o = cacheMap.get(key).asInstanceOf[Entity[T]]
    if (cacheMap.keySet.contains(key)) {
      return o
    }
    o = entityDao.get(entity.getClass, entity.id)
    cacheMap.put(key, o)
    o
  }

  def labelEdit: View = {
    val query = OqlBuilder.from(classOf[StdLabel], "label")
    val values = Collections.newBuffer[AnyRef]
    var i: Int = 0
    while (i > -1) {
      val labelId = getInt("label" + i + ".id")
      if (null != labelId) {
        values.+=(labelId)
      }
      i += 1
    }
    if (values.nonEmpty) {
      var section = ""
      values.indices.foreach(i => {
        if (!section.isBlank) {
          section += " or "
        }
        section += "label1.id = :label" + i
      })
      val sql = new StringBuilder
      sql.append("not exists (")
      sql.append("              from ").append(classOf[StdLabel].getName).append(" label1")
      sql.append("             where (").append(section).append(")")
      sql.append("               and label1.labelType = label.labelType")
      sql.append("           )")
      val condition = new Condition(sql.toString)
      condition.params(values)
      query.where(condition)
    }
    query.orderBy(Order.parse("label.labelType.name, label.name, label.id"))
    put("labels", entityDao.search(query))
    forward("include/labelForm")
  }

  def checkEndOnAjax: View = {
    getLong("id").foreach(stdId => {
      val student = entityDao.get(classOf[Student], stdId)
      val endOn = getDate("endOn")
      val states = student.states.sortBy(e => e.beginOn)
      //      Collections.sort(states, new Comparator[StudentState]() {
      //        override def compare(j1: StudentState, j2: StudentState): Int = {
      //          return j1.getBeginOn.compareTo(j2.getBeginOn)
      //        }
      //      })
      val lastEndOn = states(states.size - 1).endOn
      put("isOk", null != lastEndOn && lastEndOn == endOn)
    })
    forward()
  }

  /**
   * 保存学籍信息
   *
   * @throws Exception
   */
  @throws[Exception]
  def saveStudent: View = {
    val student = populateEntity(classOf[Student], "student")
    populateStudentStates(student)
    val states = student.states
    if (states.isEmpty) {
      logger.error("states is Empty!!!")
      addError("error.parameters.illegal")
      forward("error")
    }
    var earlier = student.endOn
    var first: StudentState = null
    states.foreach(state => {
      if (state.beginOn.isBefore(earlier)) {
        first = state
        earlier = state.beginOn
      }
    })
    if (null != first) {
      first.beginOn = student.beginOn
    }
    pointCurrentState(student)
    populateLabels(student)
    student.updatedAt = Instant.now()
    entityDao.saveOrUpdate(student)
    val person = student.person
    person.updatedAt = Instant.now()
    student.user.gender = person.gender
    person.name.formatedName = student.user.name
    entityDao.saveOrUpdate(person)
    entityDao.saveOrUpdate(student)
    //Fixme xinzhou 权限系统里面创建账户方法先忽略
    //    urpUserService.createStudentUser(student)
    redirect("edit", "&id=" + student.id + "&defaultTab=" + get("defaultTab").orNull, "info.save.success")
  }

  protected def populateStudentStates(hisStudent: Student): Student = {
    var student = hisStudent
    if (null == hisStudent) {
      student = entityDao.get(classOf[Student], longId("student"))
    }
    student.states.clear()
    var i = 0
    while (i > -1) {
      if (get("state" + i + ".id").isEmpty && get("state" + i + ".grade").isEmpty) {
        i = -1
      } else {
        val state = populateEntity(classOf[StudentState], "state" + i)
        if (!state.persisted) {
          state.id = longId("state" + i)
        }
        student.states += state
        i += 1
      }
    }
    student
  }

  protected def populateLabels(hisStudent: Student): Unit = {
    var student = hisStudent
    if (null == student) {
      student = entityDao.get(classOf[Student], longId("student"))
    }
    student.labels.clear()
    var i = 0
    while (i > -1) {
      val label = populateEntity(classOf[StdLabel], "label" + i)
      if !label.persisted then i = -1
      else
        student.labels.put(label.labelType, label)
        i += 1
    }
    // 追加新选的标签
    get("labelIds").foreach(labelIdSeq => {
      val labelIds = Strings.splitToInt(labelIdSeq)
      if (labelIds.nonEmpty) {
        val ids = Collections.newBuffer[Int]
        var statement: String = ""
        labelIds.indices.foreach(i => {
          if (!statement.isBlank) {
            statement += " or "
          }
          statement += "label.id = :label" + i
          ids.+=(labelIds(i))
        })
        val condition = new Condition("(" + statement + ")")
        condition.params(ids)
        val labels = entityDao.search(OqlBuilder.from(classOf[StdLabel], "label").where(condition))
        labels.foreach(label => {
          student.labels.put(label.labelType, label)
        })
      }
    })
  }

  //FIXME xinzhou pointCurrentState方法原本在student模型里面

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
  //
  //  def intoStudentInfoEdit: View = {
  //    getStudentData(null, true)
  //    put("now", new SimpleDateFormat("yyyyMMdd").format(LocalDate.now()).toInt)
  //    putEditRestriction()
  //    putBasecodeInStdInfo()
  //    forward("include/student_info")
  //  }
  //
  //  def intoPersonInfoEdit: View = {
  //    getStudentData(null, true)
  //    putEditRestriction()
  //    putBasecodeInPersonInfo()
  //    forward("include/person_info")
  //  }
  //
  //  def intoGraduationInfoEdit: View = {
  //    val student: Student = entityDao.get(classOf[Student], longId("student"))
  //    put("student", student)
  //    put("graduation", entityDao.unique(OqlBuilder.from(classOf[Graduation], "graduation").where("graduation.std = :student", student)))
  //    putEditRestriction()
  //    putBasecodeInGraduationInfo()
  //    forward("include/graduation_info")
  //  }
  //
  //  protected def putBasecodeInGraduationInfo(): Unit = {
  //    put("educationResults", getCodes(classOf[EducationResult]))
  //    put("degrees", getCodes(classOf[Degree]))
  //  }
  //
  //  def intoContactInfoEdit: View = {
  //    val student: Student = entityDao.get(classOf[Student], longId("student"))
  //    put("student", student)
  //    put("contact", entityDao.unique(OqlBuilder.from(classOf[Contact], "contact").where("contact.std = :studentId)", student)))
  //    putEditRestriction()
  //    forward("include/contact_info")
  //  }
  //
  //  def intoHomeInfoEdit: View = {
  //    val student: Student = entityDao.get(classOf[Student], longId("student"))
  //    put("student", student)
  //    put("home", entityDao.unique(OqlBuilder.from(classOf[Home], "home").where("home.std = :student", student)))
  //    putEditRestriction()
  //    putBasecodeInHomeInfo()
  //    forward("include/home_info")
  //  }
  //
  //  protected def putBasecodeInHomeInfo(): Unit = {
  //    put("railwayStations", getCodes(classOf[RailwayStation]))
  //    // put("economicStates", getCodes(FamilyEconomicState.class));
  //  }
  //

  //  protected def saveNewMembers(home: Home, student: Student): View = {
  //    get("newmember.name").foreach(e => {
  //      val memberName = e.split(",")
  //    })
  //    get("newmember.relation.id").foreach(e => {
  //      val memberRelation = Strings.splitToInt(e)
  //    })
  //    get("newmember.phone").foreach(e => {
  //      val memberPhone = e.split(",")
  //    })
  //    get("newmember.workplace").foreach(e => {
  //      val memberWorkplace = e.split(",")
  //    })
  //    get("newmember.postcode").foreach(e => {
  //      val memberPostcode = e.split(",")
  //    })
  //    get("newmember.address").foreach(e => {
  //      val memberAddress = e.split(",")
  //    })
  //    null
  //  }

  //  protected def editMembers(home: Home, student: Student): View = {
  //    get("member.id").foreach(e => {
  //      val memberIds = Strings.splitToLong(e)
  //    })
  //    get("member.name").foreach(e => {
  //      val memberName = e.split(",")
  //    })
  //    get("member.relation.id").foreach(e => {
  //      val memberRelation = Strings.splitToInt(e)
  //    })
  //    get("member.phone").foreach(e => {
  //      val memberPhone = e.split(",")
  //    })
  //    get("member.workplace").foreach(e => {
  //      val memberWorkplace = e.split(",")
  //    })
  //    get("member.postcode").foreach(e => {
  //      val memberPostcode = e.split(",")
  //    })
  //    get("member.address").foreach(e => {
  //      val memberAddress = e.split(",")
  //    })
  //    null
  //  }

  //
  //  private def getBeforeStdInfo: Student = {
  //    val stdId = getLong("studentId")
  //    if (stdId == null) {
  //      return null
  //    }
  //    val s = studentService.getStudent(stdId.get)
  //    if (s == null) {
  //      return null
  //    }
  //    var before: Student = null
  //    try before = BeanUtils.cloneBean(s).asInstanceOf[Student]
  //    catch {
  //      case e: Exception =>
  //    }
  //    before
  //  }

  //  /**
  //   * 是否已经存在相同学号的学生
  //   *
  //   * @param student
  //   * @return
  //   */
  //  private def alreadyHasStudent(student: Student): Boolean = {
  //    student.persisted && studentService.getStudent(getProject.id, student.user.code) != null
  //  }

  //  private def getBeforeBasic: Person = {
  //    val long1 = getLong("basicInfo.id")
  //    if (long1.isEmpty) {
  //      return null
  //    }
  //    val s = entityDao.get(classOf[Person], long1.get)
  //    var before: Person = null
  //    try before = BeanUtils.cloneBean(s).asInstanceOf[Person]
  //    catch {
  //      case e: Exception =>
  //
  //    }
  //    before
  //  }

  @response
  def downloadTemplate(): Any = {
    val genders = getCodes(classOf[Gender]).sortBy(_.name).map(_.name)
    val nations = getCodes(classOf[Nation]).sortBy(_.name).map(_.name)
    val politicalStatuses = getCodes(classOf[PoliticalStatus]).sortBy(_.name).map(_.name)
    val idTypes = getCodes(classOf[IdType]).sortBy(_.name).map(_.name)
    val studyTypes = getCodes(classOf[StudyType]).sortBy(_.name).map(_.name)
    val departments = getProject.departments.sortBy(_.name).map(_.name)
    val levels = getProject.levels.sortBy(_.name).map(_.name)
    val stdTypes = getProject.stdTypes.sortBy(_.name).map(_.name)
    val majors = findInProject(classOf[Major]).map(_.name)
    val directions = findInProject(classOf[Direction]).map(_.name)
    val campuses = getProject.campuses.sortBy(_.name).map(_.name)
    val squads = findInProject(classOf[Squad]).map(_.name)
    val statuses = getCodes(classOf[StudentStatus]).sortBy(_.name).map(_.name)

    val schema = new ExcelSchema()
    val sheet = schema.createScheet("数据模板")
    sheet.title("新增学籍导入模版")
    sheet.remark("特别说明：\n1、不可改变本表格的行列结构以及批注，否则将会导入失败！\n2、必须按照规格说明的格式填写。\n3、可以多次导入，重复的信息会被新数据更新覆盖。\n4、保存的excel文件名称可以自定。")
    sheet.add("学号", "stdCode").required()
    sheet.add("姓名", "stdName").required()
    sheet.add("性别", "person.gender.name").ref(genders).required()
    sheet.add("出生年月", "person.birthday").required().remark("格式：YYYYMMDD")
    sheet.add("民族", "person.nation.name").ref(nations)
    sheet.add("政治面貌", "person.politicalStatus.name").ref(politicalStatuses)
    sheet.add("证件号码/身份证号", "personCode").required().remark("18位")
    sheet.add("证件类型", "person.idType.name").ref(idTypes).required()
    sheet.add("年级", "state.grade").required().remark("≤7位")
    sheet.add("学习形式", "student.studyType.name").ref(studyTypes).required()
    sheet.add("学制", "student.duration").required()
    sheet.add("院系", "state.department.name").ref(departments).required()
    sheet.add("学历层次", "student.level.name").ref(levels).required()
    sheet.add("学生类别", "student.stdType.name").ref(stdTypes).required()
    sheet.add("专业", "state.major.name").ref(majors).required()
    sheet.add("专业方向", "state.direction.name").ref(directions)
    sheet.add("校区", "state.campus.name").ref(campuses).required()
    sheet.add("行政班级", "state.squad.name").ref(squads)
    sheet.add("学历生", "student.registed").required().remark("Y|N")
    sheet.add("是否在校", "state.inschool").required().remark("Y|N")
    sheet.add("学籍生效日期", "student.beginOn").required().remark("格式：YYYYMMDD")
    sheet.add("预计毕业日期", "student.graduateOn").required()
    sheet.add("学籍失效日期", "student.endOn").required().remark("格式：YYYYMMDD")
    sheet.add("学籍状态", "state.status.name").ref(statuses).required()
    sheet.add("手机", "contact.mobile")
    sheet.add("联系地址", "contact.address")
    sheet.add("电子邮箱", "contact.mail")
    sheet.add("考生号", "examinee.code")
    sheet.add("准考证号", "examinee.examNo")

    val code = schema.createScheet("数据字典")
    code.add("性别").data(genders)
    code.add("民族").data(nations)
    code.add("政治面貌").data(politicalStatuses)
    code.add("证件类型").data(idTypes)
    code.add("学习形式").data(studyTypes)
    code.add("院系").data(departments)
    code.add("学历层次").data(levels)
    code.add("学生类别").data(stdTypes)
    code.add("专业").data(majors)
    code.add("专业方向").data(directions)
    code.add("校区").data(campuses)
    code.add("行政班级").data(squads)
    code.add("学籍状态").data(statuses)

    val os = new ByteArrayOutputStream()
    schema.generate(os)
    Stream(new ByteArrayInputStream(os.toByteArray), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "新增学籍导入模版.xlsx")
  }

  protected override def configImport(setting: ImportSetting): Unit = {
    val fl = new ForeignerListener(entityDao)
    fl.addForeigerKey("name")
    val importer = new MultiEntityImporter
    importer.domain = this.entityDao.domain
    importer.populator = PopulateHelper.populator
    importer.addEntity("student", classOf[Student])
    importer.addEntity("person", classOf[Person])
    importer.addEntity("state", classOf[StudentState])
    setting.importer = importer
    setting.listeners = List(fl, new StudentImporterListener(entityDao, urpUserService, getProject))
    setting.listeners foreach { l =>
      importer.addListener(l)
    }
  }
}

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

import org.beangle.commons.codec.digest.Digests
import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Charsets
import org.beangle.commons.net.http.HttpUtils
import org.beangle.data.dao.OqlBuilder
import org.beangle.doc.excel.schema.ExcelSchema
import org.beangle.doc.transfer.exporter.ExportContext
import org.beangle.doc.transfer.importer.listener.ForeignerListener
import org.beangle.doc.transfer.importer.{ImportSetting, MultiEntityImporter}
import org.beangle.ems.app.Ems
import org.beangle.web.action.annotation.{ignore, mapping, response}
import org.beangle.web.action.view.{Stream, View}
import org.beangle.webmvc.support.action.{ExportSupport, ImportSupport, RestfulAction}
import org.beangle.webmvc.support.helper.PopulateHelper
import org.openurp.base.edu.model.*
import org.openurp.base.model.*
import org.openurp.base.service.Features
import org.openurp.base.std.model.*
import org.openurp.code.edu.model.{EducationMode, EnrollMode, StudyType}
import org.openurp.code.geo.model.{Country, Division}
import org.openurp.code.person.model.{Gender, IdType, Nation, PoliticalStatus}
import org.openurp.code.std.model.{StdLabel, StudentStatus}
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.model.{Contact, Examinee, Home}
import org.openurp.std.info.service.StudentPropertyExtractor
import org.openurp.std.info.web.helper.{EntityMeta, PropertyMeta, StdSearchHelper, UserHelper}
import org.openurp.std.info.web.listener.StudentImporterListener

import java.io.{ByteArrayInputStream, ByteArrayOutputStream}
import java.net.URLEncoder
import java.time.format.DateTimeFormatter
import java.time.{Instant, LocalDate}

/**
 * 学籍维护
 */
class StudentAction extends RestfulAction[Student], ExportSupport[Student], ImportSupport[Student], ProjectSupport {

  var userHelper: UserHelper = _

  override def indexSetting(): Unit = {
    given project: Project = getProject

    put("tutorSupported", getConfig(Features.Std.TutorSupported))
    put("advisorSupported", getConfig(Features.Std.AdvisorSupported))

    put("departments", project.departments) // 院系部门
    put("levels", project.levels) // 培养层次
    put("stdTypes", project.stdTypes)
    put("majors", findInProject(classOf[Major]))
    put("genders", getCodes(classOf[Gender])) // 性别
    put("states", getCodes(classOf[StudentStatus])) // 状态
    put("campuses", findInSchool(classOf[Campus]))

    put("studyTypes", getCodes(classOf[StudyType]))
    put("stdLabels", getCodes(classOf[StdLabel]))
    super.indexSetting()
  }

  override def getQueryBuilder: OqlBuilder[Student] = {
    given project: Project = getProject

    put("squadSupported", getConfig(Features.Std.SquadSupported))
    put("tutorSupported", getConfig(Features.Std.TutorSupported))
    val builder = new StdSearchHelper(entityDao, project, getDeparts)
    builder.build()
  }

  protected override def editSetting(student: Student): Unit = {
    given project: Project = getProject

    put("project", project)

    put("stdLabels", project.stdLabels)
    put("departments", project.departments)
    put("majors", entityDao.findBy(classOf[Major], "project", project))
    put("directions", entityDao.findBy(classOf[Direction], "project", project))
    put("squads", entityDao.findBy(classOf[Squad], "project", project))

    if (student.persisted) {
      val examinee = entityDao.findBy(classOf[Examinee], "std", student).headOption.getOrElse(new Examinee)
      put("examinee", examinee)
    } else {
      put("examinee", new Examinee)
    }

    put("divisions", getCodes(classOf[Division]))

    put("EMS", Ems)
    put("now", DateTimeFormatter.ofPattern("yyyyMMdd").format(LocalDate.now()).toInt)
    put("api", Ems.api)
    put("squadSupported", getConfig(Features.Std.SquadSupported))
    put("advisorSupported", getConfig(Features.Std.AdvisorSupported))
  }

  /**
   * 显示导出字段
   *
   * @return
   */
  def displayExpAttrs(): View = {
    given project: Project = getProject

    val squadSupported = getConfig(Features.Std.SquadSupported).asInstanceOf[Boolean]
    val tutorSupported = getConfig(Features.Std.TutorSupported).asInstanceOf[Boolean]
    val advisorSupported = getConfig(Features.Std.AdvisorSupported).asInstanceOf[Boolean]

    val std = EntityMeta(classOf[Student].getName, "学籍信息", Collections.newBuffer[PropertyMeta])
    std.add("code" -> "学号", "name" -> "姓名", "state.grade.code" -> "年级")
    std.add("studyType.name" -> "学习形式", "duration" -> "学制", "level.name" -> "培养层次")
    std.add("stdType.name" -> "学生类别", "eduType.name" -> "培养类型", "level.name" -> "培养层次")
    std.add("state.department.name" -> "院系", "state.major.name" -> "专业", "state.direction.name" -> "专业方向")
    std.add("state.campus.name" -> "校区", "registed" -> "学历生", "beginOn" -> "学籍生效日期", "endOn" -> "学籍失效日期")
    std.add("maxEndOn" -> "学籍最晚失效日期", "remark" -> "备注")
    std.add("studyOn" -> "入校日期", "graduateOn" -> "预计毕业日期", "state.status.name" -> "学籍状态")
    if squadSupported then std.add("state.squad.name", "行政班级")
    if tutorSupported then std.add("tutor.name", "导师姓名")
    if advisorSupported then std.add("advisor.name", "学位论文导师姓名")

    val p = EntityMeta(classOf[Person].getName, "基本信息", Collections.newBuffer[PropertyMeta])
    p.add("gender.name" -> "性别", "birthday" -> "出生日期", "nation.name" -> "民族", "country.name" -> "国家地区")
    p.add("idType.name" -> "证件类型", "code" -> "证件号码", "politicalStatus.name" -> "政治面貌", "homeTown" -> "籍贯")

    val contact = EntityMeta(classOf[Contact].getName, "联系信息", Collections.newBuffer[PropertyMeta])
    contact.add("mobile", "手机")
    contact.add("address", "联系地址")
    contact.add("email", "电子邮箱")

    val examinee = EntityMeta(classOf[Examinee].getName, "考生信息", Collections.newBuffer[PropertyMeta])
    examinee.add("code" -> "考生号", "examNo" -> "准考证号", "educationMode.name" -> "培养方式")
    examinee.add("originDivision.name" -> "生源地", "schoolName" -> "毕业学校", "graduateOn" -> "毕业日期")
    examinee.add("score" -> "录取成绩", "enrollMode.name" -> "入学方式")
    if tutorSupported then
      examinee.add("client" -> "委培单位")

    put("std", std)
    put("person", p)
    put("contact", contact)
    put("examinee", examinee)
    forward()
  }

  @ignore
  override def configExport(context: ExportContext): Unit = {
    context.extractor = new StudentPropertyExtractor(entityDao)
    super.configExport(context)
  }

  @mapping(value = "{id}")
  override def info(id: String): View = {
    val student = entityDao.get(classOf[Student], id.toLong)
    put("contact", entityDao.findBy(classOf[Contact], "std", student).headOption)
    put("home", entityDao.findBy(classOf[Home], "std", student).headOption)
    put("examinee", entityDao.findBy(classOf[Examinee], "std", student).headOption)
    put("graduate", entityDao.findBy(classOf[Graduate], "std", student).headOption)
    put("avatarUrl", Ems.api + "/platform/user/avatars/" + Digests.md5Hex(student.code))
    super.info(id)
  }

  def saveAddInfo(): View = {
    val student = populateEntity(classOf[Student], "student")
    var person = populateEntity(classOf[Person], "person")
    val state = populateEntity(classOf[StudentState], "state")
    person.updatedAt = Instant.now()

    if (person.code != null) {
      person = entityDao.findBy(classOf[Person], "code", person.code).headOption.getOrElse(person)
    }
    val project = getProject
    person.name.formattedName = student.name
    student.registed = true
    student.project = project
    student.gender = person.gender
    student.person = person

    state.std = student
    student.state = Some(state)
    state.beginOn = student.beginOn
    state.endOn = student.endOn
    state.inschool = true
    student.states += state
    state.std = student
    student.updatedAt = Instant.now()
    student.maxEndOn = student.endOn
    entityDao.saveOrUpdate(student.person, student)
    userHelper.createUser(student, None)
    redirect("search", "&isOk=" + true, "info.save.success")
  }

  /**
   * 保存学籍信息
   *
   * @throws Exception
   */
  @throws[Exception]
  override def save(): View = {
    val student = populateEntity(classOf[Student], "student")
    val state = populateEntity(classOf[StudentState], "state")
    var earlier = student.endOn
    var first: StudentState = null
    student.states.foreach(state => {
      if (state.beginOn.isBefore(earlier)) {
        first = state
        earlier = state.beginOn
      }
    })
    if (null != first) {
      first.beginOn = student.beginOn
    }
    student.calcCurrentState()
    student.updatedAt = Instant.now()
    val person = student.person
    populate(person, "person")
    person.updatedAt = Instant.now()
    student.gender = person.gender
    person.name.formattedName = student.name
    entityDao.saveOrUpdate(person, student)
    userHelper.createUser(student, None)

    val examinee = populateEntity(classOf[Examinee], "examinee")
    if (examinee.code != null) {
      examinee.updatedAt = Instant.now()
      examinee.std = student
      entityDao.saveOrUpdate(examinee)
    }
    redirect("search", "info.save.success")
  }

  /**
   * 批量更新学生姓名拼音
   *
   * @return
   */
  def batchUpdateEnName(): View = {
    val stds = entityDao.find(classOf[Student], getLongIds("student"))
    val forceUpdate = getBoolean("forceUpdate", false)
    val people = Collections.newBuffer[Person]
    stds foreach { std =>
      if (std.enName.isEmpty || forceUpdate) {
        val response = HttpUtils.getText(Ems.api + "/tools/sns/person/pinyin/" + URLEncoder.encode(std.name, Charsets.UTF_8) + ".json")
        if (response.isOk) {
          val enName = response.getText.trim
          std.enName = Some(enName)
          std.person.phoneticName = std.enName
          people += std.person
        }
      }
    }
    entityDao.saveOrUpdate(stds, people)
    redirect("search", "info.save.success")
  }

  @response
  def downloadTemplate(): Any = {
    given project: Project = getProject

    val squadSupported = getConfig(Features.Std.SquadSupported).asInstanceOf[Boolean]
    val tutorSupported = getConfig(Features.Std.TutorSupported).asInstanceOf[Boolean]
    val advisorSupported = getConfig(Features.Std.AdvisorSupported).asInstanceOf[Boolean]
    //features.std.info.tutorSupported

    val genders = getCodes(classOf[Gender]).sortBy(_.code).map(x => x.code + " " + x.name)
    val nations = getCodes(classOf[Nation]).sortBy(_.code).map(x => x.code + " " + x.name)
    val countries = getCodes(classOf[Country]).sortBy(_.code).map(x => x.code + " " + x.name)
    val divisions = getCodes(classOf[Division]).sortBy(_.code).map(x => x.code + " " + x.name)
    val politicalStatuses = getCodes(classOf[PoliticalStatus]).sortBy(_.code).map(x => x.code + " " + x.name)
    val idTypes = getCodes(classOf[IdType]).sortBy(_.code).map(x => x.code + " " + x.name)
    val studyTypes = getCodes(classOf[StudyType]).sortBy(_.code).map(x => x.code + " " + x.name)
    val eduModes = getCodes(classOf[EducationMode]).sortBy(_.code).map(x => x.code + " " + x.name)
    val enrollModes = getCodes(classOf[EnrollMode]).sortBy(_.code).map(x => x.code + " " + x.name)
    val departments = project.departments.map(x => x.code + " " + x.name).toSeq.sorted
    val levels = project.levels.map(x => x.code + " " + x.name).toSeq.sorted
    val eduTypes = project.eduTypes.map(x => x.code + " " + x.name).toSeq.sorted
    val stdTypes = project.stdTypes.map(x => x.code + " " + x.name).toSeq.sorted
    val majors = findInProject(classOf[Major]).map(x => x.code + " " + x.name)
    val grades = findInProject(classOf[Grade]).map(x => x.code)
    val directions = findInProject(classOf[Direction]).map(x => x.code + " " + x.name)
    val campuses = project.campuses.map(x => x.code + " " + x.name).toSeq.sorted
    val statuses = getCodes(classOf[StudentStatus]).sortBy(_.code).map(x => x.code + " " + x.name)

    val schema = new ExcelSchema()
    val sheet = schema.createScheet("数据模板")
    sheet.title("新增学籍导入模版")
    sheet.remark("特别说明：\n1、不可改变本表格的行列结构以及批注，否则将会导入失败！\n2、必须按照规格说明的格式填写。\n3、可以多次导入，重复的信息会被新数据更新覆盖。\n4、保存的excel文件名称可以自定。")
    sheet.add("学号", "student.code").required()
    sheet.add("姓名", "student.name").required()
    sheet.add("性别", "person.gender.code").ref(genders).required()
    sheet.add("出生年月", "person.birthday").required().remark("格式：YYYYMMDD")
    sheet.add("民族", "person.nation.code").ref(nations)
    sheet.add("国家地区", "person.country.code").ref(countries)
    sheet.add("籍贯", "person.homeTown")
    sheet.add("政治面貌", "person.politicalStatus.code").ref(politicalStatuses)
    sheet.add("证件号码", "person.code").required().remark("18位")
    sheet.add("证件类型", "person.idType.code").ref(idTypes).required()
    sheet.add("年级", "state.grade.code").ref(grades).required().remark("≤7位")
    sheet.add("学习形式", "student.studyType.code").ref(studyTypes).required()
    sheet.add("学制", "student.duration").required()
    sheet.add("院系", "state.department.code").ref(departments).required()
    sheet.add("培养层次", "student.level.code").ref(levels).required()
    sheet.add("培养类型", "student.eduType.code").ref(eduTypes).required()
    sheet.add("学生类别", "student.stdType.code").ref(stdTypes).required()
    sheet.add("专业", "state.major.code").ref(majors).required()
    sheet.add("专业方向", "state.direction.code").ref(directions)
    sheet.add("校区", "state.campus.code").ref(campuses).required()
    if (squadSupported) {
      val squads = findInProject(classOf[Squad]).map(x => x.code + " " + x.name)
      sheet.add("行政班级", "state.squad.code").ref(squads)
    }
    sheet.add("学历生", "student.registed").required().remark("Y|N")
    sheet.add("学籍生效日期", "student.beginOn").required().remark("格式：YYYYMMDD")
    sheet.add("学籍失效日期", "student.endOn").required().remark("格式：YYYYMMDD")
    sheet.add("入校日期", "student.studyOn").required().remark("格式：YYYYMMDD")
    sheet.add("预计毕业日期", "student.graduateOn").required().remark("格式：YYYYMMDD")
    sheet.add("学籍状态", "state.status.code").ref(statuses).required()
    sheet.add("手机", "contact.mobile")
    sheet.add("联系地址", "contact.address")
    sheet.add("电子邮箱", "contact.email")
    sheet.add("考生号", "examinee.code")
    sheet.add("考生毕业学校", "examinee.schoolName")
    sheet.add("考生毕业日期", "examinee.graduateOn").date()
    sheet.add("招生录取成绩", "examinee.score").decimal()
    sheet.add("准考证号", "examinee.examNo")
    sheet.add("入学方式", "examinee.enrollMode.code").ref(enrollModes)
    sheet.add("培养方式", "examinee.educationMode.code").ref(eduModes)
    sheet.add("生源地", "examinee.originDivision.code").ref(divisions)
    sheet.add("委培单位", "examinee.client")

    if (tutorSupported) sheet.add("导师工号或姓名", "tutor.code")
    if (advisorSupported) sheet.add("学位论文导师工号或姓名", "advisor.code")

    val os = new ByteArrayOutputStream()
    schema.generate(os)
    Stream(new ByteArrayInputStream(os.toByteArray), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "学籍信息模版.xlsx")
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
    importer.addEntity("examinee", classOf[Examinee])
    importer.addEntity("contact", classOf[Contact])
    setting.importer = importer
    setting.listeners = List(fl, new StudentImporterListener(entityDao, userHelper.userRepo, getProject))
    setting.listeners foreach { l =>
      importer.addListener(l)
    }
  }

  def checkStudentCodeAjax(): View = {
    val query = OqlBuilder.from(classOf[Student], "student")
    query.where("student.project = :project", getProject)
    get("personCode").foreach(personCode => {
      query.where("student.person.code = :personCode", personCode)
    })
    put("isOk", entityDao.search(query).isEmpty)
    forward("checkCodeAjax")
  }

  def loadPersonAjax(): View = {
    val builder = OqlBuilder.from(classOf[Person], "person")
    get("code").foreach { code => builder.where("person.code = :code", code) }
    put("person", entityDao.first(builder))
    forward()
  }
}

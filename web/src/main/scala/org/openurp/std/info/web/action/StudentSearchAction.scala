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

import org.beangle.commons.codec.digest.Digests
import org.beangle.commons.collection.{Collections, Order}
import org.beangle.data.dao.{Condition, OqlBuilder}
import org.beangle.data.transfer.exporter.ExportSetting
import org.beangle.ems.app.Ems
import org.beangle.ems.meta.{EntityMeta, PropertyMeta}
import org.beangle.security.Securities
import org.beangle.web.action.annotation.{ignore, mapping}
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.edu.code.model.{StdLabel, StdType}
import org.openurp.base.edu.model.*
import org.openurp.base.model.{Campus, Person, User}
import org.openurp.base.std.model.{Squad, Student, StudentState}
import org.openurp.base.std.service.StudentService
import org.openurp.code.edu.model.*
import org.openurp.code.geo.model.{Country, Division, RailwayStation}
import org.openurp.code.person.model.*
import org.openurp.code.std.model.{FeeOrigin, StudentStatus}
import org.openurp.edu.eams.system.prefer.model.CustomQuery
import org.openurp.starter.edu.helper.ProjectSupport
import org.openurp.std.info.app.model.StdEditRestriction
import org.openurp.std.info.model.{Contact, Examinee, Graduation, Home}
import org.openurp.std.info.service.{StudentManager, StudentPropertyExtractor}

import java.time.{Instant, LocalDate}
import scala.collection.mutable
import scala.util.control.Breaks.{break, breakable}

/**
 * 学籍查询
 */

class StudentSearchAction extends RestfulAction[Student] with ProjectSupport {

  protected var studentService: StudentService = _

  protected var studentManager: StudentManager = _

  //  protected var studentInfoService: StudentInfoService = _

  //  private var entityMetaMap: Map[Class[_], EntityMeta] = null

  override def indexSetting(): Unit = {
    initInfo()
    super.indexSetting()
  }

  protected def initInfo(): Unit = {
    put("projectList", getProject)
    put("departments", getProject.departments) // 院系部门

    //    put("studentTypes", getStdTypes) // 学生类别
    put("studentTypes", getProject.stdTypes) // 学生类别

    put("directions", findInProject(classOf[Direction])) // 方向

    put("levels", getCodes(classOf[EducationLevel])) // 培养层次

    put("genders", getCodes(classOf[Gender])) // 性别

    put("states", getCodes(classOf[StudentStatus])) // 状态

    put("campuses", findInSchool(classOf[Campus]))
    put("nations", getCodes(classOf[Nation])) // 民族

    put("politicVisages", getCodes(classOf[PoliticalStatus])) // 政治面貌

    put("enrollModes", getCodes(classOf[EnrollMode])) // 入学方式

    put("countries", getCodes(classOf[Country])) // 国籍

    put("feeOrigins", getCodes(classOf[FeeOrigin])) // 费用来源

    put("studyTypes", getCodes(classOf[StudyType]))
    put("maritalStatuses", getCodes(classOf[MaritalStatus]))
    put("idTypes", getCodes(classOf[IdType]))
    put("educationModes", getCodes(classOf[EducationMode]))
    put("educationResults", getCodes(classOf[EducationResult]))
    put("degrees", getCodes(classOf[Degree]))
    // FIXME 等待研发部做 省市区级联组件
    put("divisions", getCodes(classOf[Division])) // 生源地

    // FIXME
    put("adminClasses", entityDao.getAll(classOf[Squad])) // 行政班级

    // put("eduDegrees", getCodes(EduDegree.class));
    put("subjectCategorys", getCodes(classOf[DisciplineCategory]))
    // put("subjects", getCodes(Subject.class));
    put("disciplineCategorys", getCodes(classOf[DisciplineCategory])) // 学科门类

    put("admissionTypes", getCodes(classOf[AdmissionType]))
    // put("socialRelations",getCodes(FamilyRelationship.class));//
    // 与本人关系
    put("hskLevels", getCodes(classOf[HskLevel]))
    put("passportTypes", getCodes(classOf[PassportType]))
    put("visaTypes", getCodes(classOf[VisaType]))
    put("railwayStations", getCodes(classOf[RailwayStation]))
    // put("economicStates", getCodes(FamilyEconomicState.class));
    put("stdLabels", getCodes(classOf[StdLabel]))
    putSearchConditions()
  }

  protected def putSearchConditions(): Unit = {
    val oql = OqlBuilder.from(classOf[CustomQuery])
    oql.where("user.code=:code", Securities.user)
    oql.orderBy("conditionName,updatedAt")
    put("conditions", entityDao.search(oql))
  }

  //
  //  override def search(): View = {
  //    if (Strings.isEmpty(getDepartIdSeq) || Strings.isEmpty(getStdTypeIdSeq)) {
  //      return forwardError("对不起，您没有权限！")
  //    }
  //    put("students", entityDao.search(buildQuery))
  //    forward
  //  }
  override def getQueryBuilder: OqlBuilder[Student] = {
    val builder = super.getQueryBuilder
    builder.where("student.project=:project", getProject)

    //FIXME    xinzhou 根据数据权限得到相应数据待修复
    //    val p: Profile = projectContext.getCurrentProfile
    //    if (!("*" == p.getProperty("department"))) {
    builder.where("student.state.department in (:departments)", getDeparts)
    //    }
    //    if (CollectUtils.isNotEmpty(getStdTypes)) {
    //      builder.where("student.stdType in (:stdTypes)", getStdTypes)
    //    }
    //    if (CollectUtils.isNotEmpty(getLevels)) {
    //      builder.where("student.level in (:levels)", getLevels)
    //    }
    val date = LocalDate.now()
    get("status").foreach(status => {
      status match {
        case "active" => builder.where("student.state.beginOn<= :now and student.state.endOn>=:now and student.registed=true and student.state.inschool = true", date)
        case "unactive" => builder.where("student.state.beginOn<= :now and student.state.endOn>=:now and student.registed=true and student.state.inschool = false", date)
        case "available" => builder.where("student.state.beginOn<= :now and student.state.endOn>=:now and student.registed=true ", date)
        case "unavailable" => builder.where("student.state.beginOn> :now or student.state.endOn<:now or student.registed=false", date)
        case "" =>
      }
    })
    val subCon = loadSubQuery(OqlBuilder.from(classOf[Graduation], "graduation"), OqlBuilder.from(classOf[Contact], "contact"), OqlBuilder.from(classOf[Home], "home"), OqlBuilder.from(classOf[Examinee], "examinee"))
    if (null != subCon) {
      builder.where(subCon)
    }
    getInt("squad.id").foreach(squadId => {
      builder.where("student.state.squad.id = :squadId", squadId)
    })
    getInt("stdLabel.id").foreach(stdLabelId => {
      builder.where("exists (from student.labels label where label.id = :labelId)", stdLabelId)
    })
    builder
  }

  def selectColumnBeforeExport: View = {
    val metas = entityDao.findBy(classOf[PropertyMeta], "meta.remark", List(classOf[StdEditRestriction].getName)).toBuffer
    addMeta(metas, "code", classOf[String], "学号", classOf[Student], "学籍信息")
    put("metas", metas)
    forward()
  }

  private def addMeta(metas: mutable.Buffer[PropertyMeta], fieldName: String, fieldType: Class[_], fieldComments: String, inObject: Class[_], inObjectComments: String): Unit = {
    val entityMetaMap = entityDao.getAll(classOf[EntityMeta]).map(e => (e.name, e)).toMap
    val meta = new PropertyMeta
    meta.name = fieldName
    meta.`type` = fieldType.getName
    meta.comments = Option(fieldComments)
    meta.meta = entityMetaMap.get(inObject.getName).get
    metas.+=:(meta)
  }

  @ignore
  override def configExport(setting: ExportSetting): Unit = {
    setting.context.extractor = new StudentPropertyExtractor(entityDao)
    //    val query = getQueryBuilder
    //    query.orderBy("student.id")
    //    setting.context.put("items", entityDao.search(query))
    super.configExport(setting)
  }

  def loadStudentInAjax: View = {
    info(getLong("id").toString)
  }

  @mapping(value = "{id}")
  override def info(id: String): View = {
    val student = getModel[Student](entityName, convertId(id))
    val graduation = entityDao.unique(OqlBuilder.from(classOf[Graduation], "graduation").where("graduation.std = :student", student))
    put("graduation", graduation)
    put("contact", entityDao.unique(OqlBuilder.from(classOf[Contact], "contact").where("contact.std = :student", student)))
    put("home", entityDao.unique(OqlBuilder.from(classOf[Home], "home").where("home.std = :student", student)))
    put("examinee", entityDao.unique(OqlBuilder.from(classOf[Examinee], "examinee").where("examinee.std = :student", student)))
    //    put("avatarUrl", Urp.api + "/platform/user/avatars/" + Digests.md5Hex(student.user.code))
    //FIXME xinzhou  注意只适用于本地调试
    put("avatarUrl", "http://jxjyjw.usst.edu.cn/api/platform/user/avatars/" + Digests.md5Hex(student.user.code) + ".jpg")
    super.info(id)
  }

  //  def getSubMenu(): Unit = {
  //    response.setCharacterEncoding("utf-8")
  //    getInt("entityId").foreach(projectId=>{
  //      val project = entityDao.get(classOf[Project], projectId)
  //      try {
  //        val departs = project.departments
  //        val departInfos = Collections.newBuffer[Array[AnyRef]]
  //        departs.foreach(depart => {
  //          departInfos.+=:(Array[AnyRef](depart.id, depart.name))
  //        })
  //        val levels = project.levels
  //        val levelInfos = Collections.newBuffer[Array[AnyRef]]
  //        levels.foreach(level => {
  //          levelInfos.+=:(Array[AnyRef](level.id, level.name))
  //        })
  //        val stdTypes = project.stdTypes
  //        val stdTypeInfos = Collections.newBuffer[Array[AnyRef]]
  //        stdTypes.foreach(stdType => {
  //          stdTypeInfos.+=:(Array[AnyRef](stdType.id, stdType.name))
  //        })
  //        response.getWriter.print((levelInfos, departInfos, stdTypeInfos))
  //      } catch {
  //        case e: Exception =>
  //          e.printStackTrace()
  //      }
  //    })
  //  }

  def loadSquadAjax: View = {
    val grade = get("grade")
    val projectId = getInt("projectId").getOrElse(getProject.id)
    getBoolean("isEdit").foreach(e => {
      e match {
        case true => {
          if (grade.isEmpty || getInt("levelId").isEmpty || getInt("stdTypeId").isEmpty || getInt("departmentId").isEmpty || getLong("majorId").isEmpty) {
            logger.error("No primary keys in form!!!")
            forward()
          }
        }
        case false =>
        //          if (null == projectId) {
        //            logger.error("No primary keys in search condition!!!")
        //            forward()
        //          }
      }
    })
    val query = OqlBuilder.from(classOf[Squad], "squad")
    grade.foreach(g => {
      query.where("squad.grade like '%' || :grade || '%'", g)
    })
    query.where("squad.project.id = :projectId", projectId)
    getInt("levelId").foreach(levelId => {
      query.where("squad.level.id = :levelId", levelId)
    })
    getInt("stdTypeId").foreach(stdTypeId => {
      query.where("squad.stdType.id = :stdTypeId", stdTypeId)
    })
    getInt("departmentId").foreach(departmentId => {
      query.where("squad.department.id = :departmentId", departmentId)
    })
    getLong("majorId").foreach(majorId => {
      query.where("squad.major.id = :majorId", majorId)
    })
    getLong("directionId").foreach(directionId => {
      query.where("squad.direction.id = :directionId", directionId)
    })
    getInt("campusId").foreach(campusId => {
      query.where("squad.campus is null or squad.campus.id = :campusId", campusId)
    })
    query.limit(1, 20)
    query.orderBy(Order.parse("squad.code, squad.id"))
    val squads = entityDao.search(query)
    if (squads.size > 20) {
      put("caption", "over")
    }
    put("squades", squads)
    forward()
  }

  def listConditions: View = {
    putSearchConditions()
    forward()
  }

  def editConditions: View = {
    put("conditions", get("conditions"))
    forward()
  }

  def saveConditions: View = {
    val condition = populateEntity(classOf[CustomQuery], "studentCondition")
    //    val action = new Action(this.getClass, "index")
    if (condition.conditionName == null) {
      //       forward(, "info.save.failure")
      redirect("index", "info.save.failure")
    }
    val builder = OqlBuilder.from(classOf[CustomQuery], "condition").where("condition.conditionName = :conditionName", condition.conditionName).where("condition.user.code = :user", Securities.user)
    val conditions = entityDao.search(builder)
    if (!(conditions.isEmpty)) {
      val before = conditions(0)
      before.conditions = condition.conditions
      before.updatedAt = Instant.now()
      entityDao.saveOrUpdate(before)
    }
    else {
      condition.user = getUser
      entityDao.saveOrUpdate(condition)
    }
    //    return forward(action, "info.save.success")
    redirect("index", "info.save.success")
  }

  def getUser: User = {
    val users = entityDao.findBy(classOf[User], "code", List(Securities.user))
    if (users.isEmpty) {
      null
    } else {
      users.head
    }
  }

  @SuppressWarnings(Array("unchecked"))
  def putEditRestriction(): Unit = {
    val restrictions = entityDao.search(OqlBuilder.from(classOf[StdEditRestriction], "restriction").where("restriction.user.school = :school and restriction.user.code = :username", getProject.school, Securities.user))
    if (!restrictions.isEmpty) {
      put("restriction", restrictions(0))
    }
    System.out.println(classOf[Contact].getName)
    put("contactMeta", classOf[Contact].getName)
    put("homeMeta", classOf[Home].getName)
    put("graduationMeta", classOf[Graduation].getName)
    put("examineeMeta", classOf[Examinee].getName)
    put("studentMeta", classOf[Student].getName)
    put("stateMeta", classOf[StudentState].getName)
    put("personMeta", classOf[Person].getName)
  }

  /**
   * 指定学籍中的类，生成出与Student之间的没有别名链接语句
   *
   * @param entityClazz
   * @return
   */
  protected def loadConnectStatementTypeForStudent(entityClazz: Class[_]): String = {
    if (null == entityClazz) {
      return null
    }
    val fields = entityClazz.getDeclaredFields
    fields.foreach(field => {
      val keyType = field.getType
      if (classOf[Student].getName == keyType.getName) {
        return "std = student"
      }
      if (classOf[Person].getName == keyType.getName) {
        return field.getName + " = student.person"
      }
    })
    loadConnectStatementTypeForStudent(entityClazz.getSuperclass)
  }

  protected def putBasecodeInStdInfo(): Unit = {
    //FIXME    xinzhou 根据数据权限得到相应数据待修复
    //    put("levels", getLevels)
    put("levels", getCodes(classOf[EducationLevel]))
    put("stdTypes", getCodes(classOf[StdType]))
    put("states", getCodes(classOf[StudentStatus])) // 状态
    put("studyTypes", getCodes(classOf[StudyType])) // 学习方式
    put("idTypes", getCodes(classOf[IdType]))
    put("tutors", List.empty[String]) // FIXME 2016-09-19 zhouqi 导师
  }

  protected def putBasecodeInPersonInfo(): Unit = {
    put("genders", getCodes(classOf[Gender]))
    put("idTypes", getCodes(classOf[IdType]))
    put("countries", getCodes(classOf[Country]))
    put("nations", getCodes(classOf[Nation]))
    put("politicalStatuses", getCodes(classOf[PoliticalStatus]))
  }

  protected def putBasecodeInStudentState(): Unit = {
    put("departments", getProject.departments)
    put("statuses", getCodes(classOf[StudentStatus]))
    put("campuses", findInSchool(classOf[Campus]))
  }

  protected def putBasecodeInGraduationInfo(): Unit = {
    put("educationResults", getCodes(classOf[EducationResult]))
    put("degrees", getCodes(classOf[Degree]))
  }

  protected def putBasecodeInHomeInfo(): Unit = {
    put("railwayStations", getCodes(classOf[RailwayStation]))
    // put("economicStates", getCodes(FamilyEconomicState.class));
  }

  private def loadSubQuery(subQuerys: OqlBuilder[_]*): Condition = {
    val params = Collections.newBuffer[Any]
    val subSql = new StringBuilder
    subQuerys.foreach(subQuery => {
      val entityClazz = subQuery.entityClass
      val connectStatement = loadConnectStatementTypeForStudent(entityClazz)
      breakable {
        if (connectStatement.isBlank) {
          logger.error("no forgien field be found!!!")
          break
        }
        var conditionstr = subQuery.build().statement
        breakable {
          if (!conditionstr.contains(" where ")) {
            populateConditions(subQuery)
            conditionstr = subQuery.build().statement
            if (!conditionstr.contains(" where ")) {
              break
            }
          }
          if (subSql.length > 0) {
            subSql.append(" and ")
          }
          subSql.append("exists (")
          subSql.append("         from ").append(entityClazz.getName).append(" ").append(subQuery.alias)
          subSql.append("        where ").append(subQuery.alias).append(".").append(connectStatement)
          //FIXME xinzhou
          val a = conditionstr.replace("select " + subQuery.alias + " from " + entityClazz.getName + " " + subQuery.alias + " where", " and")
          subSql.append(a)
          params.addAll(subQuery.params.values)
          subSql.append("       )")
        }
      }
    })
    if (subSql.toString.isBlank) {
      return null
    }
    val con = new Condition(subSql.toString)
    con.params(params)
    con
  }

}

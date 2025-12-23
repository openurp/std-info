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

import org.beangle.commons.collection.{Collections, Order}
import org.beangle.commons.lang.Strings
import org.beangle.data.dao.{Condition, EntityDao, OqlBuilder}
import org.beangle.webmvc.context.{ActionContext, Params}
import org.beangle.webmvc.support.helper.QueryHelper
import org.openurp.base.model.{Person, Project}
import org.openurp.base.service.{Features, ProjectConfigService}
import org.openurp.base.std.model.{Graduate, Student, Tutorship}
import org.openurp.std.info.model.{Contact, Examinee, Home}

import java.time.LocalDate

class StdSearchHelper(entityDao: EntityDao, project: Project) {

  def build(): OqlBuilder[Student] = {
    val builder = OqlBuilder.from(classOf[Student], "student")
    QueryHelper.populate(builder)
    QueryHelper.sort(builder)
    builder.tailOrder("student.id")
    builder.limit(QueryHelper.pageLimit)

    builder.where("student.project=:project", project)
    val date = LocalDate.now()
    Params.get("status").foreach {
      case "active" => builder.where("student.beginOn<= :now and student.endOn>=:now and student.registed=true and student.state.inschool = true", date)
      case "unactive" => builder.where("student.beginOn<= :now and student.endOn>=:now and student.registed=true and student.state.inschool = false", date)
      case "available" => builder.where("student.beginOn<= :now and student.endOn>=:now and student.registed=true ", date)
      case "unavailable" => builder.where("student.beginOn> :now or student.endOn<:now or student.registed=false", date)
      case "active_unregisted" => builder.where("student.state.inschool=true and student.registed=false")
      case "" =>
    }
    addSubQuery(builder, classOf[Graduate], classOf[Contact], classOf[Home], classOf[Examinee])
    Params.getInt("squad.id").foreach(squadId => {
      builder.where("student.state.squad.id = :squadId", squadId)
    })
    Params.getInt("stdLabel.id").foreach(stdLabelId => {
      builder.where("exists (from student.labels label where label.id = :labelId)", stdLabelId)
    })
    //查询导师
    Params.get("tutor.name").foreach(n => {
      if (Strings.isNotBlank(n)) {
        val names = Strings.split(n)
        if (names.length == 1) {
          builder.where(s"exists(from student.tutors t where t.tutorship=${Tutorship.Major.id} and t.tutor.name like :tutorName)", s"%${n.trim()}%")
        } else {
          builder.where(s"exists(from student.tutors t where t.tutorship=${Tutorship.Major.id} and t.tutor.name in(:tutorNames))", names)
        }
      }
    })
    Params.get("advisor.name").foreach(n => {
      if (Strings.isNotBlank(n)) {
        val names = Strings.split(n)
        if (names.length == 1) {
          builder.where(s"exists(from student.tutors t where t.tutorship=${Tutorship.Thesis.id} and t.tutor.name like :tutorName)", s"%${n.trim()}%")
        } else {
          builder.where(s"exists(from student.tutors t where t.tutorship=${Tutorship.Thesis.id} and t.tutor.name in(:tutorNames))", names)
        }
      }
    })
    builder.orderBy(Params.get(Order.OrderStr).getOrElse("student.state.grade.id desc,student.code"))
    builder.tailOrder("student.id")
    builder
  }

  private def addSubQuery(builder: OqlBuilder[Student], infoClasses: Class[_]*): Unit = {
    infoClasses.foreach(infoClass => {
      if (entityDao.domain.getEntity(infoClass).get.getProperty("std").nonEmpty) {
        val subQuery = OqlBuilder.from(infoClass)
        QueryHelper.populate(subQuery)
        if (subQuery.params.nonEmpty) {
          val subSql = new StringBuilder
          subSql.append("exists (from ").append(infoClass.getName).append(" ").append(subQuery.alias)
          subSql.append(" where ").append(subQuery.alias).append(".").append("std = student")
          val conditionstr = subQuery.build().statement
          val a = conditionstr.replace("select " + subQuery.alias + " from " + infoClass.getName + " " + subQuery.alias + " where", " and")
          subSql.append(a)
          subSql.append(")")
          builder.where(new Condition(subSql.toString()))
          builder.params(subQuery.params);
        }
      }
    })
  }

  def setExportAttributes(configService: ProjectConfigService): Unit = {
    val squadSupported = configService.get[Boolean](project, Features.Std.SquadSupported)
    val tutorSupported = configService.get[Boolean](project, Features.Std.TutorSupported)
    val advisorSupported = configService.get[Boolean](project, Features.Std.AdvisorSupported)

    val std = EntityMeta(classOf[Student].getName, "学籍信息", Collections.newBuffer[PropertyMeta])
    std.add("code" -> "学号", "name" -> "姓名", "state.grade.code" -> "年级")
    std.add("studyType.name" -> "学习形式", "duration" -> "学制", "level.name" -> "培养层次")
    std.add("stdType.name" -> "学生类别", "eduType.name" -> "培养类型")
    std.add("state.department.name" -> "院系", "state.major.name" -> "专业", "state.major.code" -> "专业代码")
    std.add("state.direction.name" -> "专业方向", "state.direction.code" -> "专业方向代码")
    std.add("state.campus.name" -> "校区", "registed" -> "学历生", "beginOn" -> "入学日期", "endOn" -> "预计离校日期")
    std.add("maxEndOn" -> "最晚离校日期", "remark" -> "备注", "graduationDeferred" -> "是否延期毕业")
    std.add("graduateOn" -> "预计毕业日期", "state.status.name" -> "学籍状态")
    if squadSupported then std.add("state.squad.name", "班级")
    if (tutorSupported) {
      std.add("majorTutorNames", "导师姓名")
      std.add("majorTutors(code)", "导师工号")
    }
    if advisorSupported then std.add("thesisTutor.name", "论文指导教师")

    val p = EntityMeta(classOf[Person].getName, "基本信息", Collections.newBuffer[PropertyMeta])
    p.add("gender.name" -> "性别", "birthday" -> "出生日期", "nation.name" -> "民族", "country.name" -> "国家地区")
    p.add("idType.name" -> "证件类型", "code" -> "证件号码", "politicalStatus.name" -> "政治面貌", "homeTown" -> "籍贯")
    p.add("phoneticName" -> "姓名拼音")

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

    val context = ActionContext.current
    context.attribute("std", std)
    context.attribute("person", p)
    context.attribute("contact", contact)
    context.attribute("examinee", examinee)
  }
}

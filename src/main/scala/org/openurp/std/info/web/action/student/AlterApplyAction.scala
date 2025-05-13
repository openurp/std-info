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

package org.openurp.std.info.web.action.student

import jakarta.servlet.http.Part
import org.beangle.commons.json.{Json, JsonObject}
import org.beangle.commons.lang.Strings
import org.beangle.data.dao.OqlBuilder
import org.beangle.ems.app.oa.Flows
import org.beangle.ems.app.web.WebBusinessLogger
import org.beangle.ems.app.{Ems, EmsApp}
import org.beangle.webmvc.context.Params
import org.beangle.webmvc.support.helper.PopulateHelper
import org.beangle.webmvc.view.View
import org.openurp.base.hr.model.{Staff, TutorMajor}
import org.openurp.base.std.model.Student
import org.openurp.code.std.model.StdAlterType
import org.openurp.starter.web.helper.ProjectProfile
import org.openurp.starter.web.support.StudentSupport
import org.openurp.std.alter.model.*
import org.openurp.std.info.web.helper.AlterApplyInfo

import java.time.Instant

/**
 * 学生申请学籍异动
 */
class AlterApplyAction extends StudentSupport {
  var businessLogger: WebBusinessLogger = _

  private val businessCode = "std_alter_apply"

  override def projectIndex(std: Student): View = {
    val applies = entityDao.findBy(classOf[StdAlterApply], "std", std).sortBy(_.applyAt).reverse
    val infoes = AlterApplyInfo.build(applies)
    put("applyInfoes", infoes)
    put("flows", Flows.getFlows(businessCode, std.project.id))
    forward()
  }

  def applyForm(): View = {
    val std = getStudent
    put("std", std)
    val flow = Flows.getFlow(get("flow", ""))
    put("flow", flow)
    val alterType = entityDao.get(classOf[StdAlterType], flow.env.query("alterType.id").get.toString.toInt)
    put("alterType", alterType)
    put("needEndOn", alterType.name.contains("休学"))
    //如果变更类型为更换导师，则查询可以更换的导师
    if (alterType.name.contains("导师")) {
      val q = OqlBuilder.from(classOf[TutorMajor], "tm")
      q.where("tm.eduType=:eduType and tm.level=:level", std.eduType, std.level)
      q.where("tm.major=:major", std.major)
      var tms = entityDao.search(q)
      std.direction foreach { d =>
        tms = tms.filter { x => x.directions.contains(d) }
      }
      val tutors = tms.map(_.staff).toSet.removedAll(std.tutor)
      put("tutors", tutors)
    }
    put("tutor", std.tutor)
    put("mentor", std.squad.flatMap(_.mentor))
    ProjectProfile.set(std.project)
    put("signature_url", Ems.api + s"/platform/oa/signatures/${std.code}.png")
    forward()
  }

  def submit(): View = {
    val env = new JsonObject
    val std = getStudent
    env.update("student.code", std.code)
    env.update("student.name", std.name)
    env.update("student.department.code", std.department.code)
    env.update("student.tutor.code", std.tutor.map(_.code).getOrElse("--"))
    env.update("student.mentor.code", std.squad.flatMap(_.mentor.map(_.code)).getOrElse("--"))
    env.update("student.stdType.name", std.stdType.name)

    val data = new JsonObject

    val apply = PopulateHelper.populate(classOf[StdAlterApply], "apply")
    apply.status = "待审核"
    apply.std = std
    apply.applyAt = Instant.now

    val alterData = collectAlterData(std)
    val formData = Params.sub("form")
    env.update("alter", alterData)
    data.addAll(formData)
    apply.alterDataJson = Json.toJson(alterData)
    apply.formDataJson = Json.toJson(formData)
    entityDao.saveOrUpdate(apply)
    entityDao.refresh(apply)
    val flow = Flows.getFlow(get("flow", ""))
    //处理上传附件和签名
    val blob = EmsApp.getBlobRepository(true)
    var process = Flows.start(flow.code, apply.id, env)
    if (Strings.isBlank(process.id)) {
      apply.status = "申请失败:" + process.remark
    } else {
      //处理附件和学生和家长签名
      val issuer = Flows.user(std.code, std.name)
      val files = Flows.upload(getAll("attachment", classOf[Part]), "/alter-apply", apply.id, issuer)
      Flows.uploadSignature(get("stdSign"), "/alter-apply", apply.id, issuer, data)
      Flows.uploadSignature(get("parentSign"), "/alter-apply", apply.id, issuer, data, "parentSignaturePath")

      var task = process.activeTasks.head
      apply.processId = Some(process.id)
      val step = apply.newStep(task.name, task.assignees)
      step.audit(std.user, true, None)

      process = Flows.complete(process.id, task.id, Flows.Payload(issuer, List("提交申请"), files, env, data))
      val activeTasks = process.activeTasks
      if (activeTasks.isEmpty) {
        apply.assignees = None
        apply.status = "已办结"
      } else {
        task = activeTasks.head
        apply.newStep(task.name, task.assignees)
      }
    }
    //保存和记录日志
    entityDao.saveOrUpdate(apply)
    businessLogger.info(s"提交了${apply.alterType.name}的异动申请", apply.id, Map.empty)
    redirect("index", "提交成功")
  }

  private def collectAlterData(std: Student): JsonObject = {
    val rs = new JsonObject
    getLong("alter.tutor.id") foreach { tutorId =>
      val obj = new JsonObject
      obj.update("oldvalue", std.tutor.map(_.id.toString).getOrElse(""))
      obj.update("oldtext", std.tutor.map(_.name).getOrElse(""))
      obj.update("newvalue", tutorId)
      val tutor = entityDao.get(classOf[Staff], tutorId)
      obj.update("newtext", tutor.name)
      obj.add("code", tutor.code)
      obj.add("meta", AlterMeta.Tutor.name)
      rs.add("tutor", obj)
    }
    rs
  }

  def cancel(): View = {
    val std = getStudent
    val apply = entityDao.get(classOf[StdAlterApply], getLongId("apply"))
    if (!apply.passed.contains(true)) {
      apply.status = "已取消"
    }
    if (apply.status == "已取消") {
      apply.processId foreach { processId =>
        Flows.cancel(processId)
      }
      apply.processId = None
      if (apply.steps.filter(_.idx > 0).exists(_.passed.nonEmpty)) {
        entityDao.saveOrUpdate(apply)
        businessLogger.info(s"取消了${apply.alterType.name}的异动申请", apply.id, Map.empty)
      } else {
        entityDao.remove(apply)
      }
      redirect("index", "取消成功")
    } else {
      redirect("index", "已通过的申请无法撤销")
    }
  }
}

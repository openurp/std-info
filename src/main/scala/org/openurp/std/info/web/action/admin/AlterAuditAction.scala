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

import org.beangle.commons.json.{Json, JsonObject}
import org.beangle.commons.lang.Strings
import org.beangle.commons.net.http.HttpUtils
import org.beangle.data.dao.OqlBuilder
import org.beangle.ems.app.Ems
import org.beangle.ems.app.oa.Flows
import org.beangle.security.Securities
import org.beangle.webmvc.annotation.{mapping, param}
import org.beangle.webmvc.context.Params
import org.beangle.webmvc.support.action.RestfulAction
import org.beangle.webmvc.view.View
import org.openurp.base.edu.model.Major
import org.openurp.base.model.Project
import org.openurp.code.std.model.StdAlterType
import org.openurp.starter.web.helper.ProjectProfile
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.alter.model.StdAlterApply
import org.openurp.std.info.service.StdAlterationService
import org.openurp.std.info.web.helper.AlterApplyInfo

class AlterAuditAction extends RestfulAction[StdAlterApply], ProjectSupport {

  var stdAlterationService: StdAlterationService = _

  override def indexSetting(): Unit = {
    given project: Project = getProject

    put("project", project)
    put("levels", project.levels) // 培养层次
    put("departments", getDeparts)
    put("majors", findInProject(classOf[Major]))

    put("modes", getCodes(classOf[StdAlterType]))
  }

  override def search(): View = {
    val query = getQueryBuilder
    val active = getBoolean("active", true)
    if (active) {
      query.where("locate(:me,','||stdAlterApply.assignees||',')>0", s",${Securities.user},")
      put("auditable", true)
    } else {
      given project: Project = getProject

      val user = getUser
      query.where("exists(from stdAlterApply.steps as step where step.assignee=:user)", user)
    }
    put("active", if active then "1" else "0")
    val applies = entityDao.search(query)
    put("stdAlterApplies", applies)
    forward()
  }

  override protected def getQueryBuilder: OqlBuilder[StdAlterApply] = {
    val query = super.getQueryBuilder
    get("stdCodeName") foreach { cn =>
      val codeName = cn.trim()
      if (Strings.isNotBlank(codeName)) {
        query.where("stdAlterApply.std.code like :codeName or stdAlterApply.std.name like :codeName", s"%${codeName}%")
      }
    }
    query
  }

  /** 选中异动进行审核，展示审核表单
   *
   * @return
   */
  def auditForm(): View = {
    val apply = entityDao.get(classOf[StdAlterApply], getLongId("stdAlterApply"))
    put("apply", apply)
    if (apply.processId.isEmpty) {
      redirect("search", "没有纳入流程管理，无法审核")
    } else {
      val rs = checkAudit(apply.processId.get)
      put("alterData", Json.parse(apply.alterDataJson))
      put("formData", if Strings.isBlank(apply.formDataJson) || apply.formDataJson == "{}" then new JsonObject else Json.parse(apply.formDataJson))
      val defaultSigUrl = Ems.api + s"/platform/oa/signatures/${Securities.user}.png"
      val defaultSig = HttpUtils.getData(defaultSigUrl)
      if (defaultSig.isOk && defaultSig.content.isInstanceOf[Array[Byte]] && defaultSig.content.asInstanceOf[Array[Byte]].length > 0) {
        put("signature_url", defaultSigUrl)
      }
      if (Strings.isEmpty(rs._3)) {
        put("process", rs._1)
        put("tasks", rs._2)
        ProjectProfile.set(apply.std.project)
        forward()
      } else {
        addError(rs._3)
        put("apply", apply)
        put("applyInfo", AlterApplyInfo.build(List(apply)).head)
        put("auditable", false)
        put("cannotAuditReason", rs._3)
        forward("info")
      }
    }
  }

  def checkAudit(processId: String): (Flows.Process, Iterable[Flows.Task], String) = {
    val p = Flows.getProcess(processId)
    if (p.activeTasks.isEmpty) {
      (p, List.empty, "当前异动已经结束，无法审核。")
    } else {
      val myTasks = p.activeTasks.filter(t => Strings.split(t.assignees.getOrElse("")).toSet.contains(Securities.user))
      if (myTasks.isEmpty) {
        (p, List.empty, "不在当前异动审核名单中，无法审核。")
      } else {
        (p, myTasks, "")
      }
    }
  }

  def audit(): View = {
    val apply = entityDao.get(classOf[StdAlterApply], getLongId("stdAlterApply"))

    given project: Project = apply.std.project

    val processId = apply.processId.get
    val rs = checkAudit(processId)

    if (Strings.isEmpty(rs._3)) {
      val me = getUser
      val auditor = Flows.user(me.code, me.name)
      val comments = get("comments")
      val passed = getBoolean("passed", true)

      val formData = Params.sub("form")
      if (formData.nonEmpty) {
        val fd = Json.parse(apply.formDataJson).asInstanceOf[JsonObject]
        fd.addAll(formData)
        apply.formDataJson = fd.toJson
      }
      val data = new JsonObject()
      Flows.uploadSignature(get("sign"), "/alter-apply", apply.id, auditor, data)
      data.update("passed", passed)
      data.addAll(formData)
      var completeAndPassed = false
      rs._1.activeTasks foreach { task =>
        val process = Flows.complete(processId, task.id, Flows.payload(auditor, comments, data))
        apply.newStep(task.name, task.idx, task.assignees).audit(me, passed, comments)
        val activeTasks = process.activeTasks
        if (activeTasks.isEmpty) {
          apply.assignees = None
          apply.status = "已办结"
          apply.passed = Some(passed)
          completeAndPassed = passed
        } else {
          val nt = activeTasks.head
          apply.newStep(nt.name, nt.idx, nt.assignees)
        }
      }
      entityDao.saveOrUpdate(apply)
      if (completeAndPassed) {
        stdAlterationService.approve(apply)
      }
      redirect("search", rs._3)
    } else {
      redirect("search", "审核成功")
    }
  }

  @mapping(value = "{id}")
  override def info(@param("id") id: String): View = {
    val apply = entityDao.get(classOf[StdAlterApply], id.toLong)
    put("apply", apply)
    put("applyInfo", AlterApplyInfo.build(List(apply)).head)
    put("formData", if Strings.isBlank(apply.formDataJson) || apply.formDataJson == "{}" then new JsonObject else Json.parse(apply.formDataJson))
    if (Strings.isBlank(apply.alterDataJson)) {
      put("alterData", new JsonObject())
    } else {
      put("alterData", Json.parse(apply.alterDataJson))
    }
    put("auditable", false)
    apply.processId foreach { processId =>
      val rs = checkAudit(processId)
      val auditable = Strings.isEmpty(rs._3)
      put("auditable", auditable)
      if (!auditable) {
        put("cannotAuditReason", rs._3)
      }
    }
    forward()
  }
}

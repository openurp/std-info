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
import org.beangle.data.dao.OqlBuilder
import org.beangle.ems.app.Ems
import org.beangle.ems.app.oa.Flows
import org.beangle.security.Securities
import org.beangle.security.context.SecurityContext
import org.beangle.webmvc.annotation.{mapping, param}
import org.beangle.webmvc.support.action.RestfulAction
import org.beangle.webmvc.view.View
import org.openurp.base.edu.model.Major
import org.openurp.base.model.{Project, User}
import org.openurp.code.std.model.StdAlterType
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.alter.model.StdAlterApply
import org.openurp.std.info.web.helper.AlterApplyInfo

import javax.sql.DataSource

class AlterAuditAction extends RestfulAction[StdAlterApply], ProjectSupport {

  var datasource: DataSource = _

  override def indexSetting(): Unit = {
    given project: Project = getProject

    put("project", project)
    put("levels", project.levels) // 培养层次
    put("departments", getDeparts)
    put("majors", findInProject(classOf[Major]))

    put("modes", getCodes(classOf[StdAlterType]))
  }

  override def getQueryBuilder: OqlBuilder[StdAlterApply] = {
    val query = super.getQueryBuilder
    query.where("locate(:me,','||stdAlterApply.assignees||',')>0", s",${Securities.user},")
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
      put("alter", Json.parse(apply.alterDataJson))
      put("signature_url", Ems.api + s"/platform/oa/signatures/${Securities.user}.png")
      if (Strings.isEmpty(rs._3)) {
        put("process", rs._1)
        put("tasks", rs._2)
        forward()
      } else {
        addError(rs._3)
        put("apply", apply)
        put("applyInfo", AlterApplyInfo.build(List(apply)).head)
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

    val me = entityDao.findBy(classOf[User], "code" -> Securities.user, "school" -> project.school).head
    val auditor = Flows.user(me.code, me.name)
    val comments = get("comments")
    val passed = getBoolean("passed", true)

    val data = new JsonObject()
    Flows.uploadSignature(get("sign"), "/alter-apply", apply.id, auditor, data)
    data.update("passed", passed)
    rs._1.activeTasks foreach { task =>
      val process = Flows.complete(processId, task.id, Flows.payload(auditor, comments, data))
      apply.newStep(task.name, task.assignees).audit(me, passed, comments)
      val activeTasks = process.activeTasks
      if (activeTasks.isEmpty) {
        apply.assignees = None
        apply.status = "已办结"
      } else {
        val nt = activeTasks.head
        apply.newStep(nt.name, nt.assignees)
      }
    }
    entityDao.saveOrUpdate(apply)
    redirect("search", "审核成功")
  }

  @mapping(value = "{id}")
  override def info(@param("id") id: String): View = {
    val apply = entityDao.get(classOf[StdAlterApply], id.toLong)
    put("apply", apply)
    put("applyInfo", AlterApplyInfo.build(List(apply)).head)
    if (Strings.isBlank(apply.alterDataJson)) {
      put("alter", new JsonObject())
    } else {
      put("alter", Json.parse(apply.alterDataJson))
    }
    put("auditable", false)
    apply.processId foreach { processId =>
      val rs = checkAudit(processId)
      put("auditable", Strings.isEmpty(rs._3))
    }
    forward()
  }
}

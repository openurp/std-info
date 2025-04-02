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
import org.beangle.ems.app.EmsApp
import org.beangle.ems.app.oa.Flows
import org.beangle.webmvc.annotation.{mapping, param}
import org.beangle.webmvc.support.action.RestfulAction
import org.beangle.webmvc.view.View
import org.openurp.base.edu.model.Major
import org.openurp.base.model.Project
import org.openurp.code.std.model.StdAlterType
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.alter.model.StdAlterApply
import org.openurp.std.info.web.helper.AlterApplyInfo

class AlterApplyAction extends RestfulAction[StdAlterApply], ProjectSupport {

  override def indexSetting(): Unit = {
    given project: Project = getProject

    put("project", project)
    put("levels", project.levels) // 培养层次
    put("departments", getDeparts)
    put("majors", findInProject(classOf[Major]))

    put("modes", getCodes(classOf[StdAlterType]))
  }

  override protected def removeAndRedirect(applies: Seq[StdAlterApply]): View = {
    applies foreach { apply =>
      apply.processId foreach { processId =>
        val blob = EmsApp.getBlobRepository(true)
        val process = Flows.getProcess(processId)
        process.tasks foreach { task =>
          val path = task.data.getString("signaturePath")
          if (Strings.isNotBlank(path)) {
            blob.remove(path)
          }
          val pSignPath = task.data.getString("parentSignaturePath")
          if (Strings.isNotBlank(pSignPath)) {
            blob.remove(pSignPath)
          }
          task.attachments foreach { at =>
            blob.remove(at.filePath)
          }
        }
        Flows.cancel(processId)
      }
    }
    super.removeAndRedirect(applies)
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
    forward("../alterAudit/info")
  }
}

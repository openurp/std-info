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
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.webmvc.annotation.{mapping, param}
import org.beangle.webmvc.support.ActionSupport
import org.beangle.webmvc.support.action.EntityAction
import org.beangle.webmvc.view.View
import org.openurp.base.edu.model.Major
import org.openurp.base.model.Project
import org.openurp.code.std.model.StdAlterType
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.alter.model.StdAlterApply
import org.openurp.std.info.web.helper.AlterApplyInfo

class AlterApplySearchAction extends ActionSupport, EntityAction[StdAlterApply], ProjectSupport {
  var entityDao: EntityDao = _

  def index(): View = {
    given project: Project = getProject

    put("project", project)
    put("levels", project.levels) // 培养层次
    put("departments", getDeparts)
    put("majors", findInProject(classOf[Major]))

    put("modes", getCodes(classOf[StdAlterType]))
    forward()
  }

  def search(): View = {
    put("stdAlterApplies", entityDao.search(getQueryBuilder))
    forward()
  }

  override protected def getQueryBuilder: OqlBuilder[StdAlterApply] = {
    val query = super.getQueryBuilder
    query.where("stdAlterApply.status='已办结'")
    query
  }

  @mapping(value = "{id}")
  def info(@param("id") id: String): View = {
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
      put("auditable", false)
    }
    forward("../alterAudit/info")
  }
}

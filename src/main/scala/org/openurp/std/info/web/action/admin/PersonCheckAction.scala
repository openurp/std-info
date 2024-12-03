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

import org.beangle.data.dao.OqlBuilder
import org.beangle.ems.app.EmsApp
import org.beangle.webmvc.annotation.{mapping, param}
import org.beangle.webmvc.view.View
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.edu.model.Major
import org.openurp.base.model.Project
import org.openurp.base.std.model.GraduateSeason
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.graduation.model.Graduation
import org.openurp.std.info.model.PersonCheck

class PersonCheckAction extends RestfulAction[PersonCheck], ProjectSupport {

  override protected def simpleEntityName: String = "check"

  override def indexSetting(): Unit = {
    given project: Project = getProject

    put("project", project)
    put("departments", project.departments) // 院系部门
    put("majors", findInProject(classOf[Major]))
    put("graduateSeasons", findInProject(classOf[GraduateSeason]))
  }

  override def getQueryBuilder: OqlBuilder[PersonCheck] = {
    given project: Project = getProject

    put("project", project)
    val builder = super.getQueryBuilder
    builder.where("check.std.project=:project", project)
    getLong("season.id") foreach { seasonId =>
      val season = entityDao.get(classOf[GraduateSeason], seasonId)
      builder.where(s"exists(from ${classOf[Graduation].getName} gr where gr.std=check.std and gr.batch.season=:season)", season)
    }
    builder
  }

  @mapping(value = "{id}")
  override def info(@param("id") id: String): View = {
    val check = entityDao.get(classOf[PersonCheck], id.toLong)
    put("check", check)
    check.attachment foreach { a =>
      val blob = EmsApp.getBlobRepository(true)
      put("attachment_url", blob.url(a))
    }
    forward()
  }

  def audit(): View = {
    forward()
  }
}

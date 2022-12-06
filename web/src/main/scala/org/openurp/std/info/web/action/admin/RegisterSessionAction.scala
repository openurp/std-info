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
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.model.Project
import org.openurp.code.edu.model.EducationLevel
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.app.model.RegisterSession

class RegisterSessionAction extends RestfulAction[RegisterSession] with ProjectSupport {

  override def indexSetting(): Unit = {
    given project: Project = getProject

    val semester = getSemester
    val query = OqlBuilder.from(classOf[RegisterSession],"rs")
    query.where("rs.project=:project",project)
//    val sessions = entityDao.findBy(classOf[RegisterSession], "semester", List(semester))
    put("sessions", entityDao.search(query))
    put("project", project)
    put("semester", semester)
  }

  override def saveAndRedirect(entity: RegisterSession): View = {
    given project: Project = getProject

    entity.project = project
    if (null == entity.semester) {
      entity.semester = getSemester
    }
    saveOrUpdate(entity)
    redirect("index", "info.save.success")
  }

  override def editSetting(scheme: RegisterSession): Unit = {
    given project: Project = getProject

    put("project",project)
    if (null == scheme.semester) {
      scheme.semester = getSemester
    }
    put("levels", getCodes(classOf[EducationLevel]))
  }
}

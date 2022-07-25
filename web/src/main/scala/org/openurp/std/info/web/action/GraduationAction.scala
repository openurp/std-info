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

import org.beangle.web.action.annotation.{mapping, param}
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.edu.code.model.StdType
import org.openurp.base.edu.model.{Direction, Major}
import org.openurp.code.edu.model.EducationLevel
import org.openurp.starter.edu.helper.ProjectSupport
import org.openurp.std.info.helper.DocHelper
import org.openurp.std.info.model.Graduation

class GraduationAction extends RestfulAction[Graduation] with ProjectSupport {

  override def indexSetting(): Unit = {
    put("levels", getCodes(classOf[EducationLevel]))
    put("stdTypes", getCodes(classOf[StdType]))
    put("departments", getDeparts)
    put("majors", findInProject(classOf[Major]))
    put("directions", findInProject(classOf[Direction]))
    super.indexSetting()
  }

  override def search(): View = {
    val query = getQueryBuilder
    get("degree").orNull match {
      case "0" => query.where("graduation.diplomaNo is null")
      case "1" => query.where("graduation.diplomaNo is not null")
      case _ =>
    }
    put("graduations", entityDao.search(query))
    put("project", getProject)
    forward()
  }

  @mapping("degreeDownload/{id}")
  def degreeDownload(@param("id") id: String): View = {
    val graduation = entityDao.get(classOf[Graduation], id.toLong)
    val bytes = DocHelper.toDegreeDoc(entityDao, graduation)
    val filename = new String(("学位证书-" + graduation.std.user.name).getBytes, "ISO8859-1")
    response.setHeader("Content-disposition", "attachment; filename=" + filename + ".docx")
    response.setHeader("Content-Length", bytes.length.toString)
    val out = response.getOutputStream
    out.write(bytes)
    out.flush()
    out.close()
    null
  }

  @mapping("certificationDownload/{id}")
  def certificationDownload(@param("id") id: String): View = {
    val graduation = entityDao.get(classOf[Graduation], id.toLong)
    val bytes = DocHelper.toCertificationDoc(entityDao, graduation)
    val filename = if (graduation.std.project.minor) {
      new String(("专业证书-" + graduation.std.user.name).getBytes, "ISO8859-1")
    }
    else {
      new String(("毕业证书-" + graduation.std.user.name).getBytes, "ISO8859-1")
    }
    response.setHeader("Content-disposition", "attachment; filename=" + filename + ".docx")
    response.setHeader("Content-Length", bytes.length.toString)
    val out = response.getOutputStream
    out.write(bytes)
    out.flush()
    out.close()
    null
  }
}

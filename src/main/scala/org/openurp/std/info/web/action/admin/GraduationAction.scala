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

import org.beangle.commons.lang.Strings
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.doc.transfer.exporter.ExportContext
import org.beangle.webmvc.annotation.ignore
import org.beangle.webmvc.support.ActionSupport
import org.beangle.webmvc.support.action.{EntityAction, ExportSupport}
import org.beangle.webmvc.view.View
import org.openurp.base.edu.model.{Major, MajorDirection}
import org.openurp.base.model.Project
import org.openurp.base.std.model.{GraduateSeason, Student}
import org.openurp.code.edu.model.EducationLevel
import org.openurp.code.std.model.StdType
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.graduation.model.Graduation
import org.openurp.std.info.web.helper.StudentPropertyExtractor

/** 应届毕业生名单
 */
class GraduationAction extends ActionSupport, ProjectSupport, EntityAction[Student], ExportSupport[Student] {
  var entityDao: EntityDao = _

  def index(): View = {
    given project: Project = getProject

    put("levels", getCodes(classOf[EducationLevel]))
    put("stdTypes", getCodes(classOf[StdType]))
    put("departments", getDeparts)
    put("majors", findInProject(classOf[Major]))
    put("directions", findInProject(classOf[MajorDirection]))
    put("graduateSeasons", findInProject(classOf[GraduateSeason]))
    forward()
  }

  def search(): View = {
    val query = getQueryBuilder
    put("students", entityDao.search(query))
    forward()
  }

  override def getQueryBuilder: OqlBuilder[Student] = {
    val query = super.getQueryBuilder
    val season = entityDao.get(classOf[GraduateSeason], getLongId("season"))
    query.where(s"exists(from ${classOf[Graduation].getName} gr where gr.std=student and gr.batch.season=:season)", season)
    //查询导师
    get("tutor.name").foreach(n => {
      if (Strings.isNotBlank(n)) {
        query.where("exists(from graduation.student.tutors t where t.tutor.name like :tutorName)", s"%${n.trim()}%")
      }
    })
    query
  }

  @ignore
  override def configExport(context: ExportContext): Unit = {
    val extractor = new StudentPropertyExtractor(entityDao)
    extractor.usingDateFormat("yyyyMMdd")
    context.extractor = extractor
    super.configExport(context)
  }
}

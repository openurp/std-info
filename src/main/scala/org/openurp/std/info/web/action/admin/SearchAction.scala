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

import org.beangle.commons.codec.digest.Digests
import org.beangle.data.dao.EntityDao
import org.beangle.doc.transfer.exporter.ExportContext
import org.beangle.ems.app.Ems
import org.beangle.web.action.annotation.{ignore, mapping}
import org.beangle.web.action.support.ActionSupport
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.{EntityAction, ExportSupport}
import org.openurp.base.edu.model.Major
import org.openurp.base.model.{Campus, Project}
import org.openurp.base.service.Features
import org.openurp.base.std.model.{Graduate, Student}
import org.openurp.base.std.service.StudentService
import org.openurp.code.edu.model.*
import org.openurp.code.person.model.*
import org.openurp.code.std.model.{StdLabel, StudentStatus}
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.model.{Contact, Examinee, Home}
import org.openurp.std.info.service.StudentPropertyExtractor
import org.openurp.std.info.web.helper.StdSearchHelper

/**
 * 学籍查询
 */

class SearchAction extends ActionSupport, EntityAction[Student], ProjectSupport, ExportSupport[Student] {

  protected var studentService: StudentService = _

  var entityDao: EntityDao = _

  def index(): View = {
    given project: Project = getProject

    put("tutorSupported", getConfig(Features.Std.TutorSupported))
    put("departments", project.departments) // 院系部门
    put("stdTypes", project.stdTypes) // 学生类别
    put("majors", findInProject(classOf[Major]))
    put("levels", getCodes(classOf[EducationLevel])) // 培养层次
    put("genders", getCodes(classOf[Gender])) // 性别
    put("states", getCodes(classOf[StudentStatus])) // 状态
    put("campuses", findInSchool(classOf[Campus]))
    put("enrollModes", getCodes(classOf[EnrollMode])) // 入学方式

    put("studyTypes", getCodes(classOf[StudyType]))
    put("stdLabels", getCodes(classOf[StdLabel]))
    forward()
  }

  def search(): View = {
    given project: Project = getProject

    put("project", project)
    put("squadSupported", getConfig(Features.Std.SquadSupported))
    put("tutorSupported", getConfig(Features.Std.TutorSupported))
    val builder = new StdSearchHelper(entityDao, getProject).build()
    queryByDepart(builder, "student.state.department")
    val stds = entityDao.search(builder)
    put("students", stds)
    forward()
  }

  @mapping(value = "{id}")
  def info(id: String): View = {
    val student = entityDao.get(classOf[Student], id.toLong)
    put("contact", entityDao.findBy(classOf[Contact], "std", student).headOption)
    put("home", entityDao.findBy(classOf[Home], "std", student).headOption)
    put("examinee", entityDao.findBy(classOf[Examinee], "std", student).headOption)
    put("graduate", entityDao.findBy(classOf[Graduate], "std", student).headOption)
    put("avatarUrl", Ems.api + "/platform/user/avatars/" + Digests.md5Hex(student.code))
    put("student", student)
    forward()
  }

  @ignore
  override def configExport(context: ExportContext): Unit = {
    context.extractor = new StudentPropertyExtractor(entityDao)
    super.configExport(context)
  }
}

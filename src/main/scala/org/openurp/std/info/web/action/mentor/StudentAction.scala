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

package org.openurp.std.info.web.action.mentor

import org.beangle.commons.codec.digest.Digests
import org.beangle.data.dao.OqlBuilder
import org.beangle.doc.transfer.exporter.ExportContext
import org.beangle.ems.app.Ems
import org.beangle.security.Securities
import org.beangle.web.action.annotation.{ignore, mapping}
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.{EntityAction, ExportSupport}
import org.openurp.base.hr.model.Mentor
import org.openurp.base.model.Project
import org.openurp.base.service.Features
import org.openurp.base.std.model.{Graduate, Student}
import org.openurp.base.std.service.StudentService
import org.openurp.code.edu.model.*
import org.openurp.code.person.model.*
import org.openurp.code.std.model.StudentStatus
import org.openurp.starter.web.support.MentorSupport
import org.openurp.std.info.model.{Contact, Examinee, Home}
import org.openurp.std.info.service.StudentPropertyExtractor
import org.openurp.std.info.web.helper.StdSearchHelper

/**
 * 辅导员学籍查询
 */
class StudentAction extends MentorSupport, EntityAction[Student], ExportSupport[Student] {

  protected var studentService: StudentService = _

  protected override def projectIndex(mentor: Mentor)(using project: Project): View = {
    put("departments", project.departments) // 院系部门
    put("studentTypes", project.stdTypes) // 学生类别
    put("levels", codeService.get(classOf[EducationLevel])) // 培养层次
    put("genders", codeService.get(classOf[Gender])) // 性别
    put("states", codeService.get(classOf[StudentStatus])) // 状态
    put("tutorSupported", getConfig(Features.Std.TutorSupported))
    put("project", project)
    forward()
  }

  override def getQueryBuilder: OqlBuilder[Student] = {
    val project: Project = getProject
    val builder = new StdSearchHelper(entityDao, project, project.departments)
    val query = builder.build()
    query.where("student.state.squad.mentor.code = :me", Securities.user)
    query
  }

  def search(): View = {
    given project: Project = getProject

    put("tutorSupported", getConfig(Features.Std.TutorSupported))
    val stds = entityDao.search(getQueryBuilder)
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

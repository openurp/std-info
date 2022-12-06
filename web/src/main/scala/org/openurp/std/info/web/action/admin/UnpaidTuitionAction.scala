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
import org.beangle.data.dao.OqlBuilder
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.model.{Project, Semester}
import org.openurp.base.std.model.Student
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.app.model.UnpaidTuition

import java.time.Instant

class UnpaidTuitionAction extends RestfulAction[UnpaidTuition] with ProjectSupport {

  override def indexSetting(): Unit = {
    given project: Project = getProject

    put("project", project)
    put("departs", project.departments)
    put("semester", getSemester)
  }

  def reset(): View = {
    put("semester", entityDao.get(classOf[Semester], intId("unpaidTuition.semester")))
    forward()
  }

  def batchReset(): View = {
    val semester = entityDao.get(classOf[Semester], intId("unpaidTuition.semester"));
    var code = get("std_codes").orNull
    code = Strings.replace(code, "，", ",")
    val codes = Strings.split(code)
    val students = entityDao.findBy(classOf[Student], "user.code", codes)
    val uts = students.map { std =>
      val ut = new UnpaidTuition
      ut.std = std
      ut.semester = semester
      ut.updatedAt = Instant.now
      ut
    }
    val exists = OqlBuilder.from(classOf[UnpaidTuition], "ut")
    exists.where("ut.semester=:semester", semester)
    exists.where("ut.std.project=:project", getProject);
    entityDao.remove(entityDao.search(exists))
    saveOrUpdate(uts)
    redirect("search", "info.save.success")
  }
}

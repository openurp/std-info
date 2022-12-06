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

package org.openurp.std.info.web.action.student

import org.beangle.commons.codec.digest.Digests
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.ems.app.Ems
import org.beangle.security.Securities
import org.beangle.web.action.annotation.mapping
import org.beangle.web.action.support.{ActionSupport, ServletSupport}
import org.beangle.web.action.view.View
import org.openurp.base.model.Project
import org.openurp.base.std.model.{Graduate, Student}
import org.openurp.edu.program.domain.ProgramProvider
import org.openurp.starter.web.support.StudentSupport
import org.openurp.std.info.model.{Contact, Examinee, Home}
import org.openurp.std.info.web.helper.GradeHelper

class InfoAction extends StudentSupport {

  var programProvider: ProgramProvider = _

  @mapping("certificate/{lang}")
  def certificate(): View = {
    val std = getStudent()
    put("grade", GradeHelper.convert(std.state.get.grade))
    put("program", programProvider.getProgram(std))
    val lang = get("lang").get
    put("lang", lang)
    put("has_signature", true)
    forward()
  }

  override def projectIndex(student: Student): View = {
    val graduate = entityDao.unique(OqlBuilder.from(classOf[Graduate], "graduate").where("graduate.std = :student", student))
    put("graduate", graduate)
    put("contact", entityDao.unique(OqlBuilder.from(classOf[Contact], "contact").where("contact.std = :student", student)))
    put("home", entityDao.unique(OqlBuilder.from(classOf[Home], "home").where("home.std = :student", student)))
    put("examinee", entityDao.unique(OqlBuilder.from(classOf[Examinee], "examinee").where("examinee.std = :student", student)))
    put("avatarUrl", Ems.api + "/platform/user/avatars/" + Digests.md5Hex(student.code))
    forward()
  }
}

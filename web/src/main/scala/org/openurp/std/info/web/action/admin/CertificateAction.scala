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

import org.beangle.data.dao.EntityDao
import org.beangle.web.action.annotation.mapping
import org.beangle.web.action.support.ActionSupport
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.EntityAction
import org.openurp.base.std.model.Student
import org.openurp.edu.program.domain.ProgramProvider
import org.openurp.std.info.web.helper.GradeHelper

import java.time.LocalDate

/**
 * 打印在读证明
 */
class CertificateAction extends ActionSupport, EntityAction[Student] {

  var entityDao: EntityDao = _

  var programProvider: ProgramProvider = _

  @mapping("{lang}")
  def index(): View = {
    val std = entityDao.get(classOf[Student], getLongId("student"))
    val outdate = !std.within(LocalDate.now)
    put("std", std)
    if (outdate) {
      forward("outdate")
    } else {
      put("student", std)
      put("grade", GradeHelper.convert(std.state.get.grade))
      put("program", programProvider.getProgram(std))
      val lang = get("lang").get
      put("lang", lang)
      forward(if (std.registed) lang else "no")
    }
  }

}

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
import org.beangle.webmvc.annotation.mapping
import org.beangle.webmvc.support.ActionSupport
import org.beangle.webmvc.view.View
import org.beangle.webmvc.support.action.EntityAction
import org.openurp.base.std.model.Student
import org.openurp.edu.program.domain.ProgramProvider
import org.openurp.std.info.web.helper.{CertificateErrors, GradeHelper}

import java.time.LocalDate

/**
 * 打印在读证明
 */
class CertificateAction extends ActionSupport, EntityAction[Student] {

  var entityDao: EntityDao = _

  var programProvider: ProgramProvider = _

  /** 学籍证明打印
   * outdate 表示学籍失效 no 表示无学籍 notinschool 表示不在校
   *
   * @return
   */
  @mapping("{lang}")
  def index(): View = {
    val std = entityDao.get(classOf[Student], getLongId("student"))
    val active = std.within(LocalDate.now)
    put("std", std)
    put("student", std)
    if (active) {
      if (std.registed) {
        if (std.state.get.inschool) {
          put("grade", GradeHelper.convert(std.state.get.grade))
          put("program", programProvider.getProgram(std))
          put("lang", get("lang", "zh"))
          forward(get("lang", "zh"))
        } else {
          error(CertificateErrors.NotInSchool)
        }
      } else {
        error(CertificateErrors.No)
      }
    } else {
      error(CertificateErrors.Outdated)
    }
  }

  private def error(cause: String): View = {
    put("cause", CertificateErrors.translate(cause))
    forward("error")
  }

}

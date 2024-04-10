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

import org.beangle.web.action.annotation.mapping
import org.beangle.web.action.view.View
import org.openurp.edu.program.domain.ProgramProvider
import org.openurp.starter.web.support.StudentSupport
import org.openurp.std.info.web.helper.{CertificateErrors, GradeHelper}

import java.time.LocalDate

/** 在读证明
 * 学生下载个人学习在读证明
 */
class CertificateAction extends StudentSupport {

  var programProvider: ProgramProvider = _

  @mapping("{lang}")
  def cert(): View = {
    val std = getStudent
    val active = std.within(LocalDate.now)
    put("std", std)
    if (active) {
      if (std.registed) {
        if (std.state.get.inschool) {
          put("student", std)
          put("grade", GradeHelper.convert(std.state.get.grade))
          put("program", programProvider.getProgram(std))
          put("lang", get("lang", "zh"))
          put("has_signature", true)
          forward()
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

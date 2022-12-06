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

package org.openurp.std.info.service

import org.openurp.base.std.model.Student
import org.openurp.base.model.User

import java.time.LocalDate

class SaveLogForStudentParameter {

  var before: Student = _
  var now: Student = _
  var ip: String = _
  var loginUser: User = _
  var date: LocalDate = _

  def this(before: Student, now: Student, ip: String, loginUser: User, date: LocalDate)= {
    this()
    this.before = before
    this.now = now
    this.ip = ip
    this.loginUser = loginUser
    this.date = date
  }

  def this(before: Student, now: Student, ip: String, loginUser: User)={
    this()
    this.before = before
    this.now = now
    this.ip = ip
    this.loginUser = loginUser
  }

}

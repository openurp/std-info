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

class StudentLogParameter {

  var `type`: Integer = _
  var operation: String = _
  var ip: String = _
  var s: Student = _
  var loginUser: User = _

  def this(`type`: Integer, operation: String, ip: String, s: Student, loginUser: User) ={
    this()
    this.`type` = `type`
    this.operation = operation
    this.ip = ip
    this.s = s
    this.loginUser = loginUser
  }
}

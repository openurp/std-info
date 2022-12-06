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

package org.openurp.std.info.app.model

import org.beangle.data.model.LongId
import org.openurp.base.std.model.Student
import org.openurp.base.model.User

import java.time.LocalDate

/**
 * 学籍修改记录
 */

object StudentLog {
  val STD_ALL_LOG = 0
  val STD_PERSONAL_LOG = 1
}

class StudentLog extends LongId {

  /** 被操作学生 */
  var student: Student = _

  /** ip */
  var ip: String = _

  /** 操作用户 */
  var user: User = _

  /** 操作 */
  var operation: String = _

  /** 时间 */
  var time: LocalDate = _

  /** 日志类型（0：学籍变化总体日志；1：学生学籍变化个人日志） */
  var `type`: Integer = 0

}

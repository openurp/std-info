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

package org.openurp.std.info.web.helper

import org.beangle.commons.lang.Strings
import org.openurp.base.std.model.Grade

import java.text.SimpleDateFormat

object GradeHelper {

  def convert(grade1: Grade): Int = {
    val gradeStr = grade1.code
    var year, month = 0;
    val format = new SimpleDateFormat("yyyyMM")
    if (gradeStr.contains("-")) {
      year = Strings.substringBefore(gradeStr, "-").toInt
      month = Strings.substringAfter(gradeStr, "-").toInt
    } else {
      year = gradeStr.toInt
      month = 9
    }
    val date = format.format(new java.util.Date)
    val y = date.substring(0, 4).toInt
    val m = date.substring(4).toInt
    var grade = 1
    if (year == y) {
      grade = 1
    } else if (y > year) {
      if (m >= month) {
        grade = y - year + 1
      } else {
        grade = y - year
      }
    }
    grade
  }
}

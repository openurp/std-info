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

import org.openurp.base.edu.model.Major
import org.openurp.base.std.model.GraduateSeason

import java.time.LocalDate

class DesciplineHelper(season: GraduateSeason) {

  var graduateOn: LocalDate = season.graduateOn.atDay(1)

  def getDisciplineCode(major: Major): String = {
    major.getDisciplineCode(graduateOn)
  }
}

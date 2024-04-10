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

import org.openurp.code.edu.model.EducationLevel

class GraduateStatHelper {

  def dataByDepartmentEducationLevel2(eduLevels: Seq[EducationLevel], graduationStats: Seq[GraduateStat]): Map[String, Map[String, Seq[GraduateStat]]] = {
    graduationStats.filter(e => eduLevels.contains(e.eduLevel))
      .groupBy(_.department.id.toString).map {
      case (departmentId, value) => (departmentId, value.groupBy(_.eduLevel.id.toString).map {
        case (levelId, value) => (levelId, value.sortBy(f => f.major.id + f.gender.id))
      })
    }

  }

  def dataByEducationLevelMajor(graduationStats: Seq[GraduateStat]): Map[String, Map[String, Map[String, Seq[GraduateStat]]]] = {
    graduationStats.groupBy(_.eduLevel.id.toString).map {
      case (levelId, value) => (levelId, value.groupBy(_.major.id.toString).map {
        case (majorId, value) => (majorId, value.groupBy(_.gender.id.toString))
      })
    }
  }

  def dataByDepartmentEducationLevel(graduationStats: List[GraduateStat]): Map[String, Map[String, Map[String, List[GraduateStat]]]] = {
    graduationStats.groupBy(_.department.id.toString).map {
      case (departmentId, value) => (departmentId, value.groupBy(_.eduLevel.id.toString).map {
        case (levelId, value) => (levelId, value.groupBy(_.major.id.toString))
      })
    }
  }
}

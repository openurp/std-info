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

import org.beangle.data.dao.OqlBuilder
import org.openurp.base.service.AbstractBaseService
import org.openurp.base.std.model.Student

class StudentInfoService extends AbstractBaseService {

  def getStudentInfo[T](stdClass: Class[T], std: Student): Seq[T] = {
    val builder = OqlBuilder.from(stdClass, "stdInfo").where("stdInfo.std=:std", std)
    entityDao.search(builder)
  }
}

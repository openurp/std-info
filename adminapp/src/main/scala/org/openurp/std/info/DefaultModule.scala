/*
 * Copyright (C) 2005, The OpenURP Software.
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

package org.openurp.std.info

import org.beangle.cdi.bind.BindModule
import org.openurp.base.edu.service.StudentService
import org.openurp.base.service.UrpUserService
import org.openurp.std.info.service.{StudentInfoService, StudentManager}
import org.openurp.std.info.web.action._

class DefaultModule extends BindModule {

  override protected def binding(): Unit = {
    bind(classOf[GraduationAction])
    bind(classOf[GraduationStatAction], classOf[DegreeStatAction])
    bind(classOf[MajorStudentAction])
    bind(classOf[StudentSearchAction], classOf[StudentAction],classOf[StudentInfoAction],classOf[StudentReportAction])
    bind(classOf[StdEditRestrictionAction],classOf[StdPropertyMetaAction])
    bind(classOf[StudentService], classOf[StudentManager], classOf[StudentInfoService],classOf[UrpUserService])
  }
}

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

package org.openurp.std.info

import org.beangle.cdi.bind.BindModule
import org.openurp.base.std.service.impl.StudentServiceImpl
import org.openurp.edu.program.domain.DefaultProgramProvider
import org.openurp.std.info.service.{StudentInfoService, StudentManager}
import org.openurp.std.info.web.action.{admin, mentor, student}

class DefaultModule extends BindModule {

  override protected def binding(): Unit = {
    bind(classOf[admin.GraduateAction])
    bind(classOf[admin.GraduateStatAction])
    bind(classOf[admin.MajorStudentAction])
    bind(classOf[admin.SearchAction], classOf[admin.StudentAction], classOf[admin.ContactAction])
    bind(classOf[admin.CertificateAction])
    bind(classOf[admin.StatAction])
    bind(classOf[admin.AlterConfigAction], classOf[admin.AlterationAction])
    bind(classOf[admin.RegisterAction], classOf[admin.RegisterSessionAction])

    bind(classOf[StudentManager], classOf[StudentInfoService])

    bind(classOf[mentor.StudentAction])

    bind(classOf[student.InfoAction])
    bind(classOf[student.RegisterAction])

    // services
    bind(classOf[StudentServiceImpl])
    bind(classOf[DefaultProgramProvider])
  }
}

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

package org.openurp.std.info.web.action.admin

import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.model.Project
import org.openurp.code.std.model.UnregisteredReason
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.register.model.Register

class RegisterAction extends RestfulAction[Register] with ProjectSupport {

  override def indexSetting(): Unit = {
    given project: Project = getProject

    put("project", project)
    put("semester", getSemester)
    put("departs", project.departments)
    put("unregisteredReasons",getCodes(classOf[UnregisteredReason]))
  }

}

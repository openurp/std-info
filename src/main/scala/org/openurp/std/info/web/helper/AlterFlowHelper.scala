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

import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Strings
import org.beangle.data.dao.EntityDao
import org.beangle.ems.app.oa.Flows
import org.openurp.base.model.UserGroup

class AlterFlowHelper(entityDao: EntityDao) {

  def resolveGroups(flow: Flows.Flow): Iterable[UserGroup] = {
    var userGroups: collection.Seq[UserGroup] = null
//    flow.tasks
//    if (Strings.isNotBlank(flow.tasks)) {
//      val buf = Collections.newBuffer[UserGroup]
////      Strings.splitToInt(flow.auditGroupIds) foreach { gId =>
////        val userGroup = entityDao.get(classOf[UserGroup], gId)
////        if (null != userGroup) {
////          buf.addOne(userGroup)
////        }
////      }
//      userGroups = buf
//    } else {
//      userGroups = List.empty
//    }
    userGroups
  }
}

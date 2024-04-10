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

import org.beangle.commons.bean.Initializing
import org.beangle.data.dao.EntityDao
import org.beangle.ems.app.Ems
import org.beangle.ems.app.datasource.AppDataSourceFactory
import org.openurp.base.model.User
import org.openurp.base.service.UserRepo
import org.openurp.base.service.impl.DefaultUserRepo
import org.openurp.base.std.model.Student

class UserHelper extends Initializing {
  var userRepo: UserRepo = _

  var entityDao: EntityDao = _

  override def init(): Unit = {
    val ds = new AppDataSourceFactory()
    ds.name = "platform"
    ds.init()
    userRepo = new DefaultUserRepo(entityDao, ds.result, Ems.hostname)
  }

  def createUser(std: Student, oldCode: Option[String]): User = {
    userRepo.createUser(std, oldCode)
  }

  def createAccount(user: User): Unit = {
    userRepo.createAccount(user)
  }
}

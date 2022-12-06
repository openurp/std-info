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

import org.beangle.data.dao.OqlBuilder
import org.beangle.web.action.annotation.{mapping, param}
import org.beangle.web.action.support.ActionSupport
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.EntityAction
import org.openurp.base.model.{Project, User}
import org.openurp.base.std.model.Student
import org.openurp.code.edu.model.{EducationMode, EnrollMode}
import org.openurp.code.geo.model.Division
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.model.{Contact, Examinee, Home}

import java.time.Instant

/**
 * 学生家庭及联系信息维护
 */
class ContactAction extends SearchAction {

  override def search(): View = {
    super.search()
    val stds = attribute("students", classOf[Iterable[Student]])
    val contacts = entityDao.findBy(classOf[Contact], "std", stds)
    put("contactMap", contacts.map(x => (x.std, x)).toMap)
    forward()
  }

  def save(): View = {
    val std = entityDao.get(classOf[Student], longId("student"))

    val home = populateEntity(classOf[Home], "home")
    home.updatedAt = Instant.now()
    home.std = std
    entityDao.saveOrUpdate(home)

    val contact = populateEntity(classOf[Contact], "contact")
    contact.updatedAt = Instant.now()
    contact.std = std
    entityDao.saveOrUpdate(contact)

    /**
     * 同步更新用户信息
     */
    entityDao.findBy(classOf[User], "code", std.code) foreach { user =>
      if (contact.mobile.nonEmpty) user.mobile = contact.mobile
      if (contact.email.nonEmpty) user.email = contact.email
      entityDao.saveOrUpdate(user)
    }

    redirect("info", "&id=" + std.id, "info.save.success")
  }

  @mapping(value = "{id}/edit")
  def edit(@param("id") id: String): View = {
    given project: Project = getProject

    val query = OqlBuilder.from(classOf[Student], "std")
    query.where("std.project=:project and std.id=:id", project, id.toLong)
    entityDao.search(query).foreach { student =>
      put("student", student)
      put("home", entityDao.findBy(classOf[Home], "std", student).headOption)
      put("contact", entityDao.findBy(classOf[Contact], "std", student).headOption)
    }
    forward()
  }
}

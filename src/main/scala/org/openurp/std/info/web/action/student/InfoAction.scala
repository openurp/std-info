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

package org.openurp.std.info.web.action.student

import org.beangle.commons.codec.digest.Digests
import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Strings
import org.beangle.data.dao.OqlBuilder
import org.beangle.ems.app.Ems
import org.beangle.web.action.view.View
import org.openurp.base.model.{Project, User}
import org.openurp.base.std.model.{Graduate, Student}
import org.openurp.code.person.model.PoliticalStatus
import org.openurp.starter.web.support.StudentSupport
import org.openurp.std.info.model.{Contact, Examinee, Home}

import java.time.Instant
import scala.language.postfixOps

class InfoAction extends StudentSupport {
  override def projectIndex(student: Student): View = {
    val graduate = entityDao.unique(OqlBuilder.from(classOf[Graduate], "graduate").where("graduate.std = :student", student))
    put("graduate", graduate)
    put("contact", entityDao.unique(OqlBuilder.from(classOf[Contact], "contact").where("contact.std = :student", student)))
    put("home", entityDao.unique(OqlBuilder.from(classOf[Home], "home").where("home.std = :student", student)))
    put("examinee", entityDao.unique(OqlBuilder.from(classOf[Examinee], "examinee").where("examinee.std = :student", student)))
    put("avatarUrl", Ems.api + "/platform/user/avatars/" + Digests.md5Hex(student.code))
    forward()
  }

  def edit(): View = {
    val std = getStudent
    given project:Project = std.project
    put("std", std)
    val editables = Strings.split(getConfig("std.info.self.editables",""),",").toSet
    put("editables",editables)
    put("contact", entityDao.findBy(classOf[Contact], "std", std).headOption.getOrElse(new Contact))
    put("home", entityDao.findBy(classOf[Home], "std", std).headOption.getOrElse(new Home))
    put("person", std.person)
    put("api", Ems.api)
    forward()
  }

  def save(): View = {
    val std = getStudent
    val person = std.person
    val user = entityDao.findBy(classOf[User], "school" -> std.project.school, "code" -> std.code).head
    val contact = entityDao.findBy(classOf[Contact], "std", std).headOption.getOrElse(new Contact)
    val home = entityDao.findBy(classOf[Home], "std", std).headOption.getOrElse(new Home)
    if (contact.std == null) contact.std = std

    get("enName") foreach { en =>
      val enName = en.trim()
      std.enName = Some(enName)
      std.person.phoneticName = Some(enName)
      user.enName = Some(enName)
    }
    get("email") foreach { e =>
      val email = e.trim()
      user.email = Some(email)
      contact.email = Some(email)
    }
    get("phone") foreach { p =>
      contact.phone = Some(p.trim())
    }
    get("address") foreach { p =>
      contact.address = Some(p.trim())
    }
    get("mobile") foreach { m =>
      val mobile = m.trim()
      contact.mobile = Some(mobile)
      user.mobile = Some(mobile)
    }
    getInt("person.politicalStatus.id") foreach { statusId =>
      person.politicalStatus = entityDao.find(classOf[PoliticalStatus], statusId)
    }
    person.homeTown = get("person.homeTown")
    contact.updatedAt = Instant.now
    user.updatedAt = Instant.now
    entityDao.saveOrUpdate(person, user, contact)

    get("home.address") foreach { a =>
      home.address = Some(a)
      home.updatedAt = Instant.now
      if (home.std == null) home.std = std
      entityDao.saveOrUpdate(home)
    }

    redirect("index", "info.save.success")
  }

}

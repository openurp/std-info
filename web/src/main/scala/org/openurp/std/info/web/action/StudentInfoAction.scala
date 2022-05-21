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

package org.openurp.std.info.web.action

import org.beangle.data.dao.OqlBuilder
import org.beangle.web.action.view.View
import org.openurp.base.std.model.Student
import org.openurp.code.geo.model.Division
import org.openurp.std.info.model.{Contact, Examinee, Home}

import java.time.Instant

/**
 * 学生信息维护
 */
class StudentInfoAction extends StudentSearchAction {

  def editContact(): View = {
    getLong("student.id").foreach(studentId => {
      val student = entityDao.get(classOf[Student], studentId)
      put("student", student)
      put("contact", entityDao.unique(OqlBuilder.from(classOf[Contact], "contact").where("contact.std = :studentId", student)))
    })
    putEditRestriction()
    forward()
  }

  def editHome(): View = {
    getLong("student.id").foreach(studentId => {
      val student = entityDao.get(classOf[Student], studentId)
      put("student", student)
      put("home", entityDao.unique(OqlBuilder.from(classOf[Home], "home").where("home.std = :student", student)))
    })
    putBasecodeInHomeInfo()
    putEditRestriction()
    forward()
  }

  def editExaminee(): View = {
    getLong("student.id").foreach(studentId => {
      val student = entityDao.get(classOf[Student], studentId)
      put("student", student)
      put("examinee", entityDao.unique(OqlBuilder.from(classOf[Examinee], "examinee").where("examinee.std = :student", student)))
    })
    put("originDivisions", getCodes(classOf[Division]))
    putEditRestriction()
    forward()
  }

  //  override def editSetting(entity: Student): Unit = {
  //    val student: Student = entityDao.get(classOf[Student], longId("student"))
  //    put("student", student)
  //    put("contact", entityDao.unique(OqlBuilder.from(classOf[Contact], "contact").where("contact.std = :studentId", student)))
  //    put("home", entityDao.unique(OqlBuilder.from(classOf[Home], "home").where("home.std = :student", student)))
  //    put("examinee", entityDao.unique(OqlBuilder.from(classOf[Examinee], "examinee").where("examinee.std = :student", student)))
  //    putBasecodeInHomeInfo()
  //    put("originDivisions", getCodes(classOf[Division]))
  //    // putBasecodeInStdInfo();
  //    putEditRestriction()
  //    super.editSetting(entity)
  //  }

  def saveContact: View = {
    val std = entityDao.get(classOf[Student], longId("student"))
    val contact = populateEntity(classOf[Contact], "contact")
    contact.updatedAt = Instant.now()
    contact.std = std
    entityDao.saveOrUpdate(contact)
    redirect("editContact", "&student.id=" + std.id, "info.save.success")
  }

  def saveHome: View = {
    val std = entityDao.get(classOf[Student], longId("student"))
    val home = populateEntity(classOf[Home], "home")
    home.updatedAt = Instant.now()
    home.std = std
    entityDao.saveOrUpdate(home)
    redirect("editHome", "&student.id=" + std.id, "info.save.success")
  }

  def saveExaminee: View = {
    val std = entityDao.get(classOf[Student], longId("student"))
    val examinee = populateEntity(classOf[Examinee], "examinee")
    examinee.updatedAt = Instant.now()
    examinee.std = std
    entityDao.saveOrUpdate(examinee)
    redirect("editExaminee", "&student.id=" + std.id, "info.save.success")
  }

}

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

import jakarta.servlet.http.Part
import org.beangle.commons.lang.Strings
import org.beangle.ems.app.EmsApp
import org.beangle.notify.sms.{Receiver, SmsCodeService}
import org.beangle.security.Securities
import org.beangle.security.authc.DefaultAccount
import org.beangle.web.action.view.View
import org.openurp.base.model.{Project, User}
import org.openurp.base.std.model.Student
import org.openurp.code.person.model.{Gender, IdType, Nation}
import org.openurp.starter.web.support.StudentSupport
import org.openurp.std.info.model.{PersonCheck, PersonField}

import java.time.Instant

/** 学生信息确认
 */
class CheckAction extends StudentSupport {

  var smsCodeService: Option[SmsCodeService] = None

  protected override def projectIndex(student: Student): View = {
    put("check", entityDao.findBy(classOf[PersonCheck], "std", student).headOption)
    forward()
  }

  /** 核对表单
   *
   * @return
   */
  def checkForm(): View = {
    val student = getStudent

    given project: Project = student.project

    put("idTypes", getCodes(classOf[IdType]))
    put("nations", getCodes(classOf[Nation]))
    put("genders", getCodes(classOf[Gender]))
    put("smsAvailable", smsCodeService.nonEmpty)
    put("std", student)
    val user = entityDao.findBy(classOf[User], "code" -> student.code, "school" -> student.project.school).headOption
    put("mobile", user.flatMap(_.mobile))
    forward("form")
  }

  /** 核对信息
   *
   * @return
   */
  def check(): View = {
    val std = getStudent
    val mobile = get("mobile", "")
    val code = get("verificationCode", "")
    smsCodeService match
      case None =>
      case Some(s) =>
        if !s.verify(mobile, code) then return redirect("index", "验证码错误")
    val check = entityDao.findBy(classOf[PersonCheck], "std", std).headOption.getOrElse(new PersonCheck(std))
    if (check.confirmed.getOrElse(false)) {
      return redirect("index", "已经确认过")
    }
    check.changes.clear()
    check.details = ""
    val person = std.person
    check.addChange(PersonField.Name, std.name, get("person.name", ""))
    check.addChange(PersonField.Gender, std.gender.name, get("person.gender.name", ""))
    check.addChange(PersonField.Birthday, person.birthday.map(_.toString).getOrElse("--"), get("person.birthday", ""))
    check.addChange(PersonField.IdType, person.idType.name, get("person.idType.name", ""))
    check.addChange(PersonField.IdCode, person.code, get("person.code", ""))
    check.addChange(PersonField.Nation, person.nation.map(_.name).getOrElse("--"), get("person.nation.name", ""))
    check.mobile = Some(mobile)
    check.confirmed = Some(check.changes.isEmpty)
    check.updatedAt = Instant.now

    val parts = getAll("attachment", classOf[Part])
    if (parts.nonEmpty && parts.head.getSize > 0) {
      val part = parts.head
      val blob = EmsApp.getBlobRepository(true)
      val storeName = s"${std.code}_${std.name}." + Strings.substringAfterLast(part.getSubmittedFileName, ".")
      if (null != check.attachment && check.attachment.nonEmpty && check.attachment.get.startsWith("/")) blob.remove(check.attachment.get)
      val meta = blob.upload("/info/id/", part.getInputStream, storeName, std.code + " " + std.name)
      check.attachment = Some(meta.filePath)
    }
    entityDao.saveOrUpdate(check)
    redirect("index", "确认完成")
  }

  /** 发送验证码
   *
   * @return
   */
  def sendVerificationCode(): View = {
    val mobile = get("mobile", "")
    val principal = Securities.session.get.principal.asInstanceOf[DefaultAccount]
    response.setCharacterEncoding("utf-8")
    smsCodeService foreach { s =>
      if (s.validate(mobile)) {
        val rs = s.send(Receiver(mobile, principal.description))
        response.getWriter.print(rs)
      } else {
        response.getWriter.print("手机号格式不正确")
      }
    }
    null
  }
}

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

import org.beangle.data.dao.OqlBuilder
import org.beangle.security.Securities
import org.beangle.web.action.annotation.mapping
import org.beangle.web.action.view.View
import org.beangle.web.servlet.util.RequestUtils
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.model.{Semester, User}
import org.openurp.base.std.model.Student
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.fee.model.Debt
import org.openurp.std.register.config.RegisterSession
import org.openurp.std.register.model.Register

import java.time.Instant

class RegisterAction extends RestfulAction[Register] with ProjectSupport {

  override def index(): View = {
    val std = getStudent2()
    val query = OqlBuilder.from(classOf[Register], "r")
    query.where("r.std=:std", std)
    query.orderBy("r.semester.beginOn desc")
    val registers = entityDao.search(query)
    put("registers", registers)
    val schemeQuery = OqlBuilder.from(classOf[RegisterSession], "s")
    schemeQuery.where("s.project=:project", std.project)
    schemeQuery.where("s.endAt>:now", Instant.now)
    schemeQuery.where("s.level=:level", std.level)
    schemeQuery.where("locate(:grade,s.grades)>0", std.state.get.grade)

    val sessions = entityDao.search(schemeQuery)
    put("sessions", sessions)
    if sessions.nonEmpty then put("debts", getDebts(std))

    forward()
  }

  private def getDebts(std: Student): Iterable[Debt] = {
    val tuitionQuery = OqlBuilder.from(classOf[Debt], "ut")
    tuitionQuery.where("ut.std=:std", std)
    entityDao.search(tuitionQuery)
  }

  protected def getStudent2(): Student = {
    val builder = OqlBuilder.from(classOf[Student], "s")
    builder.where("s.user.code=:code", Securities.user)
    entityDao.search(builder).head
  }

  @mapping(value = "new", view = "new,form")
  override def editNew(): View = {
    val session = entityDao.get(classOf[RegisterSession], getLongId("session"))
    if (!session.canApply()) {
      redirect("index", "不在操作时间内")
    }

    val std = getStudent2()
    var entity = getEntity(classOf[Register], "register")
    //如果没有给id,也需要查一查
    if (!entity.persisted) {
      val applyQuery = OqlBuilder.from(classOf[Register], "r")
      applyQuery.where("r.semester=:semester", session.semester)
      applyQuery.where("r.std=:me", std)
      entityDao.search(applyQuery) foreach { e =>
        entity = e
      }
    }
    put("session", session)
    put("std", std)
    val user = entityDao.findBy(classOf[User], "code", std.code).head
    put("mobile", user.mobile.getOrElse(""))
    editSetting(entity)
    put(simpleEntityName, entity)
    forward()
  }

  override def saveAndRedirect(apply: Register): View = {
    val scheme = entityDao.get(classOf[RegisterSession], getLongId("session"))
    val std = getStudent2()
    if (!scheme.canApply()) {
      redirect("index", "不在操作时间内")
    }
    if (getDebts(std).nonEmpty) {
      redirect("index", "没有完成缴费")
    }
    apply.std = std
    apply.semester = scheme.semester
    apply.registered = Some(true)
    apply.registerAt = Some(Instant.now)
    apply.checkin = Some(true)
    apply.tuitionPaid = Some(true)
    apply.operateBy = std.code + " " + std.name
    apply.operateIp = RequestUtils.getIpAddr(request)

    val user = entityDao.findBy(classOf[User], "code", std.code).head
    user.mobile = get("mobile")
    saveOrUpdate(List(apply, user))
    redirect("index", "info.save.success")
  }

}

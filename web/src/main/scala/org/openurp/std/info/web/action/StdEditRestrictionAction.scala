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

import org.beangle.commons.collection.Order
import org.beangle.data.dao.OqlBuilder
import org.beangle.ems.meta.EntityMeta
import org.beangle.web.action.annotation.{mapping, param}
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.base.model.User
import org.openurp.starter.edu.helper.ProjectSupport
import org.openurp.std.info.app.model.StdEditRestriction

/**
 * 学生信息修改权限配置
 */
class StdEditRestrictionAction extends RestfulAction[StdEditRestriction] with ProjectSupport {

  override def indexSetting(): Unit = {
    val builder = OqlBuilder.from(classOf[User], "user").where("user.school = :school", getProject.school).limit(getPageLimit)
    get(Order.OrderStr) foreach { orderClause =>
      builder.orderBy(orderClause)
    }
    populateConditions(builder)
    val users = entityDao.search(builder)
    put("users", users)
    val restrictions = entityDao.getAll(classOf[StdEditRestriction])
    val userMap = restrictions.map(e => (e.user, e.metas.size)).toMap
    put("userMap", userMap)
    super.indexSetting()
  }

  def editForm(): View = {
    val entityMetas = entityDao.findBy(classOf[EntityMeta], "remark", List(classOf[StdEditRestriction].getName))
    val user = entityDao.get(classOf[User], longId("user"))
    put("stdEditRestrictions", entityDao.findBy(classOf[StdEditRestriction], "user", List(user)))
    put("user", user)
    put("entityMetas", entityMetas)
    forward()
  }

  /**
   * 删除
   *
   * @return
   */
  @throws[Exception]
  override def remove(): View = {
    val userIds = longIds("userGroup")
    if (userIds.isEmpty) return redirect("index", "info.action.failure")
    val groups = entityDao.find(classOf[User], userIds)
    val stdEditRestrictions = entityDao.findBy(classOf[StdEditRestriction], "userGroup", groups)
    try removeAndRedirect(stdEditRestrictions) catch {
      case e: Exception =>
        logger.info("removeAndRedirect failure", e)
        redirect("search", "info.delete.failure")
    }
  }

  /**
   * 查看信息
   *
   * @return
   */
  @mapping(value = "{id}")
  override def info(@param("id") id: String): View = {
    put("stdEditRestrictions", entityDao.search(OqlBuilder.from(classOf[StdEditRestriction], "restriction").where("restriction.user.id=:userId", longId("user"))))
    forward()
  }

  /**
   * 保存对象
   *
   * @param entity
   * @return
   */
  override def save(): View = {
    val stdEditRestriction = populateEntity()
    if (stdEditRestriction.persisted) {
      val userId = getLong("stdEditRestriction.user.id")
      if (userId.isEmpty) return redirect("index", "info.save.failure")
      stdEditRestriction.user = entityDao.get(classOf[User], userId.get)
    }
    stdEditRestriction.metas.clear()
    getBoolean("saveAll", false) match {
      case true => {
        val entityMetas = entityDao.findBy(classOf[EntityMeta], "remark", entityName)
        stdEditRestriction.metas.++=(entityMetas)
      }
      case false => {
        val ids = intIds("entityMeta")
        if (ids.nonEmpty) {
          val entityMetas = entityDao.find(classOf[EntityMeta], ids)
          stdEditRestriction.metas.++=(entityMetas)
        }
      }
    }
    try {
      if (stdEditRestriction.metas.isEmpty) entityDao.remove(stdEditRestriction)
      else entityDao.saveOrUpdate(stdEditRestriction)
      redirect("index", "info.save.success")
    } catch {
      case e: Exception =>
        logger.info("saveAndForwad failure", e)
        redirect("index", "info.save.failure")
    }
  }
}

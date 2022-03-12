/*
 * Copyright (C) 2005, The OpenURP Software.
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

import org.beangle.commons.collection.{Collections, Order}
import org.beangle.commons.lang.ClassLoaders
import org.beangle.commons.lang.reflect.BeanInfos
import org.beangle.commons.text.i18n.Messages
import org.beangle.data.dao.OqlBuilder
import org.beangle.ems.meta.{EntityMeta, PropertyMeta}
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.RestfulAction
import org.openurp.std.info.app.model.StdEditRestriction
import org.springframework.context.i18n.LocaleContextHolder.getLocale

import java.beans.PropertyDescriptor
import scala.util.control.Breaks.{break, breakable}

/**
 * 只适用对学生信息修改而做的 元信息维护,给entityMeta的remark加入了StdEditRestriction的ClassName以作为标识
 */
class StdPropertyMetaAction extends RestfulAction[PropertyMeta] {

  def initPropertyMetas: View = {
    val messages: Messages = Messages.apply(getLocale)
    val stdEditRestrictions = entityDao.getAll(classOf[StdEditRestriction])
    entityDao.remove(stdEditRestrictions)
    val propertyMetas = entityDao.findBy(classOf[PropertyMeta], "meta.remark", List(classOf[StdEditRestriction].getName))
    entityDao.remove(propertyMetas)
    val entityMetas = entityDao.findBy(classOf[EntityMeta], "remark", List(classOf[StdEditRestriction].getName))
    val toSave = Collections.newBuffer[PropertyMeta]
    entityMetas.foreach(entityMeta => {
      try {
        val clazz = ClassLoaders.load(entityMeta.name)
        val fields = clazz.getDeclaredFields
        fields.foreach(field => {
          //          if ("serialVersionUID" == field.getName || classOf[Collection[_]].isAssignableFrom(field.getType)) {
          //            continue //todo: continue is not supported
          //
          //          }
          val propertyMeta = new PropertyMeta
          propertyMeta.meta = entityMeta
          propertyMeta.comments = Option(messages.get(clazz, field.getName))
          if (!propertyMeta.comments.equals(field.getName)) {
            propertyMeta.name = field.getName
            propertyMeta.`type` = field.getType.getName
            toSave.+=(propertyMeta)
          }
        })
      } catch {
        case e: ClassNotFoundException =>
          e.printStackTrace()
      }
    })
    entityDao.saveOrUpdate(toSave)
    redirect("search")
  }

  override def search(): View = {
    put("propertyMetas", entityDao.search(getQueryBuilder(classOf[PropertyMeta], "propertyMeta")))
    put("entityMetas", entityDao.findBy(classOf[EntityMeta], "remark", List(classOf[StdEditRestriction].getName)))
    forward()
  }

  def getQueryBuilder[T](className: Class[T], alias: String): OqlBuilder[T] = {
    val builder: OqlBuilder[T] = OqlBuilder.from(className, alias)
    get(Order.OrderStr) foreach { orderClause =>
      builder.orderBy(orderClause)
    }
    builder.limit(getPageLimit)
    val entityName = classOf[StdEditRestriction].getName
    alias match {
      case "propertyMeta" => builder.where(alias + ".meta.remark =:remark", entityName)
      case "entityMeta" => builder.where(alias + ".remark =:remark", entityName)
      case _ =>
    }
    populateConditions(builder)
    builder
  }

  def entityMetaList: View = {
    put("entityMetas", entityDao.search(getQueryBuilder(classOf[EntityMeta], "entityMeta")))
    forward()
  }

  override def editSetting(entity: PropertyMeta): Unit = {
    put("entityMetas", entityDao.findBy(classOf[EntityMeta], "remark", List(classOf[StdEditRestriction].getName)))
    super.editSetting(entity)
  }

  override def saveAndRedirect(propertyMeta: PropertyMeta): View = {
    val entityMeta = entityDao.get(classOf[EntityMeta], propertyMeta.meta.id)
    val builder = OqlBuilder.from(classOf[PropertyMeta], "propertyMeta")
    builder.where("propertyMeta.name =:name", propertyMeta.name)
    builder.where("propertyMeta.meta = :entityMeta", propertyMeta.meta)
    if (propertyMeta.persisted) {
      builder.where("propertyMeta.id != :propertyMetaId", propertyMeta.id)
    }
    val propertyMetas = entityDao.search(builder)
    if (propertyMetas.nonEmpty) {
      redirect("search", "该属性已存在")
    }
    try {
      val result = BeanInfos.get(ClassLoaders.load(entityMeta.name)).getPropertyTypeInfo(propertyMeta.name)
      result match {
        case Some(value) => {
          propertyMeta.`type` = value.clazz.getName
          entityDao.saveOrUpdate(propertyMeta)
          redirect("search", "info.save.success")
        }
        case None => redirect("search", entityMeta.comments + "中没有" + propertyMeta.name + "属性")
      }
    } catch {
      case e: Exception =>
        logger.info("saveAndForward failure", e)
        redirect("search", "info.save.failure")
    }
  }

  def saveEntityMeta: View = {
    val entityMeta = populateEntity(classOf[EntityMeta], "entityMeta")
    entityMeta.remark = Option(classOf[StdEditRestriction].getName)
    val metaBuilder = OqlBuilder.from(classOf[EntityMeta], "entityMeta")
    metaBuilder.where("entityMeta.name=:name", entityMeta.name)
    metaBuilder.where("entityMeta.remark=:remark", classOf[StdEditRestriction].getName)
    val entityMetas = entityDao.search(metaBuilder)
    if (entityMetas.nonEmpty && !(entityMetas(0).id == entityMeta.id)) {
      redirect("entityMetaList", "该名称已存在")
    }
    try {
      Class.forName(entityMeta.name)
      entityDao.saveOrUpdate(entityMeta)
      redirect("entityMetaList", "info.save.success")
    } catch {
      case e: ClassNotFoundException =>
        logger.info("saveAndForward failure", e)
        redirect("entityMetaList", "没有" + entityMeta.name + "类")
      case e: Exception =>
        logger.info("saveAndForward failure", e)
        redirect("entityMetaList", "info.save.failure")
    }
  }

  def editEntityMeta: View = {
    val entityMetaId = getInt("entityMeta.id")
    val entityMeta =
      if (entityMetaId.isEmpty) {
        populateEntity(classOf[EntityMeta], "entityMeta")
      }
      else {
        entityDao.get(classOf[EntityMeta], entityMetaId.get)
      }
    put("entityMeta", entityMeta)
    forward("entityMetaForm")
  }

  def removeEntityMeta(): View = {
    val entityMetas = entityDao.find(classOf[EntityMeta], intIds("entityMeta"))
    try {
      entityDao.remove(entityMetas)
      redirect("entityMetaList", "info.remove.success")
    } catch {
      case e: Exception =>
        logger.info("removeAndRedirect failure", e)
        redirect("search", "info.delete.failure")
    }

  }

}

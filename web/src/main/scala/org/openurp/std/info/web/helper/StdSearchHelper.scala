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

import org.beangle.commons.collection.Order
import org.beangle.data.dao.{Condition, EntityDao, OqlBuilder}
import org.beangle.web.action.context.Params
import org.beangle.web.action.support.ActionSupport
import org.beangle.webmvc.support.helper.QueryHelper
import org.openurp.base.model.{Department, Project}
import org.openurp.base.std.model.{Graduate, Student}
import org.openurp.std.info.model.{Contact, Examinee, Home}

import java.time.LocalDate

class StdSearchHelper(entityDao: EntityDao, project: Project, departs: Iterable[Department]) {

  def build(): OqlBuilder[Student] = {
    val builder = OqlBuilder.from(classOf[Student], "student")
    QueryHelper.populate(builder)
    QueryHelper.sort(builder)
    builder.tailOrder("student.id")
    builder.limit(QueryHelper.pageLimit)

    builder.where("student.project=:project", project)
    builder.where("student.state.department in (:departments)", departs)
    val date = LocalDate.now()
    Params.get("status").foreach(status => {
      status match {
        case "active" => builder.where("student.beginOn<= :now and student.endOn>=:now and student.registed=true and student.state.inschool = true", date)
        case "unactive" => builder.where("student.beginOn<= :now and student.endOn>=:now and student.registed=true and student.state.inschool = false", date)
        case "available" => builder.where("student.beginOn<= :now and student.endOn>=:now and student.registed=true ", date)
        case "unavailable" => builder.where("student.beginOn> :now or student.endOn<:now or student.registed=false", date)
        case "" =>
      }
    })
    addSubQuery(builder, classOf[Graduate], classOf[Contact], classOf[Home], classOf[Examinee])
    Params.getInt("squad.id").foreach(squadId => {
      builder.where("student.state.squad.id = :squadId", squadId)
    })
    Params.getInt("stdLabel.id").foreach(stdLabelId => {
      builder.where("exists (from student.labels label where label.id = :labelId)", stdLabelId)
    })
    builder.orderBy(Params.get(Order.OrderStr).getOrElse("student.state.grade.id desc,student.code"))
    builder.tailOrder("student.id")
    builder
  }

  private def addSubQuery(builder: OqlBuilder[Student], infoClasses: Class[_]*): Unit = {
    infoClasses.foreach(infoClass => {
      if (entityDao.domain.getEntity(infoClass).get.getProperty("std").nonEmpty) {
        val subQuery = OqlBuilder.from(infoClass)
        QueryHelper.populate(subQuery)
        if (subQuery.params.nonEmpty) {
          val subSql = new StringBuilder
          subSql.append("exists (from ").append(infoClass.getName).append(" ").append(subQuery.alias)
          subSql.append(" where ").append(subQuery.alias).append(".").append("std = student")
          val conditionstr = subQuery.build().statement
          val a = conditionstr.replace("select " + subQuery.alias + " from " + infoClass.getName + " " + subQuery.alias + " where", " and")
          subSql.append(a)
          subSql.append(")")
          builder.where(new Condition(subSql.toString()))
          builder.params(subQuery.params);
        }
      }
    })
  }
}

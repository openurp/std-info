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

import org.beangle.commons.collection.Collections
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.web.action.support.ActionSupport
import org.beangle.web.action.view.View
import org.beangle.webmvc.support.action.{EntityAction, RestfulAction}
import org.openurp.base.edu.model.Major
import org.openurp.base.model.Department
import org.openurp.base.std.model.{Graduate, GraduateSeason}
import org.openurp.code.edu.model.EducationLevel
import org.openurp.code.person.model.Gender
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.web.helper.{DesciplineHelper, GraduateStat, GraduateStatHelper}

class GraduateStatAction extends ActionSupport with EntityAction[Graduate] with ProjectSupport {

  var entityDao: EntityDao = _

  def index(): View = {
    val query = OqlBuilder.from(classOf[GraduateSeason], "season")
    query.where("season.project=:project", getProject)
    query.orderBy("season.code desc")
    put("seasons", entityDao.search(query))
    forward()
  }

  def stat(): View = {
    forward()
  }

  def graduateStat(): View = {
    val season = entityDao.get(classOf[GraduateSeason], intId("season"))
    put("desciplineHelper", new DesciplineHelper(season))

    val builder = OqlBuilder.from(classOf[Graduate].getName, " graduate")
    builder.where("graduate.season = :season", season)
    builder.where("graduate.std.state.major is not null")
    builder.where("graduate.std.state.department is not null")
    builder.groupBy("graduate.std.state.department.id, graduate.std.level.id,graduate.std.state.major.id,graduate.std.person.gender.id")
    builder.select("graduate.std.state.department.id, graduate.std.level.id,graduate.std.state.major.id,graduate.std.person.gender.id, count(*)")
    val results = entityDao.search(builder).asInstanceOf[Seq[Array[Any]]]
    val departmentMap: Map[String, Department] = entityDao.getAll(classOf[Department]).map(x => (x.id.toString, x)).toMap
    val educationLevelMap = entityDao.getAll(classOf[EducationLevel]).map(x => (x.id.toString, x)).toMap
    val majorMap = entityDao.getAll(classOf[Major]).map(x => (x.id.toString, x)).toMap
    val genderMap = entityDao.getAll(classOf[Gender]).map(x => (x.id.toString, x)).toMap
    put("departmentMap", departmentMap)
    put("departments", departmentMap.values.toSeq)
    put("educationLevelMap", educationLevelMap)
    put("educationLevels", educationLevelMap.values.toSeq)
    put("majorMap", majorMap)
    put("majors", majorMap.values.toSeq)
    put("genderMap", genderMap)
    put("genders", genderMap.values.toSeq)
    val graduateStats = Collections.newBuffer[GraduateStat]
    results.foreach(result => {
      graduateStats.+=:(new GraduateStat(departmentMap.get(result(0).toString).get, educationLevelMap.get(result(1).toString).get, majorMap.get(result(2).toString).get, genderMap.get(result(3).toString).get, result(4).asInstanceOf[Number]))
    })
    put("departmentMap", departmentMap)
    put("graduateStats", graduateStats.toSeq)
    put("graduateStatHelper", new GraduateStatHelper)
    put("project", getProject)
    put("season",season)

    forward()
  }

  def degreeStat(): View = {
    val season = entityDao.get(classOf[GraduateSeason], intId("season"))
    put("desciplineHelper", new DesciplineHelper(season))

    val builder: OqlBuilder[Array[AnyRef]] = OqlBuilder.from(classOf[Graduate].getName + " graduate")
    builder.where("graduate.season = :season", season)
    builder.where("graduate.degreeAwardOn is not null")
    builder.where("graduate.std.state.major is not null")
    builder.where("graduate.std.state.department is not null")
    builder.groupBy("graduate.std.state.department.id, graduate.std.level.id,graduate.std.state.major.id,graduate.std.person.gender.id")
    builder.select("graduate.std.state.department.id, graduate.std.level.id,graduate.std.state.major.id,graduate.std.person.gender.id, count(*)")
    val results = entityDao.search(builder).asInstanceOf[Seq[Array[Any]]]
    val departmentMap: Map[String, Department] = entityDao.getAll(classOf[Department]).map(x => (x.id.toString, x)).toMap
    val educationLevelMap = entityDao.getAll(classOf[EducationLevel]).map(x => (x.id.toString, x)).toMap
    val majorMap = entityDao.getAll(classOf[Major]).map(x => (x.id.toString, x)).toMap
    val genderMap = entityDao.getAll(classOf[Gender]).map(x => (x.id.toString, x)).toMap
    put("departmentMap", departmentMap)
    put("departments", departmentMap.values.toSeq)
    put("educationLevelMap", educationLevelMap)
    put("educationLevels", educationLevelMap.values.toSeq)
    put("majorMap", majorMap)
    put("majors", majorMap.values.toSeq)
    put("genderMap", genderMap)
    put("genders", genderMap.values.toSeq)
    val gradautionStats = Collections.newBuffer[GraduateStat]
    results.foreach(result => {
      gradautionStats.+=:(new GraduateStat(departmentMap(result(0).toString), educationLevelMap.get(result(1).toString).get, majorMap.get(result(2).toString).get, genderMap.get(result(3).toString).get, result(4).asInstanceOf[Number]))
    })
    put("graduateStats", gradautionStats.toSeq)
    put("graduateStatHelper", new GraduateStatHelper)
    put("season",season)
    forward()
  }
}

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

import org.beangle.commons.collection.Collections
import org.beangle.data.dao.OqlBuilder
import org.beangle.web.action.view.View
import org.beangle.web.action.support.ActionSupport
import org.beangle.webmvc.support.action.EntityAction
import org.openurp.base.edu.model.Major
import org.openurp.base.model.Department
import org.openurp.code.edu.model.EducationLevel
import org.openurp.code.person.model.Gender
import org.openurp.std.info.data.GraduationStat
import org.openurp.std.info.helper.{DesciplineHelper, GraduationStatHelper}
import org.openurp.std.info.model.Graduation

class DegreeStatAction extends ActionSupport with EntityAction[Graduation] {
  def index(): Unit = {
    put("years", entityDao.search(OqlBuilder.from(classOf[Graduation].getName, "graduation").select("distinct graduation.degreeAwardOn").where("graduation.degreeAwardOn is not null")))
    forward()
  }

  def stat(): View = {
    val builder: OqlBuilder[Array[AnyRef]] = OqlBuilder.from(classOf[Graduation].getName + " graduation")
    getDate("degreeAwardOn").foreach(degreeAwardOn => {
      builder.where("graduation.degreeAwardOn = :degreeAwardOn", degreeAwardOn)
      put("desciplineHelper", new DesciplineHelper(degreeAwardOn))
      put("degreeAwardOn",degreeAwardOn)
    })
    builder.where("graduation.std.state.major is not null")
    builder.where("graduation.std.state.department is not null")
    builder.groupBy("graduation.std.state.department.id, graduation.std.level.id,graduation.std.state.major.id,graduation.std.person.gender.id")
    builder.select("graduation.std.state.department.id, graduation.std.level.id,graduation.std.state.major.id,graduation.std.person.gender.id, count(*)")
    val results= entityDao.search(builder).asInstanceOf[Seq[Array[Any]]]
    val departmentMap: Map[String, Department] = entityDao.getAll(classOf[Department]).map(x => (x.id.toString, x)).toMap
    val educationLevelMap = entityDao.getAll(classOf[EducationLevel]).map(x => (x.id.toString, x)).toMap
    val majorMap = entityDao.getAll(classOf[Major]).map(x => (x.id.toString, x)).toMap
    val genderMap = entityDao.getAll(classOf[Gender]).map(x => (x.id.toString, x)).toMap
    put("departmentMap",departmentMap)
    put("departments",departmentMap.values.toSeq)
    put("educationLevelMap",educationLevelMap)
    put("educationLevels",educationLevelMap.values.toSeq)
    put("majorMap",majorMap)
    put("majors",majorMap.values.toSeq)
    put("genderMap",genderMap)
    put("genders",genderMap.values.toSeq)
    val gradautionStats = Collections.newBuffer[GraduationStat]
    results.foreach(result => {
      gradautionStats.+=:(new GraduationStat(departmentMap.get(result(0).toString).get, educationLevelMap.get(result(1).toString).get, majorMap.get(result(2).toString).get, genderMap.get(result(3).toString).get, result(4).asInstanceOf[Number]))
    })
    put("graduationStats", gradautionStats.toSeq)
    put("graduationStatHelper", new GraduationStatHelper)
    forward()
  }

}

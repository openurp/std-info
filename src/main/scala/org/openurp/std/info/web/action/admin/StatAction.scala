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
import org.openurp.base.model.{Campus, Department}
import org.openurp.base.std.model.{Grade, Student}
import org.openurp.code.edu.model.{EducationLevel, EducationType}
import org.openurp.code.std.model.StdType
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.web.helper.StatMatrix

import java.time.LocalDate

/** 在校人数统计
 */
class StatAction extends ActionSupport, ProjectSupport {

  var entityDao: EntityDao = _

  def index(): View = {
    val project = getProject
    val q = OqlBuilder.from[Array[Any]](classOf[Student].getName, "std")
    q.where("std.project=:project", project)
    q.where("std.registed=true and std.state.inschool=true") //在籍在校
    q.where(":now between std.state.beginOn and std.state.endOn", LocalDate.now)
    q.select(s"std.state.grade.id,std.level.id,std.state.department.id,std.stdType.id,std.eduType.id,std.state.campus.id," +
      s"count(*) total,sum(case when std.gender.id=2 then 1 else 0 end) female")
    q.groupBy("std.state.grade.id,std.level.id,std.state.department.id,std.stdType.id,std.eduType.id,std.state.campus.id")

    getLong("grade.id") foreach { id =>
      q.where("std.state.grade.id=:gradeId", id)
      put("grade", entityDao.get(classOf[Grade], id))
    }
    getInt("depart.id") foreach { id =>
      q.where("std.state.department.id=:depart", id)
      put("depart", entityDao.get(classOf[Department], id))
    }
    getInt("level.id") foreach { id =>
      q.where("std.level.id=:levelId", id)
      put("level", entityDao.get(classOf[EducationLevel], id))
    }
    getInt("stdType.id") foreach { id =>
      q.where("std.stdType.id=:stdTypeId", id)
      put("stdType", entityDao.get(classOf[StdType], id))
    }
    getInt("campus.id") foreach { id =>
      q.where("std.state.campus.id=:campusId", id)
      put("campus", entityDao.get(classOf[Campus], id))
    }
    getInt("eduType.id") foreach { id =>
      q.where("std.eduType.id=:eduTypeId", id)
      put("eduType", entityDao.get(classOf[EducationType], id))
    }

    val datas = Collections.newBuffer[StatMatrix.Row]
    entityDao.search(q) foreach { d =>
      val gradeId = d(0).asInstanceOf[Long]
      val levelId = d(1).asInstanceOf[Int]
      val departmentId = d(2).asInstanceOf[Int]
      val stdTypeId = d(3).asInstanceOf[Int]
      val eduTypeId = d(4).asInstanceOf[Int]
      val campusId = d(5).asInstanceOf[Int]
      val total = d(6).asInstanceOf[Number].intValue
      val female = d(7).asInstanceOf[Number].intValue
      val data = StatMatrix.Row(Seq(gradeId, levelId, departmentId, stdTypeId, eduTypeId, campusId), Array(total, female))
      datas.addOne(data)
    }
    val dimensions = StatMatrix.statDimensions(entityDao, datas,
      Seq("grade" -> classOf[Grade], "level" -> classOf[EducationLevel], "depart" -> classOf[Department],
        "stdType" -> classOf[StdType], "eduType" -> classOf[EducationType], "campus" -> classOf[Campus]))
    val matrix = new StatMatrix(dimensions, datas)
    put("matrix", matrix)
    put("project", project)
    forward()
  }
}

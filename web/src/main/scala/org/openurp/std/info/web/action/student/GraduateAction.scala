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
import org.beangle.web.action.annotation.mapping
import org.beangle.web.action.view.View
import org.openurp.base.hr.model.President
import org.openurp.base.std.model.Graduate
import org.openurp.starter.web.support.StudentSupport

/** 毕业证书翻译件
 * 学生下载个人毕业证书翻译件
 */
class GraduateAction extends StudentSupport {

  @mapping("{cert}")
  def cert(): View = {
    val std = getStudent
    entityDao.findBy(classOf[Graduate], "std", std).headOption match
      case None => error("尚未找到您的毕业信息，暂时不能下载")
      case Some(g) =>
        put("graduate", g)
        val cert = get("cert", "degree")
        val date = cert match {
          case "degree" => g.degreeAwardOn
          case "graduate" => g.graduateOn.orElse(g.finishOn)
        }
        date foreach { d =>
          val query = OqlBuilder.from(classOf[President], "p")
          query.where("p.school=:school", std.project.school)
          query.where("p.beginOn<=:date", d)
          query.where("p.endOn is null or p.endOn>=:date", d)
          put("president", entityDao.search(query).headOption)
        }

        put("cert", cert)
        forward()
  }

  private def error(cause: String): View = {
    put("cause", cause)
    forward("error")
  }
}

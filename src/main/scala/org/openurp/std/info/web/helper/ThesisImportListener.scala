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

import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.doc.transfer.importer.{ImportListener, ImportResult}
import org.openurp.base.model.Project
import org.openurp.base.std.model.{Student, Thesis}

class ThesisImportListener(entityDao: EntityDao, project: Project) extends ImportListener {

  override def onItemStart(tr: ImportResult): Unit = {
    transfer.curData.get("std.code") foreach { code =>
      val query = OqlBuilder.from(classOf[Student], "s")
      query.where("s.code=:code and s.project=:project", code, project)
      val stds = entityDao.search(query).headOption match {
        case None => tr.addFailure("学号不存在", code)
        case Some(std) =>
          transfer.curData.put("thesis.std", std)
          entityDao.findBy(classOf[Thesis], "std", std).headOption foreach { g =>
            transfer.current = g
          }
      }
    }
  }

  override def onItemFinish(tr: ImportResult): Unit = {
    val g = transfer.current.asInstanceOf[Thesis]
    entityDao.saveOrUpdate(g)
  }
}

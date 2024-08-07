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

package org.openurp.std.info.web.listener

import org.beangle.data.dao.EntityDao
import org.beangle.doc.transfer.importer.{ImportListener, ImportResult}
import org.openurp.base.std.model.Student
import org.openurp.std.info.model.MajorStudent

import java.time.Instant

class MajorStudentImportListener(entityDao: EntityDao) extends ImportListener {
  override def onStart(tr: ImportResult): Unit = {}

  override def onFinish(tr: ImportResult): Unit = {}

  override def onItemStart(tr: ImportResult): Unit = {
    transfer.curData.get("majorStudent.std.code") foreach { code =>
      val cs = entityDao.findBy(classOf[MajorStudent], "std.code", List(code))
      if (cs.nonEmpty) {
        transfer.current = cs.head
      } else {
        val stds = entityDao.findBy(classOf[Student], "code", List(code))
        if (stds.nonEmpty) transfer.current.asInstanceOf[MajorStudent].std = stds.head
      }
    }
  }

  override def onItemFinish(tr: ImportResult): Unit = {
    val minor = transfer.current.asInstanceOf[MajorStudent]
    if (minor.school != null && minor.school.persisted && minor.majorName != null) {
      minor.updatedAt = Instant.now
      entityDao.saveOrUpdate(minor)
    }
  }
}

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

import org.beangle.commons.bean.{DefaultPropertyExtractor, Properties}
import org.beangle.commons.collection.Collections
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.openurp.base.std.model.{Graduate, Student}
import org.openurp.std.info.model.{Contact, Examinee, Home}

import java.time.LocalDate
import java.time.format.DateTimeFormatter

class StudentPropertyExtractor(entityDao: EntityDao) extends DefaultPropertyExtractor {

  private var current: Student = _

  /** std_id_{home|contact|...} */
  private val stdInfoMap = Collections.newMap[String, Object]

  private var sdfYMD = DateTimeFormatter.ofPattern("yyyy-MM-dd")

  override def get(target: Object, property: String): Any = {
    val student = target.asInstanceOf[Student]
    val idx = property.indexOf('.')
    if (idx == -1) {
      loadPropertyValue(student, property)
    } else {
      val className = property.substring(0, idx)
      val fieldName = property.substring(idx + 1)
      if ("std" == className) {
        if ("labels" == fieldName) {
          val labelValue = new StringBuilder
          student.labels.keySet.foreach(labelType => {
            if (labelValue.nonEmpty) {
              labelValue.append(";")
            }
            student.labels.get(labelType).foreach(label => {
              labelValue.append(labelType.name).append(":").append(label.name)
            })
          })
          return labelValue.toString
        } else {
          return loadPropertyValue(student, fieldName)
        }
      }
      if ("person" == className) {
        return loadPropertyValue(student.person, fieldName)
      }
      loadPropertyValue(loadStdOtherEntity(student, className), fieldName)
    }
  }

  private def loadPropertyValue(target: Object, fieldName: String): Any = {
    if (null == target) {
      return ""
    }
    try {
      val value = target match {
        case Some(a) => Properties.get[Object](a, fieldName)
        case _ => Properties.get[Object](target, fieldName)
      }
      value match {
        case b: java.lang.Boolean => if (b) "是" else "否"
        case ld: LocalDate => sdfYMD.format(ld)
        case null => ""
        case Some(v) => String.valueOf(v)
        case None => ""
        case _ => String.valueOf(value)
      }
    } catch {
      case e: Exception => throw new RuntimeException(e)
    }
  }

  def usingDateFormat(format: String): Unit = {
    sdfYMD = DateTimeFormatter.ofPattern(format)
  }

  private def loadStdOtherEntity(student: Student, className: String): Object = {
    val key = student.id.toString + "_" + className
    if (!stdInfoMap.contains(key)) {
      if (null == current || !(current == student)) {
        current = student
        stdInfoMap.clear()
      }
      if (className == "graduate") {
        stdInfoMap.put(key, entityDao.findBy(classOf[Graduate], "std.id", student.id))
      }
      else if (className == "contact") {
        stdInfoMap.put(key, entityDao.unique(OqlBuilder.from(classOf[Contact], "contact").where("contact.std = :student", student)))
      }
      else if (className == "home") {
        stdInfoMap.put(key, entityDao.unique(OqlBuilder.from(classOf[Home], "home").where("home.std = :student", student)))
      }
      else if (className == "examinee") {
        stdInfoMap.put(key, entityDao.unique(OqlBuilder.from(classOf[Examinee], "examinee").where("examinee.std = :student", student)))
      }
    }
    stdInfoMap.get(key).orNull
  }
}

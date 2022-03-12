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

package org.openurp.std.info.service

import org.beangle.commons.bean.Properties
import org.beangle.commons.collection.Collections
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.data.transfer.exporter.DefaultPropertyExtractor
import org.openurp.base.edu.model.{Student, StudentState}
import org.openurp.base.model.Person
import org.openurp.std.info.model.{Contact, Examinee, Graduation, Home}

import java.lang.reflect.Method
import java.time.LocalDate
import java.time.format.DateTimeFormatter

class StudentPropertyExtractor(entityDao: EntityDao) extends DefaultPropertyExtractor {

  private var current: Student = _

  override def getPropertyValue(target: Object, property: String): Any = {
    val student = target.asInstanceOf[Student]
    val secptions = property.split("_")
    val fieldName = secptions(0)
    val className = secptions(1)
    if (classOf[Student].getName == className) {
      if ("code_" + classOf[Student].getName == property) {
        return student.user.code
      } else if ("labels_" + classOf[Student].getName == property) {
        val labelValue = new StringBuilder
        student.labels.keySet.foreach(labelType => {
          if (labelValue.length > 0) {
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
    if (classOf[Person].getName == className) {
      if ("formatedName_" + classOf[Person].getName == property) {
        return student.user.name
      } else {
        return loadPropertyValue(student.person, fieldName)
      }
    }
    if (classOf[StudentState].getName == className && !student.state.isEmpty) {
      return loadPropertyValue(student.state.get, fieldName)
    }
    loadPropertyValue(loadStdOtherEntity(student, className), fieldName)
  }

  private def loadPropertyValue(target: Object, fieldName: String): Any = {
    //    val sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
    val sdfYMD = DateTimeFormatter.ofPattern("yyyy-MM-dd")
    if (null == target) {
     return ""
    }
    try {
      var value: Object = target match {
        case Some(a) => Properties.get(a, fieldName)
        case _ => Properties.get(target, fieldName)
      }
      if (value.isInstanceOf[Boolean]) {
        return if (value.asInstanceOf[Boolean]) "是" else "否"
      }
      if (value.isInstanceOf[String]) {
        return value.asInstanceOf[String]
      }
      if (value.isInstanceOf[LocalDate]) {
        return sdfYMD.format(value.asInstanceOf[LocalDate])
      }
      //      if (value.isInstanceOf[Instant]) {
      //        return sdf.format(value.asInstanceOf[Instant])
      //      }
      try {
        val method = value match {
          case Some(a) => findMethod(a, "name")
          case _ => findMethod(value, "name")
        }
        if (null != method) {
          value = value match {
            case Some(a) => method.invoke(a)
            case _ => method.invoke(value)
          }
        }
      } catch {
        case e: Exception =>

      }
      value
    } catch {
      case e: Exception =>
        throw new RuntimeException(e)
    }
  }

  private def findMethod(target: Any, methodNames: String*): Method = {
    var e: Exception = null
    for (methodName <- methodNames) {
      try return target.getClass.getMethod(methodName)
      catch {
        case e1: NoSuchMethodException =>
          e = e1
      }
    }
    throw new RuntimeException(e)
  }

  private def loadStdOtherEntity(student: Student, className: String): Object = {
    val stdInfoMap = Collections.newMap[String, Object]
    val key = student.id.toString + "_" + className
    if (!(stdInfoMap.keySet.contains(key))) {
      if (null == current || !(current == student)) {
        current = student
        stdInfoMap.clear()
      }
      if (className == classOf[Graduation].getName) {
        stdInfoMap.put(key, entityDao.findBy(className, "std.id", List(student.id)))
      }
      else if (className == classOf[Contact].getName) {
        stdInfoMap.put(key, entityDao.uniqueResult(OqlBuilder.from(classOf[Contact], "contact").where("contact.std = :student", student)))
      }
      else if (className == classOf[Home].getName) {
        stdInfoMap.put(key, entityDao.uniqueResult(OqlBuilder.from(classOf[Home], "home").where("home.std = :student", student)))
      }
      else if (className == classOf[Examinee].getName) {
        stdInfoMap.put(key, entityDao.uniqueResult(OqlBuilder.from(classOf[Examinee], "examinee").where("examinee.std = :student", student)))
      }
    }
    val value = stdInfoMap.get(key)
    if (null == value) {
      stdInfoMap.remove(key)
    }
    value
  }
}

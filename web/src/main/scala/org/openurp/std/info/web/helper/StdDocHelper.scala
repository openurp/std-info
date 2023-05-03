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

import org.apache.poi.xwpf.usermodel.XWPFDocument
import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.ClassLoaders
import org.beangle.data.dao.EntityDao
import org.beangle.doc.docx.DocHelper
import org.openurp.base.std.model.Graduate
import org.openurp.std.info.model.MajorStudent

import java.io.ByteArrayOutputStream
import java.net.URL
import java.time.LocalDate

object StdDocHelper {

  def toDegreeDoc(entityDao: EntityDao, graduate: Graduate): Array[Byte] = {
    val std = graduate.std
    val minors = entityDao.findBy(classOf[MajorStudent], "std", List(std))
    val data = Collections.newMap[String, String]
    data.put("name", std.name)
    data.put("x", std.gender.name)

    val person = std.person
    val birthday = person.birthday.getOrElse(LocalDate.now())
    data.put("bY", birthday.getYear.toString)
    data.put("bM", birthday.getMonthValue.toString)
    data.put("bD", birthday.getDayOfMonth.toString)

    data.put("ss", std.project.school.name)
    data.put("minor", std.state.get.major.name)

    if (minors.nonEmpty) {
      data.put("school", minors.head.school.name)
      data.put("major", minors.head.majorName)
    } else {
      data.put("school", "____")
      data.put("major", "____")
    }
    graduate.degree.foreach(degree => {
      data.put("degree", degree.name)
    })
    graduate.diplomaNo.foreach(diplomaNo => {
      data.put("diplomaNo", diplomaNo)
    })

    val chineseMap = Map("0" -> "0", "1" -> "一", "2" -> "二", "3" -> "三", "4" -> "四", "5" -> "五", "6" -> "六", "7" -> "七", "8" -> "八", "9" -> "九")
    val date = graduate.degreeAwardOn.getOrElse(LocalDate.now())
    val y = date.getYear.toString
    val m = date.getMonthValue.toString
    val d = date.getDayOfMonth.toString
    var year = new String("")
    for (c <- y) {
      year = year + chineseMap(c.toString)
    }

    val month: String = m.length match {
      case 1 => chineseMap(m)
      case 2 => "十" + chineseMap.get(m.charAt(1).toString)
    }

    val day: String = d.length match {
      case 1 => chineseMap(d)
      case _ =>
        if (d.charAt(0).toString == "1") "十" + chineseMap(d.charAt(1).toString)
        else chineseMap(d.charAt(0).toString) + "十" + chineseMap(d.charAt(1).toString)
    }

    data.put("y", year)
    data.put("M", month)
    data.put("d", day)

    val url = ClassLoaders.getResource("org/openurp/std/info/" + (if (std.project.minor) "minorDegreeDoc.docx" else "majorDegreeDoc.docx"))
    DocHelper.toDoc(url.get, data)
  }

  def toCertificationDoc(entityDao: EntityDao, graduate: Graduate): Array[Byte] = {
    val std = graduate.std
    val minors = entityDao.findBy(classOf[MajorStudent], "std", List(std))
    val data = Collections.newMap[String, String]
    data.put("name", std.name)
    data.put("x", std.gender.name)

    val person = std.person
    data.put("bY", person.birthday.get.getYear.toString)
    data.put("bM", person.birthday.get.getMonthValue.toString)

    data.put("minor", std.state.get.major.name)

    if (minors.nonEmpty) {
      data.put("ss", minors.head.school.name)
      data.put("major", minors.head.majorName)
    } else {
      data.put("ss", "____")
      data.put("major", "____")
    }
    data.put("sY", std.beginOn.getYear.toString)
    data.put("sM", std.beginOn.getMonthValue.toString)
    data.put("eY", std.endOn.getYear.toString)
    data.put("eM", std.endOn.getMonthValue.toString)

    data.put("y", LocalDate.now().getYear.toString)
    data.put("M", LocalDate.now().getMonthValue.toString)
    data.put("d", LocalDate.now().getDayOfMonth.toString)

    data.put("code", graduate.certificateNo)

    val url = this.getClass.getResource("/org/openurp/std/info/minorCertificationDoc.docx")
    DocHelper.toDoc(url, data)
  }

}

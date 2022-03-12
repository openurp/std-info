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

package org.openurp.std.info.helper

import java.io.ByteArrayOutputStream
import java.net.URL
import java.time.LocalDate

import org.apache.poi.xwpf.usermodel.XWPFDocument
import org.beangle.commons.collection.Collections
import org.beangle.data.dao.EntityDao
import org.openurp.std.info.model.{Graduation, MajorStudent}

object DocHelper {

  def toDegreeDoc(entityDao: EntityDao, graduation: Graduation): Array[Byte] = {
    val std = graduation.std
    val minors = entityDao.findBy(classOf[MajorStudent], "std", List(std))
    val data = Collections.newMap[String, String]
    data.put("name", std.user.name)
    data.put("x", std.user.gender.name)

    val person = std.person
    data.put("bY", person.birthday.getYear.toString)
    data.put("bM", person.birthday.getMonthValue.toString)
    data.put("bD", person.birthday.getDayOfMonth.toString)

    data.put("ss", std.project.school.name)
    data.put("minor", std.state.get.major.name)

    if (minors.nonEmpty) {
      data.put("school", minors.head.school.name)
      data.put("major", minors.head.majorName)
    } else {
      data.put("school", "____")
      data.put("major", "____")
    }
    graduation.degree.foreach(degree => {
      data.put("degree", degree.name)
    })
    graduation.diplomaNo.foreach(diplomaNo => {
      data.put("diplomaNo", diplomaNo)
    })

    val chineseMap = Map("0" -> "0", "1" -> "一", "2" -> "二", "3" -> "三", "4" -> "四", "5" -> "五", "6" -> "六", "7" -> "七", "8" -> "八", "9" -> "九")
    val y = LocalDate.now().getYear.toString
    val m = LocalDate.now().getMonthValue.toString
    val d = LocalDate.now().getDayOfMonth.toString
    var year = new String("")
    for (c <- y) {
      year = year + chineseMap.get(c.toString).get
    }

    val month: String = m.length match {
      case 1 => chineseMap.get(m).get
      case 2 => "十" + chineseMap.get(m.charAt(1).toString)
    }

    val day: String = d.length match {
      case 1 => chineseMap.get(d).get
      case _ =>
        if (d.charAt(0).toString == "1") "十" + chineseMap(d.charAt(1).toString)
        else chineseMap(d.charAt(0).toString) + "十" + chineseMap(d.charAt(1).toString)
    }

    data.put("y", year)
    data.put("M", month)
    data.put("d", day)

    val url = if (std.project.minor) {
      this.getClass.getResource("/org/openurp/edu/student/info/minorDegreeDoc.docx")
    }
    else {
      this.getClass.getResource("/org/openurp/edu/student/info/majorDegreeDoc.docx")
    }
    DocHelper.toDoc(url, data)
  }

  def toDiplomaDoc(entityDao: EntityDao, graduation: Graduation): Array[Byte] = {
    val std = graduation.std
    val minors = entityDao.findBy(classOf[MajorStudent], "std", List(std))
    val data = Collections.newMap[String, String]
    data.put("name", std.user.name)
    data.put("x", std.user.gender.name)

    val person = std.person
    data.put("bY", person.birthday.getYear.toString)
    data.put("bM", person.birthday.getMonthValue.toString)

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

    data.put("code", graduation.certificateNo.getOrElse("--"))

    val url = this.getClass.getResource("/org/openurp/edu/student/info/minorDiplomaDoc.docx")
    DocHelper.toDoc(url, data)
  }

  def toDoc(url: URL, data: collection.Map[String, String]): Array[Byte] = {
    val templateIs = url.openStream()
    val doc = new XWPFDocument(templateIs)
    import scala.jdk.javaapi.CollectionConverters._

    for (p <- asScala(doc.getParagraphs)) {
      val runs = p.getRuns
      if (runs != null) {
        for (r <- asScala(runs)) {
          var text = r.getText(0)
          if (text != null) {
            data foreach { case (k, v) =>
              if (text.contains("${" + k + "}")) {
                text = text.replace("${" + k + "}", v)
              }
            }
            r.setText(text, 0)
          }
        }
      }
    }

    for (tbl <- asScala(doc.getTables)) {
      for (row <- asScala(tbl.getRows)) {
        for (cell <- asScala(row.getTableCells)) {
          for (p <- asScala(cell.getParagraphs)) {
            for (r <- asScala(p.getRuns)) {
              var text = r.getText(0)
              if (text != null) {
                data.find { case (k, v) => text.contains("${" + k + "}") } foreach { e =>
                  text = text.replace("${" + e._1 + "}", e._2)
                  r.setText(text, 0)
                }
              }
            }
          }
        }
      }
    }
    val bos = new ByteArrayOutputStream()
    doc.write(bos)
    templateIs.close()
    bos.toByteArray
  }
}

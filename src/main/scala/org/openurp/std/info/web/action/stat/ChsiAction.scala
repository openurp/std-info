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

package org.openurp.std.info.web.action.stat

import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.Strings
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.doc.transfer.exporter.ExcelWriter
import org.beangle.web.servlet.util.RequestUtils
import org.beangle.webmvc.support.ActionSupport
import org.beangle.webmvc.support.action.EntityAction
import org.beangle.webmvc.view.View
import org.openurp.base.std.model.Student
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.model.Examinee

import java.time.LocalDate
import java.time.format.DateTimeFormatter

/** 学习网数据上报和统计
 * 按照开学30天仍然在籍的中国学生进行上报
 */
class ChsiAction extends ActionSupport, EntityAction[Student], ProjectSupport {

  var entityDao: EntityDao = _

  def index(): View = {
    val query = OqlBuilder.from[Array[Any]](classOf[Student].getName, "s")
    query.where("s.project=:project", getProject)
    query.where("s.registed=true")
    query.where(s"exists(from ${classOf[Examinee].getName} as e where e.std=s and e.code is not null)")
    query.where("cast(day_diff(s.beginOn,s.endOn) as integer) > 30 ") //开学后30天仍旧有学籍的
    query.groupBy("s.beginOn")
    query.select("s.beginOn,count(*)")
    val datas = entityDao.search(query).map(x => (x(0).toString, x(1))).toMap
    put("datas", datas)
    forward()
  }

  def download(): View = {
    val beginOn = getDate("beginOn").getOrElse(LocalDate.now)
    val project = getProject

    response.setContentType("application/vnd.ms-excel;charset=GBK")
    RequestUtils.setContentDisposition(response, s"${beginOn} 学籍学信网上报.xlsx")

    val writer = new ExcelWriter(response.getOutputStream)
    writer.createScheet("sheet1")
    val titles = List("KSH", "XH", "XM", "XB", "CSRQ", "ZJLX", "ZJHM", "ZZMM", "MZ", "ZYDM",
      "ZYMC", "FY", "XSH", "BH", "CC", "XXXS", "XZ", "RXRQ", "YJBYRQ").toBuffer
    writer.writeHeader(None, titles.toArray)
    val query = OqlBuilder.from(classOf[Student], "s")
    query.where("s.project=:project", project)
    query.where("s.registed=true")
    query.where(s"exists(from ${classOf[Examinee].getName} as e where e.std=s and e.code is not null)")
    query.where("cast(day_diff(s.beginOn,s.endOn) as integer) > 30 ") //开学后30天仍旧有学籍的
    query.where("s.beginOn = :beginOn", beginOn)
    val stds = entityDao.search(query)

    val formater = DateTimeFormatter.ofPattern("yyyyMMdd")
    stds foreach { std =>
      val data = Collections.newBuffer[Any]
      val examCode = entityDao.findBy(classOf[Examinee], "std", std).headOption match {
        case None => ""
        case Some(e) => e.code.getOrElse("")
      }
      data.addOne(examCode)
      data.addOne(std.code)
      data.addOne(std.name)
      data.addOne(std.gender.name)
      data.addOne(std.person.birthday.map(x => formater.format(x)).getOrElse(""))
      data.addOne(std.person.idType.name)
      data.addOne(std.person.code)
      data.addOne(std.person.politicalStatus.map(_.name).getOrElse(""))
      data.addOne(std.person.nation.map(_.name).getOrElse(""))
      val enrollState = std.states.minBy(_.beginOn)
      val enrollMajor = enrollState.major
      data.addOne(convertDisciplineCode(enrollMajor.getDisciplineCode(std.beginOn)))
      data.addOne(enrollMajor.getDisciplineName(std.beginOn))
      data.addOne("") //分院
      data.addOne(enrollState.department.name)
      data.addOne(enrollState.squad.map(_.name).getOrElse(""))
      data.addOne(convertLevelName(std.level.name))
      data.addOne(std.studyType.name)
      data.addOne(covertDuration(std.duration))
      data.addOne(formater.format(std.beginOn))
      data.addOne(formater.format(std.graduateOn))
      writer.write(data.toArray)
    }
    writer.close()

    null
  }

  /** 未上报的学生明细
   *
   * @return
   */
  def unreported(): View = {
    val beginOn = getDate("beginOn").getOrElse(LocalDate.now)
    val project = getProject
    val query = OqlBuilder.from(classOf[Student], "s")
    query.where("s.project=:project", project)
    query.where(s"s.registed=false or not exists(from ${classOf[Examinee].getName} as e where e.std=s and e.code is not null) or cast(day_diff(s.beginOn,s.endOn) as integer) <= 30")
    query.where("s.beginOn = :beginOn", beginOn)
    val stds = entityDao.search(query)
    put("stds", stds)
    put("project", project)
    put("beginOn", beginOn)
    forward()
  }

  private def covertDuration(d: Float): String = {
    if (d % 1 > 0) then d.toString else d.intValue.toString
  }

  /** 专业代码补足6位
   *
   * @param code
   * @return
   */
  private def convertDisciplineCode(code: String): String = {
    if (code.length < 6) then Strings.rightPad(code, 6, '0')
    else code
  }

  private def convertLevelName(n: String): String = {
    if (n == "硕士" || n == "博士") then n + "研究生"
    else n
  }
}

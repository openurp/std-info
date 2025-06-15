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
import org.beangle.commons.lang.Strings
import org.beangle.commons.lang.text.TemporalFormatter
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.openurp.base.hr.model.President
import org.openurp.base.std.model.{Graduate, GraduateSeason, Thesis}
import org.openurp.std.info.model.Examinee

import java.text.DateFormatSymbols
import java.util.Locale

/** 毕业信息导出
 * xxx_xw结尾的是上传学位网使用的属性
 *
 * @param entityDao
 */
class GraduatePropertyExtractor(entityDao: EntityDao, season: Option[GraduateSeason]) extends DefaultPropertyExtractor {
  private val shortDateFormater = TemporalFormatter("yyyyMMdd")
  private val englishSymbols = DateFormatSymbols.getInstance(Locale.ENGLISH)

  private var thesis: Thesis = _
  private var president: Option[President] = None
  season foreach { s =>
    val query = OqlBuilder.from(classOf[President], "p")
    query.where("p.school=:school", s.project.school)
    query.where("p.beginOn<=:date", s.graduateIn.atEndOfMonth())
    query.where("p.endOn is null or p.endOn>=:date", s.graduateIn.atEndOfMonth())
    president = entityDao.search(query).headOption
  }

  override def get(target: Object, property: String): Any = {
    val graduate = target.asInstanceOf[Graduate]
    if (property == "examinee.code") {
      entityDao.findBy(classOf[Examinee], "std", target.asInstanceOf[Graduate].std).headOption match
        case None => ""
        case Some(e) => e.code
    } else if (property.startsWith("std.person.birthday")) {
      graduate.std.person.birthday match {
        case None => ""
        case Some(birthday) =>
          val suffix = Strings.substringAfter(property, "std.person.birthday")
          suffix match {
            case "" => shortDateFormater.format(birthday)
            case "_year" => birthday.getYear
            case "_month" => Strings.leftPad(birthday.getMonthValue.toString, 2, '0')
            case "_month_en" => englishSymbols.getMonths()(birthday.getMonthValue - 1)
            case "_day" => Strings.leftPad(birthday.getDayOfMonth.toString, 2, '0')
          }
      }
    } else if (property.startsWith("degreeAwardOn")) {
      graduate.degreeAwardOn match {
        case None => ""
        case Some(date) =>
          val suffix = Strings.substringAfter(property, "degreeAwardOn")
          suffix match {
            case "" => shortDateFormater.format(date)
            case "_year" => date.getYear
            case "_month" => Strings.leftPad(date.getMonthValue.toString, 2, '0')
            case "_month_en" => englishSymbols.getMonths()(date.getMonthValue - 1)
            case "_day" => Strings.leftPad(date.getDayOfMonth.toString, 2, '0')
          }
      }
    } else if (property == "photoFile") {
      graduate.std.person.code + ".jpg"
    } else if (property == "std.gender.enName2") {
      //lowercase gender name
      val graduate = target.asInstanceOf[Graduate]
      graduate.std.gender.enName.getOrElse("").toLowerCase
    } else if (property == "degree.name_print") {
      //经济学硕士学位 --> 经济学
      graduate.degree match
        case Some(d) => if d.name.endsWith(d.level.name) then Strings.substringBefore(d.name, d.level.name) else d.name
        case None => ""
    } else if (property == "std.person.idType.code_xw") {
      //奇葩的学位网要求，非得两位
      val code = graduate.std.person.idType.code
      Strings.leftPad(code, 2, '0')
    } else if (property == "std.person.idType.name_xw") {
      val idType = graduate.std.person.idType
      if idType.id == 1 then "中华人民共和国居民身份证" else idType.name
    } else if (property == "degree.name_xw") {
      graduate.degree match
        case None => ""
        case Some(d) => if (d.name.endsWith("学位")) d.name else d.name + "学位"
    } else if (property.startsWith("thesis.")) {
      if (thesis == null || thesis.std != graduate.std) {
        thesis = entityDao.findBy(classOf[Thesis], "std", graduate.std).headOption.orNull
      }
      if (null != thesis) {
        Properties.get[Any](thesis, Strings.substringAfter(property, "thesis."))
      } else {
        ""
      }
    } else if (property == "president.name") {
      president.map(_.name).getOrElse("校长")
    } else {
      Properties.get[Any](target, property)
    }
  }
}

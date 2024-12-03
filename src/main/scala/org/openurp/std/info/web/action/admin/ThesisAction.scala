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

import org.beangle.commons.activation.MediaTypes
import org.beangle.data.dao.OqlBuilder
import org.beangle.doc.excel.schema.ExcelSchema
import org.beangle.doc.transfer.importer.ImportSetting
import org.beangle.doc.transfer.importer.listener.ForeignerListener
import org.beangle.webmvc.annotation.response
import org.beangle.webmvc.view.Stream
import org.beangle.webmvc.support.action.{ImportSupport, RestfulAction}
import org.openurp.base.edu.model.Major
import org.openurp.base.model.Project
import org.openurp.base.std.model.{Graduate, GraduateSeason, Thesis}
import org.openurp.code.edu.model.{EducationLevel, EducationResult, ThesisTopicSource, ThesisType}
import org.openurp.code.person.model.Language
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.web.helper.ThesisImportListener

import java.io.{ByteArrayInputStream, ByteArrayOutputStream}

class ThesisAction extends RestfulAction[Thesis], ProjectSupport, ImportSupport[Thesis] {
  override def indexSetting(): Unit = {
    given project: Project = getProject

    put("levels", getCodes(classOf[EducationLevel]))
    put("departments", getDeparts)
    put("majors", findInProject(classOf[Major]))
    put("seasons", findInProject(classOf[GraduateSeason]))
    super.indexSetting()
  }

  override def getQueryBuilder: OqlBuilder[Thesis] = {
    val query = super.getQueryBuilder
    getLong("season.id") foreach { seasonId =>
      query.where(s"exists(from ${classOf[Graduate].getName} g where g.std=thesis.std and g.season.id=:seasonId)", seasonId)
    }
    query
  }

  @response
  def downloadTemplate(): Any = {
    val project = getProject
    val results = codeService.get(classOf[EducationResult]).map(x => x.code + " " + x.name)
    val languages = codeService.get(classOf[Language]).map(x => x.code + " " + x.name)
    val thesisTypes = codeService.get(classOf[ThesisType]).map(x => x.code + " " + x.name)
    val sources = codeService.get(classOf[ThesisTopicSource]).map(x => x.code + " " + x.name)

    val schema = new ExcelSchema()
    val sheet = schema.createScheet("数据模板")
    sheet.title("论文信息模板")
    sheet.add("学号", "std.code").length(20).required()
    sheet.add("论文题目", "thesis.title").required()
    sheet.add("指导教师", "thesis.advisor").required()
    sheet.add("研究领域", "thesis.researchField").length(200)
    sheet.add("论文关键词", "thesis.keywords").length(400)
    sheet.add("撰写语种", "thesis.language.code").ref(languages).required()
    sheet.add("毕业论文类型", "thesis.thesisType.code").ref(thesisTypes).required()
    sheet.add("选题来源", "thesis.source.code").ref(sources).required()
    sheet.add("分数", "thesis.score").decimal()
    sheet.add("成绩等级", "thesis.scoreText")
    sheet.add("评语", "thesis.comments")
    val os = new ByteArrayOutputStream()
    schema.generate(os)
    Stream(new ByteArrayInputStream(os.toByteArray), MediaTypes.ApplicationXlsx, "毕业论文数据模板.xlsx")
  }

  protected override def configImport(setting: ImportSetting): Unit = {
    val fl = new ForeignerListener(entityDao)
    fl.addForeigerKey("name")
    setting.listeners = List(fl, new ThesisImportListener(entityDao, getProject))
  }

}

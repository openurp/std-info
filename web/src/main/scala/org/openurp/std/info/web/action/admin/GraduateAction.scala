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

import org.beangle.commons.collection.Collections
import org.beangle.commons.lang.text.TemporalFormatter
import org.beangle.data.dao.OqlBuilder
import org.beangle.data.excel.schema.ExcelSchema
import org.beangle.data.transfer.exporter.ExportContext
import org.beangle.data.transfer.importer.ImportSetting
import org.beangle.data.transfer.importer.listener.ForeignerListener
import org.beangle.web.action.annotation.response
import org.beangle.web.action.view.{Stream, View}
import org.beangle.webmvc.support.action.{ExportSupport, ImportSupport, RestfulAction}
import org.openurp.base.edu.model.{Direction, Major}
import org.openurp.base.model.Project
import org.openurp.base.std.code.StdType
import org.openurp.base.std.model.{Graduate, GraduateSeason}
import org.openurp.base.std.service.StudentService
import org.openurp.code.edu.model.{Degree, EducationLevel, EducationResult}
import org.openurp.code.std.model.StudentStatus
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.web.helper.{GraduatePropertyExtractor, StdDocHelper}
import org.openurp.std.info.web.listener.GraduateImportListener

import java.io.{ByteArrayInputStream, ByteArrayOutputStream}
import java.time.LocalDate

class GraduateAction extends RestfulAction[Graduate], ExportSupport[Graduate], ImportSupport[Graduate], ProjectSupport {

  var studentService: StudentService = _

  override def indexSetting(): Unit = {
    given project: Project = getProject

    put("levels", getCodes(classOf[EducationLevel]))
    put("stdTypes", getCodes(classOf[StdType]))
    put("departments", getDeparts)
    put("majors", findInProject(classOf[Major]))
    put("directions", findInProject(classOf[Direction]))
    put("graduateSeasons", findInProject(classOf[GraduateSeason]))
    super.indexSetting()
  }

  override def getQueryBuilder: OqlBuilder[Graduate] = {
    val query = super.getQueryBuilder
    get("degree").orNull match {
      case "0" => query.where("graduate.degree is null")
      case "1" => query.where("graduate.degree is not null")
      case _ =>
    }
    query
  }

  override def search(): View = {
    val query = getQueryBuilder
    put("graduates", entityDao.search(query))
    put("project", getProject)
    forward()
  }

  def certificate(): View = {
    val ids = getLongIds("graduate")
    val graduates = entityDao.find(classOf[Graduate], ids)
    put("graduates", graduates)
    forward()
  }

  def degreeDownload(): View = {
    val id = getLongId("graduate")
    val graduate = entityDao.get(classOf[Graduate], id)
    val bytes = StdDocHelper.toDegreeDoc(entityDao, graduate)
    val filename = new String(("学位证书-" + graduate.std.name).getBytes, "ISO8859-1")
    response.setHeader("Content-disposition", "attachment; filename=" + filename + ".docx")
    response.setHeader("Content-Length", bytes.length.toString)
    val out = response.getOutputStream
    out.write(bytes)
    out.flush()
    out.close()
    null
  }

  def certificationDownload(): View = {
    val id = getLongId("graduate")
    val graduate = entityDao.get(classOf[Graduate], id)
    val bytes = StdDocHelper.toCertificationDoc(entityDao, graduate)
    val filename = if (graduate.std.project.minor) {
      new String(("专业证书-" + graduate.std.name).getBytes, "ISO8859-1")
    } else {
      new String(("毕业证书-" + graduate.std.name).getBytes, "ISO8859-1")
    }
    response.setHeader("Content-disposition", "attachment; filename=" + filename + ".docx")
    response.setHeader("Content-Length", bytes.length.toString)
    val out = response.getOutputStream
    out.write(bytes)
    out.flush()
    out.close()
    null
  }

  /**
   * 根据毕业状态批量更改学籍状态
   *
   * @return
   */
  def batchUpdateStdState(): View = {
    val gradeId = getLongId("graduate.season")
    val graduates = entityDao.findBy(classOf[Graduate], "season.id", gradeId)
    val statuses = entityDao.getAll(classOf[StudentStatus])
    val results = entityDao.getAll(classOf[EducationResult])
    val resultStatus = Collections.newMap[EducationResult, StudentStatus]
    results foreach { r =>
      statuses.find(_.name == r.name) foreach (s => resultStatus.put(r, s))
    }
    var missingCount = 0
    graduates foreach { g =>
      resultStatus.get(g.result) match {
        case None => missingCount += 1
        case Some(s) => studentService.graduate(g.std, g.graduateOn, s)
      }
    }
    if missingCount > 0 then
      redirect("search", s"成功批量更改${graduates.size - missingCount}，尚有${missingCount}个学生无法找到对应的学籍状态")
    else redirect("search", s"成功更改${graduates.size}条学籍状态")
  }

  @response
  def downloadTemplate(): Any = {
    val project = getProject
    val results = codeService.get(classOf[EducationResult]).map(x => x.code + " " + x.name)
    val degrees = codeService.get(classOf[Degree]).map(x => x.code + " " + x.name)
    val seasons = entityDao.findBy(classOf[GraduateSeason], "project", project).map(_.code).sorted

    val schema = new ExcelSchema()
    val sheet = schema.createScheet("数据模板")
    sheet.title("毕业信息模板")
    sheet.remark("特别说明：\n1、不可改变本表格的行列结构以及批注，否则将会导入失败！\n2、必须按照规格说明的格式填写。\n3、可以多次导入，重复的信息会被新数据更新覆盖。\n4、保存的excel文件名称可以自定。")
    sheet.add("学号", "std.code").length(15).required().remark("≤15位")
    sheet.add("毕业界别", "graduate.season.code").ref(seasons).required()
    sheet.add("毕结业结论", "graduate.result.code").ref(results).required()
    sheet.add("毕业日期", "graduate.graduateOn").date().required()
    sheet.add("学历证书编号（电子注册号）", "graduate.certificateNo").length(30)
    sheet.add("毕结业证书序列号", "graduate.certificateSeqNo").length(30)
    sheet.add("学位", "graduate.degree.code").ref(degrees)
    sheet.add("学位授予日期", "graduate.degreeAwardOn").date()
    sheet.add("学位证书号", "graduate.diplomaNo").length(30)
    sheet.add("毕业批次", "graduate.batchNo").integer().required()
    sheet.add("外语通过年月", "graduate.foreignLangPassedOn").date()
    val os = new ByteArrayOutputStream()
    schema.generate(os)
    Stream(new ByteArrayInputStream(os.toByteArray), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "毕业信息模板.xlsx")
  }

  protected override def configImport(setting: ImportSetting): Unit = {
    val fl = new ForeignerListener(entityDao)
    fl.addForeigerKey("name")
    setting.listeners = List(fl, new GraduateImportListener(entityDao, getProject))
  }

  override protected def configExport(context: ExportContext): Unit = {
    if (context.fileName.startsWith("上传学位网")) {
      context.registerFormatter(classOf[LocalDate], TemporalFormatter("yyyyMMdd"))
      context.attrs.indices foreach { i =>
        if (context.titles(i).contains("年月")) {
          context.registerFormatter(context.attrs(i), TemporalFormatter("yyyyMM"))
        }
      }
    }
    context.extractor = new GraduatePropertyExtractor(entityDao)
    super.configExport(context)
  }
}

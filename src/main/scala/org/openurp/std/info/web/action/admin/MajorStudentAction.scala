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
import org.beangle.webmvc.view.{Stream, View}
import org.beangle.webmvc.support.action.{ExportSupport, ImportSupport, RestfulAction}
import org.openurp.base.model.Project
import org.openurp.base.std.model.Student
import org.openurp.code.edu.model.{DisciplineCategory, Institution}
import org.openurp.starter.web.support.ProjectSupport
import org.openurp.std.info.model.MajorStudent
import org.openurp.std.info.web.listener.MajorStudentImportListener

import java.io.{ByteArrayInputStream, ByteArrayOutputStream}

/**
 * 辅修学生的主修信息维护
 */
class MajorStudentAction extends RestfulAction[MajorStudent], ExportSupport[MajorStudent], ImportSupport[MajorStudent], ProjectSupport {

  override def indexSetting(): Unit = {
    val builder = OqlBuilder.from(classOf[MajorStudent].getName, "m")
    builder.select("distinct m.school")
    val schools = entityDao.search(builder)
    put("schools", schools)
    super.indexSetting()
  }

  override protected def getQueryBuilder: OqlBuilder[MajorStudent] = {
    val query = super.getQueryBuilder
    query.where("majorStudent.std.project=:project", getProject)
    query
  }

  override def editSetting(entity: MajorStudent): Unit = {
    given project: Project = getProject

    put("schools", entityDao.getAll(classOf[Institution]))
    put("majorCategories", getCodes(classOf[DisciplineCategory]))
    super.editSetting(entity)
  }

  /**
   * 下载模板
   */
  @response
  def downloadTemplate(): Any = {
    val schools = entityDao.search(OqlBuilder.from(classOf[Institution], "ms").orderBy("ms.name")).map(_.name)
    val majorCategories = entityDao.search(OqlBuilder.from(classOf[DisciplineCategory], "dc").orderBy("dc.name")).map(_.name)

    val schema = new ExcelSchema()
    val sheet = schema.createScheet("数据模板")
    sheet.title("辅修学生信息模板")
    sheet.remark("特别说明：\n1、不可改变本表格的行列结构以及批注，否则将会导入失败！\n2、必须按照规格说明的格式填写。\n3、可以多次导入，重复的信息会被新数据更新覆盖。\n4、保存的excel文件名称可以自定。")
    sheet.add("学号", "majorStudent.std.code").length(100).required()
    sheet.add("主修学号", "majorStudent.code").length(100).required()
    sheet.add("主修学校", "majorStudent.school.name").ref(schools).required()
    sheet.add("主修专业", "majorStudent.majorName").length(300).required()
    sheet.add("主修专业英文名", "majorStudent.enMajorName").length(300)
    sheet.add("主修专业学科门类", "majorStudent.majorCategory.name").ref(majorCategories).required()

    val code = schema.createScheet("数据字典")
    code.add("学校").data(schools)
    code.add("专业学科门类").data(majorCategories)
    val os = new ByteArrayOutputStream()
    schema.generate(os)
    Stream(new ByteArrayInputStream(os.toByteArray), MediaTypes.ApplicationXlsx, "主修学生信息模板.xlsx")
  }

  protected override def configImport(setting: ImportSetting): Unit = {
    val fl = new ForeignerListener(entityDao)
    fl.addForeigerKey("name")
    setting.listeners = List(fl, new MajorStudentImportListener(entityDao))
  }

  override protected def saveAndRedirect(entity: MajorStudent): View = {
    if (!entity.persisted) {
      val stds = entityDao.findBy(classOf[Student], "code", get("userCode"))
      if (stds.isEmpty) return redirect("editNew", "学号不存在")
      val std = stds.head
      val mss = entityDao.findBy(classOf[MajorStudent], "std", stds)
      if (mss.nonEmpty) return redirect("editNew", "主修信息已经存在")
      entity.std = std
    }
    super.saveAndRedirect(entity)
  }

}

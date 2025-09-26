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

import org.beangle.commons.collection.Collections
import org.beangle.commons.json.{Json, JsonObject}
import org.beangle.commons.lang.Strings
import org.beangle.doc.docx.DocTemplate
import org.beangle.ems.app.EmsApp
import org.beangle.ems.app.oa.Flows
import org.openurp.std.alter.model.{StdAlterApply, StdAlterApplyStep}

import java.io.{ByteArrayInputStream, InputStream}
import java.net.URL
import java.time.ZoneId
import java.time.format.DateTimeFormatter

object StdAlterationDocGenerator {

  def generate(apply: StdAlterApply): InputStream = {
    val formatter = DateTimeFormatter.ofPattern("YYYY 年 MM 月 dd 日")
    val path = s"${apply.std.project.school.id}/${apply.std.project.id}/org/openurp/std/info/template/${apply.alterType.id}.docx";
    val bytes = EmsApp.getResource(path) match
      case None => Array.empty[Byte]
      case Some(url) =>
        val data = Collections.newMap[String, Any]
        val std = apply.std
        data.put("std", std)
        data.put("apply", apply)
        if (Strings.isBlank(apply.alterDataJson)) {
          data.put("alter", new JsonObject())
        } else {
          data.put("alter", Json.parse(apply.alterDataJson))
        }

        val signatures = Collections.newMap[String, String]
        apply.processId foreach { processId =>
          val process = Flows.getProcess(processId)
          if (Strings.isNotBlank(process.id)) {
            process.tasks foreach { task =>
              val sp = task.data.getString("signaturePath", "")
              if (Strings.isNotBlank(sp)) {
                signatures.put(task.name, Flows.readSignature(sp))
              }
              val psp = task.data.getString("parentSignaturePath", "")
              if (Strings.isNotBlank(psp)) {
                signatures.put(task.name + "2", Flows.readSignature(psp))
              }
            }
          }
        }

        apply.steps foreach { step =>
          val prefix = getPrefix(step)
          data.put(prefix + "_comments", step.comments.getOrElse("--"))
          data.put(prefix + "_auditAt", step.auditAt.map { x => formatter.format(x.atZone(ZoneId.systemDefault).toLocalDate) }.getOrElse("    年    月    日"))
          signatures.get(step.name) foreach { s => data.put(prefix + "_esign", s) }
          signatures.get(step.name + "2") foreach { s => data.put(prefix + "_esign2", s) }
        }
        DocTemplate.process(url, data)

    new ByteArrayInputStream(bytes)
  }

  private def getPrefix(step: StdAlterApplyStep): String = {
    if (step.idx == 0) {
      "申请人"
    } else {
      var name = step.name
      name = Strings.replace(name, "批准", "")
      name = Strings.replace(name, "审核", "")
      name
    }
  }
}

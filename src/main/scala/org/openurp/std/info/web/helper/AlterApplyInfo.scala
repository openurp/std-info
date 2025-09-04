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
import org.beangle.commons.lang.Strings
import org.beangle.ems.app.EmsApp
import org.beangle.ems.app.oa.Flows
import org.openurp.base.model.User
import org.openurp.std.alter.model.{StdAlterApply, StdAlterApplyStep}

import java.time.{Instant, LocalDate, ZoneId}
import scala.collection.mutable

object AlterApplyInfo {
  private val businessCode = "std_alter_apply"

  def build(applies: Iterable[StdAlterApply]): Iterable[AlterApplyInfo] = {
    if (applies.isEmpty) return List.empty
    val flows = Flows.getFlows(businessCode, applies.head.std.project.id).map(x => (x.code, x)).toMap
    val infos = Collections.newBuffer[AlterApplyInfo]
    val blob = EmsApp.getBlobRepository(true)
    applies foreach { apply =>
      val info = new AlterApplyInfo(apply)
      infos.addOne(info)
      apply.processId foreach { processId =>
        val process = Flows.getProcess(processId)
        info.flow = flows.get(process.flowCode)
        if (Strings.isNotBlank(process.id)) {
          info.process = Some(process)
          process.tasks foreach { task =>
            task.attachments foreach { f =>
              blob.url(f.filePath) foreach { url => info.files.put(f.filePath, url.toString) }
            }
            val sp = task.data.getString("signaturePath", "")
            if (Strings.isNotBlank(sp)) {
              info.addSign(task, task.assignee.map(_.code).getOrElse(""), blob.url(sp).get.toString)
            }
            val psp = task.data.getString("parentSignaturePath", "")
            if (Strings.isNotBlank(psp)) {
              info.addSign(task, "parent", blob.url(psp).get.toString)
            }
          }
        }
      }
    }
    infos
  }
}

class AlterApplyInfo(val alterApply: StdAlterApply) {
  val files = Collections.newMap[String, String] //filePath->url
  val signs = Collections.newMap[Flows.Task, mutable.Map[String, String]] //task -> signer name -> sign url

  var flow: Option[Flows.Flow] = None
  var process: Option[Flows.Process] = None

  def getTask(name: String): Option[Flows.Task] = {
    process.get.tasks.find(_.name == name)
  }

  def addSign(task: Flows.Task, signer: String, sign: String): Unit = {
    val taskSigns = signs.getOrElseUpdate(task, Collections.newMap[String, String])
    taskSigns.put(signer, sign)
  }

  def getSigns(taskName: String): Iterable[String] = {
    println((taskName, signs.find(_._1.name == taskName).map(_._2.values).size))
    signs.find(_._1.name == taskName).map(_._2.values).getOrElse(List.empty)
  }

  def getSign(taskName: String, signer: User): Option[String] = {
    signs.find(_._1.name == taskName).flatMap(_._2.get(signer.code))
  }

  def groupSteps(): Map[String, Iterable[StdAlterApplyStep]] = {
    val today = LocalDate.now()
    val now = Instant.now()
    val grouped = alterApply.steps.groupBy(_.auditAt.getOrElse(now).atZone(ZoneId.systemDefault()).toLocalDate)
    val result = grouped.map { x =>
      (x._1.toString, x._2.sortBy(_.auditAt.getOrElse(now)).reverse)
    }
    result
  }
}

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

package org.openurp.base.edu.service

import org.beangle.data.dao.OqlBuilder
import org.openurp.base.edu.model.{Student, StudentState}
import org.openurp.base.model.Person
import org.openurp.code.std.model.StudentStatus
import org.openurp.edu.grade.BaseServiceImpl
import org.openurp.std.info.model.Graduation

import java.time.LocalDate
import scala.util.control.Breaks.{break, breakable}

class StudentService extends BaseServiceImpl {
  //  def this

  def getStudent(studentId: Long): Student = {
    entityDao.get(classOf[Student], studentId)
  }

  def getStudent(projectId: Integer, code: String): Student = {
    val list = entityDao.search(OqlBuilder.from(classOf[Student], "s").where("s.project.id=:projectId and s.user.code = :code", projectId, code))
    if (list.isEmpty) {
      null
    }
    else {
      list(0)
    }
  }

  def getJournal(student: Student): StudentState = {
    getJournal(student, LocalDate.now())
  }

  def getJournal(student: Student, date: LocalDate): StudentState = {
    var builder: OqlBuilder[StudentState] = OqlBuilder.from(classOf[StudentState], "stdJournal").where("stdJournal.std = :std and stdJournal.beginOn<=:now and (stdJournal.endOn is null or stdJournal.endOn>=:now)", student, date).orderBy("stdJournal.id desc")
    var rs = entityDao.search(builder)
    if (rs.isEmpty) {
      builder = OqlBuilder.from(classOf[StudentState], "stdJournal").where("stdJournal.std = :std and stdJournal.beginOn > :now", student, LocalDate.now()).orderBy("stdJournal.id")
      rs = entityDao.search(builder)
    }
    if (rs.isEmpty) {
      null
    }
    else {
      rs(0)
    }
  }

  def endJournal(std: Student, endOn: LocalDate, graduated: StudentStatus): Unit = {
    val inschool = entityDao.get(classOf[StudentStatus], 1)
    var graduateState: StudentState = null
    val var6 = std.states.iterator
    while (var6.hasNext) {
      val ss = var6.next
      breakable {
        if (ss.status == graduated && !(ss.beginOn == std.beginOn) || ss.beginOn == endOn) {
          graduateState = ss
          break //todo: break is not supported
        }
      }
    }
    if (null == graduateState) {
      val state = std.state.get
      val previousDay = endOn.plusDays(-(1L))
      state.endOn = Option(previousDay)
      if (state.status == graduated) {
        state.status = inschool
        state.inschool = true
      }
      entityDao.saveOrUpdate(state)
      val newState = new StudentState
      newState.std = state.std
      newState.grade = state.grade
      newState.department = state.department
      newState.campus = state.campus
      newState.major = state.major
      newState.direction = state.direction
      newState.squad = state.squad
      graduateState = newState
    }
    graduateState.inschool = false
    graduateState.status = graduated
    graduateState.beginOn = endOn
    graduateState.endOn = Option(graduateState.beginOn)
    std.state = Option(graduateState)
    std.endOn = endOn
    entityDao.saveOrUpdate(graduateState, std)
  }

  def isInschool(student: Student): Boolean = {
    isInschool(student, LocalDate.now())
  }

  def isInschool(student: Student, date: LocalDate): Boolean = {
    val journal: StudentState = getJournal(student, date)
    if (journal == null) {
      false
    }
    else {
      journal.inschool
    }
  }

  def isActive(student: Student): Boolean = {
    isActive(student, LocalDate.now())
  }

  def isActive(student: Student, date: LocalDate): Boolean = {
    student.registed && student.beginOn.isBefore(date) && student.endOn.isAfter(date)
  }

  def getStdStatus(student: Student): StudentStatus = {
    getStdStatus(student, LocalDate.now())
  }

  def getStdStatus(student: Student, date: LocalDate): StudentStatus = {
    val journal: StudentState = getJournal(student, date)
    if (journal != null) {
      journal.status
    }
    else {
      null
    }
  }

  def getStudentByCode(code: String): Student = {
    val list = entityDao.findBy(classOf[Student], "code", Array[AnyRef](code))
    if (list.isEmpty) {
      null
    }
    else {
      list(0)
    }
  }

  def getMajorProjectStudent(stdPerson: Person): Student = {
    val query: OqlBuilder[Student] = OqlBuilder.from(classOf[Student], "std")
    query.where("std.person = :stdPerson", stdPerson).where("std.project.minor = false")
    entityDao.uniqueResult(query)
  }

  def getMinorProjectStudent(stdPerson: Person): Student = {
    val query: OqlBuilder[Student] = OqlBuilder.from(classOf[Student], "std")
    query.where("std.person = :stdPerson", stdPerson).where("std.project.minor = true")
    entityDao.uniqueResult(query)
  }

  def getGraduation(std: Student): Graduation = {
    val graduations = entityDao.findBy(classOf[Graduation], "std", Array[AnyRef](std))
    if (graduations.isEmpty) {
      null
    }
    else {
      graduations(0)
    }
  }

}

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

package org.openurp.std.info.service

import org.beangle.commons.bean.Properties
import org.beangle.commons.collection.Collections
import org.beangle.data.dao.OqlBuilder
import org.openurp.base.model.Person
import org.openurp.base.service.AbstractBaseService
import org.openurp.base.std.model.{Graduate, Squad, Student, StudentState}
import org.openurp.base.std.service.StudentService
import org.openurp.std.info.model.{Contact, Home}

import java.time.LocalDate
import java.util
import scala.collection.mutable

object StudentManager {
  private val propertyMap = new util.HashMap[String, String]

  propertyMap.put("code", "学号")
  propertyMap.put("name", "姓名")
  propertyMap.put("phoneticName", "英文名")
  propertyMap.put("gender", "性别")
  propertyMap.put("grade", "年级")
  propertyMap.put("department", "院系")
  propertyMap.put("major", "专业")
  propertyMap.put("direction", "方向")
  propertyMap.put("majorDepart", "院系")
  propertyMap.put("stdType", "学生类别")
  propertyMap.put("duration", "学制")
  propertyMap.put("status", "学籍状态")
  propertyMap.put("inschool", "是否在校")
  propertyMap.put("registed", "是否有学籍")
  propertyMap.put("status", "学籍状态")
  propertyMap.put("beginOn", "学籍生效日期")
  propertyMap.put("campus", "校区")
  propertyMap.put("endOn", "学籍失效日期")
  propertyMap.put("squad", "班级")
  propertyMap.put("studyType", "学习形式")
  propertyMap.put("levelType", "教育形式")
  propertyMap.put("remark", "备注")
  propertyMap.put("formerName", "曾用名")
  propertyMap.put("nation", "民族")
  propertyMap.put("politicVisage", "政治面貌")
  propertyMap.put("birthday", "出生日期")
  propertyMap.put("idcard", "身份证")
  propertyMap.put("idType", "证件类型")
  propertyMap.put("ancestralAddr", "籍贯")
  propertyMap.put("country", "国家地区")
  propertyMap.put("maritalStatus", "婚姻状况")
  propertyMap.put("joinOn", "入团(党)时间")
  propertyMap.put("charactor", "特长爱好")

}

class StudentManager extends AbstractBaseService {

  var studentService: StudentService = _
  var studentInfoService: StudentInfoService = _
  //
  //  def saveStudent(parameterObject: SaveLogForStudentParameter): Unit = {
  //    checkAndSaveLogForStudent(parameterObject, null, null)
  //  }
  //
  //  def saveStudent(parameterObject: SaveLogForStudentParameter, journalOrig: StudentState, journalNew: StudentState): Unit = {
  //    checkAndSaveLogForStudent(parameterObject, journalOrig, journalNew)
  //  }

  // 删除未生效学籍信息并记录
  //  def checkAndRemoveLogForStudentAlteration(stdAlterations: Iterable[StdAlteration], ip: String, user: User): Unit = {
  //    //    val time = new Timestamp(System.currentTimeMillis)
  //    val saveDatas = Collections.newBuffer[Entity[_]]
  //    stdAlterations.foreach(stdAlteration => {
  //      val log = new StudentLog
  //      log.`type` = StudentLog.STD_ALL_LOG
  //      log.operation = "已删除预定于" + stdAlteration.beginOn + "对学号为" + stdAlteration.std.code + "的未生效学籍异动[" + stdAlteration.alterType.name + "]"
  //      log.user = user
  //      log.time = LocalDate.now()
  //      log.student = stdAlteration.std
  //      log.ip = ip
  //      val log2 = new StudentLog
  //      log2.`type` = StudentLog.STD_PERSONAL_LOG
  //      log2.operation = "已删除预定于" + stdAlteration.beginOn + "对学号为" + stdAlteration.std.code + "的未生效学籍异动[" + stdAlteration.alterType.name + "]"
  //      log2.user = user
  //      log2.time = LocalDate.now()
  //      log2.student = stdAlteration.std
  //      log2.ip = ip
  //      saveDatas.+=(log)
  //      saveDatas.+=(log2)
  //    })
  //    entityDao.execute(Operation.saveOrUpdate(saveDatas).remove(stdAlterations))
  //  }

  //  def checkAndRollbackLogForStudent(parameterObject: SaveLogForStudentParameter): Unit = {
  //    checkAndRollbackLogForStudent(parameterObject, null, null)
  //  }

  // 对学籍信息删除产生回滚日志
  //  def checkAndRollbackLogForStudent(parameterObject: SaveLogForStudentParameter, journalOrig: StudentState, journalNew: StudentState): collection.mutable.Buffer[StudentLog] = {
  //    val before = parameterObject.before
  //    val now = parameterObject.now
  //    val ip = parameterObject.ip
  //    val loginUser = parameterObject.loginUser
  //    val changedDatas = doCheckDifference(before, now)
  //    if (journalOrig != null && journalNew != null) {
  //      changedDatas.addAll(doCheckForJournal(journalOrig, journalNew))
  //    }
  //    val saveDatas = Collections.newBuffer[StudentLog]
  //    if (changedDatas.size < 1) {
  //      saveDatas.+=(addGeneralLog(new StudentLogParameter(StudentLog.STD_ALL_LOG, "已对学号为" + now.user.code + "学生的学籍异动进行一次回滚,学籍信息不发生变化", ip, now, loginUser)))
  //      saveDatas.+=(addGeneralLog(new StudentLogParameter(StudentLog.STD_PERSONAL_LOG, "已对学号为" + now.user.code + "学生的学籍异动进行一次回滚,学籍信息不发生变化", ip, now, loginUser)))
  //    }
  //    else {
  //      saveDatas.+=(addGeneralLog(new StudentLogParameter(StudentLog.STD_PERSONAL_LOG, genRollbackChangedString(changedDatas), ip, now, loginUser)))
  //      saveDatas.+=(addGeneralLog(new StudentLogParameter(StudentLog.STD_ALL_LOG, "已对学号为<a target='_blank' title='查看详情' href='studentLog!stdLogList.action?student.id=" + now.id + "'>" + now.user.code + "</a>学生的学籍信息进行一次回滚", ip, now, loginUser)))
  //    }
  //    saveDatas
  //  }

  private def genRollbackChangedString(datas: Iterable[ChangedPropertyData]): String = {
    val buffer = new StringBuffer
    datas.foreach(data => {
      buffer.append("字段[" + convertProName(data.property) + "]已回滚,回滚前:" + data.oldValue + ",回滚后：" + data.value + "。<br/>")
    })
    buffer.toString
  }

  // 比较两个学生未生效学籍信息差别并记录
  //  @throws[Exception]
  //  def checkAndSaveLogForStudentAlteration(parameterObject: SaveLogForStudentParameter): Unit = {
  //    val before = parameterObject.before
  //    val now = parameterObject.now
  //    val ip = parameterObject.ip
  //    val loginUser = parameterObject.loginUser
  //    val date = parameterObject.date
  //    if (null == before) {
  //      entityDao.saveOrUpdate(addGeneralLog(new StudentLogParameter(0, "将在" + date + "新增一条学号为" + now.user.code + "的学籍信息", ip, now, loginUser)))
  //      return
  //    }
  //    val changedDatas = doCheckDifference(before, now)
  //    if (changedDatas.size < 1) {
  //      entityDao.saveOrUpdate(addGeneralLog(new StudentLogParameter(0, "将在" + date + "对学号" + now.user.code + "做学籍变动,学籍信息不发生变化", ip, before, loginUser)))
  //      entityDao.saveOrUpdate(addGeneralLog(new StudentLogParameter(1, "将在" + date + "对学号" + now.user.code + "做学籍变动,学籍信息不发生变化", ip, before, loginUser)))
  //      return
  //    }
  //    val saveDatas = Collections.newBuffer[Entity[_]]
  //    saveDatas.+=(addGeneralLog(new StudentLogParameter(1, genWillChangeString(changedDatas, date), ip, before, loginUser)))
  //    saveDatas.+=(addGeneralLog(new StudentLogParameter(0, "将在" + date + "修改一条学号为<a target='_blank' title='查看详情' href='studentLog!stdLogList.action?student.id=" + before.id + "'>" + before.user.code + "</a>的学籍信息", ip, before, loginUser)))
  //    PropertyUtils.copyProperties(now, before)
  //    entityDao.saveOrUpdate(saveDatas)
  //  }

  def genWillChangeString(datas: Iterable[ChangedPropertyData], date: LocalDate): String = {
    val buffer = new StringBuffer
    datas.foreach(data => {
      buffer.append("字段[" + convertProName(data.property) + "]将在" + date + "被修改,修改前:" + data.oldValue + ",修改后：" + data.value + "。<br/>")
    })
    buffer.toString
  }

  //  def doCheckForJournal(journalOrig: StudentState, journalNew: StudentState): collection.mutable.Buffer[ChangedPropertyData] = {
  //    val changedPropertyDatas = Collections.newBuffer[ChangedPropertyData]
  //    if (!(journalOrig.status == journalNew.status)) {
  //      changedPropertyDatas.+=(new ChangedPropertyData("status", journalOrig.status.name, journalNew.status.name))
  //    }
  //    if (journalOrig.inschool != journalNew.inschool) {
  //      changedPropertyDatas.+=(new ChangedPropertyData("inschool", if (journalOrig.inschool) "是" else "否", if (journalNew.inschool) "是" else "否"))
  //    }
  //    changedPropertyDatas
  //  }

  // 比较两个学生学籍信息差别并记录
  //  private def checkAndSaveLogForStudent(parameterObject: SaveLogForStudentParameter, journalOrig: StudentState, journalNew: StudentState): Unit = {
  //    val before = parameterObject.before
  //    val now = parameterObject.now
  //    val ip = parameterObject.ip
  //    val loginUser = parameterObject.loginUser
  //    if (null == before) {
  //      entityDao.saveOrUpdate(addGeneralLog(new StudentLogParameter(0, "新增了一条学号为" + now.user.code + "的学籍信息", ip, now, loginUser)))
  //      return
  //    }
  //    val saveDatas = Collections.newBuffer[Entity[_]]
  //    val changedDatas = doCheckDifference(before, now)
  //    if (journalOrig != null && journalNew != null) {
  //      changedDatas.addAll(doCheckForJournal(journalOrig, journalNew))
  //      saveDatas.+=(journalOrig)
  //      saveDatas.+=(journalNew)
  //    }
  //    if (changedDatas.size < 1) {
  //      val log: StudentLog = addGeneralLog(new StudentLogParameter(0, "对学号" + now.user.code + "的学生进行了一次学籍变动,学籍信息不发生变化", ip, now, loginUser))
  //      entityDao.saveOrUpdate(log)
  //      return
  //    }
  //    saveDatas.+=(parameterObject.now)
  //    saveDatas.+=(addGeneralLog(new StudentLogParameter(1, genChangedString(changedDatas), ip, now, loginUser)))
  //    saveDatas.+=(addGeneralLog(new StudentLogParameter(0, "修改了一条学号为<a target='_blank' title='查看详情' href='studentLog!stdLogList.action?student.id=" + now.id + "'>" + now.user.code + "</a>的学籍信息", ip, now, loginUser)))
  //    entityDao.saveOrUpdate(saveDatas)
  //  }

  // 比较两个学生基本信息差别并记录
  //  def checkAndSaveLogForBasic(std: Student, before: Person, now: Person, ip: String, loginUser: User): Unit = {
  //    if (null == before) {
  //      addGeneralLog(new StudentLogParameter(0, "新增了学号为" + std.code + "的基本信息", ip, std, loginUser))
  //      return
  //    }
  //    val changedDatas = doCheckDifference(before, now)
  //    if (changedDatas.size < 1) {
  //      return
  //    }
  //    val saveDatas = Collections.newBuffer[Entity[_]]
  //    saveDatas.+=(addGeneralLog(new StudentLogParameter(1, genChangedString(changedDatas), ip, std, loginUser)))
  //    saveDatas.+=(addGeneralLog(new StudentLogParameter(0, "修改了一条学号为<a target='_blank' title='查看详情' href='studentLog!stdLogList.action?student.id=" + std.id + "'>" + std.code + "</a>的基本信息", ip, std, loginUser)))
  //    entityDao.saveOrUpdate(saveDatas)
  //  }

  /**
   * 对两个object 进行比较
   */
  //  def doCheckDifference(before: Object, now: Object): collection.mutable.Buffer[ChangedPropertyData] = {
  //    val changedDatas = Collections.newBuffer[ChangedPropertyData]
  //    val propertyDescriptors = PropertyUtils.getPropertyDescriptors(before.getClass)
  //    for (i <- 0 until propertyDescriptors.length) {
  //      val descriptor = propertyDescriptors(i)
  //      val declaringClass = descriptor.getPropertyType
  //      //      if(declaringClass == classOf[Long]) {
  //      //        continue //todo: continue is not supported
  //      //
  //      //      }
  //      if (declaringClass != classOf[Long]) {
  //        var beforeName = ""
  //        var afterName = ""
  //        if (isSimpleClass(declaringClass)) {
  //          if (classOf[LocalDate].isAssignableFrom(declaringClass)) {
  //            try {
  //              val beforeDate = PropertyUtils.getProperty(before, descriptor.getName).asInstanceOf[LocalDate]
  //              val afterDate = PropertyUtils.getProperty(now, descriptor.getName).asInstanceOf[LocalDate]
  //              val sdf = new SimpleDateFormat("yyyy-MM-dd")
  //              beforeName = sdf.format(beforeDate)
  //              afterName = sdf.format(afterDate)
  //            } catch {
  //              case e: Exception =>
  //
  //            }
  //          }
  //          else {
  //            beforeName = getProperty(before, descriptor.getName)
  //            afterName = getProperty(now, descriptor.getName)
  //          }
  //        }
  //        else { // get name and compare
  //          beforeName = getProperty(before, descriptor.getName + ".name")
  //          val nowObj = getPropertyObj(now, descriptor)
  //          initialize(nowObj)
  //          afterName = getProperty(nowObj, "name")
  //        }
  //        if (!(beforeName == afterName)) {
  //          val data: ChangedPropertyData = new ChangedPropertyData(descriptor.getName, beforeName, afterName)
  //          changedDatas.+=:(data)
  //        }
  //      }
  //
  //    }
  //    changedDatas
  //  }

  def genChangedString(datas: Iterable[ChangedPropertyData]): String = {
    val buffer = new StringBuffer
    datas.foreach(data => {
      buffer.append("字段[" + convertProName(data.property) + "]已修改,修改前:" + data.oldValue + ",修改后：" + data.value + "。<br/>")
    })
    buffer.toString
  }

  //  def genChangedString(alteration: StdAlteration): String = {
  //    val buffer = new StringBuffer
  //    alteration.items.foreach(item => {
  //      buffer.append("字段[" + item.meta.comments + "]已修改,修改前:" + item.oldtext + ",修改后：" + item.newtext + "。<br/>")
  //    })
  //    buffer.toString
  //  }

  //  def initialize(nowObj: Object): Unit = {
  //    if (nowObj == null) {
  //      return
  //    }
  //    Hibernate.initialize(nowObj)
  //    try if (PropertyUtils.getProperty(nowObj, "id") != null && PropertyUtils.getProperty(nowObj, "name") == null) {
  //      val obj: Any = entityDao.get(nowObj.getClass.asInstanceOf[Class[Entity[Serializable]]], PropertyUtils.getProperty(nowObj, "id").asInstanceOf[Serializable])
  //      PropertyUtils.copyProperties(nowObj, obj)
  //    }
  //    catch {
  //      case e: Exception =>
  //
  //    }
  //  }

  def getProperty(obj: Object, property: String): String = {
    try Properties.get[Any](obj, property).toString
    catch {
      case e: Exception => ""
    }
  }

  def isSimpleClass(declaringClass: Class[_]): Boolean = {
    declaringClass == classOf[String] || declaringClass.isPrimitive || declaringClass == classOf[Float] || declaringClass == classOf[Boolean] || classOf[LocalDate].isAssignableFrom(declaringClass)
  }

  /**
   * 添加学籍日志
   *
   * @param parameterObject
   * TODO
   */
  //  def addGeneralLog(parameterObject: StudentLogParameter): StudentLog = {
  //    val time: Timestamp = new Timestamp(System.currentTimeMillis)
  //    val log: StudentLog = new StudentLog
  //    log.`type` = parameterObject.`type`
  //    log.operation = parameterObject.operation
  //    log.user = parameterObject.loginUser
  //    log.time = LocalDate.now()
  //    log.student = parameterObject.s
  //    log.ip = parameterObject.ip
  //    log
  //  }

  def convertProName(properties: String): String = {
    val it = StudentManager.propertyMap.entrySet.iterator
    while (it.hasNext) {
      val entry = it.next
      val key = entry.getKey
      if (properties == key) {
        entry.getValue
      }
    }
    properties
  }

  /**
   * 获取所有班级
   */
  def getAdminClass: Seq[Squad] = {
    val builder = OqlBuilder.from(classOf[Squad], "squad").where("squad.beginOn <= :now and (squad.endOn is null or squad.endOn >= :now)", LocalDate.now()).orderBy("squad.id")
    val rs = entityDao.search(builder)
    if (rs.nonEmpty) {
      rs
    } else {
      null
    }
  }

  @deprecated def saveStudentsInfo(student: Student, basic: Person, contact: Contact): Unit = {
    entityDao.saveOrUpdate(student)
    entityDao.saveOrUpdate(basic)
    entityDao.saveOrUpdate(contact)
  }

  @throws[Exception]
  def saveStudentsInfo(student: Student, stdBasic: Person, contact: Contact, home: Home, journal: StudentState): Unit = {
    val entities = Collections.newBuffer[AnyRef]
    if (stdBasic != null) {
      entities.+=(stdBasic)
    }
    if (student != null) {
      entities.+=(student)
    }
    if (contact != null) {
      entities.+=(contact)
    }
    if (home != null) {
      entities.+=(home)
      entityDao.saveOrUpdate(home)
    }
    if (journal != null) {
      entities.+=(journal)
    }
    entityDao.saveOrUpdate(entities)
  }

  def getStudentDatasById(stdId: Long): mutable.Map[String, Any] = {
    val params = Collections.newMap[String, Any]
    val date = LocalDate.now()
    if (0L != stdId) {
      val student = entityDao.get(classOf[Student], stdId)
      params.put("student", student)
      val active = student.registed && date.isAfter(student.beginOn) && date.isBefore(student.endOn)
      params.put("active", active)
      params.put("inSchool", student.state.get.inschool)
      params.put("person", student.person)
      val contacts = studentInfoService.getStudentInfo(classOf[Contact], student)
      if (!contacts.isEmpty) {
        params.put("contact", contacts(0))
      }
      val graduates = studentInfoService.getStudentInfo(classOf[Graduate], student)
      if (!graduates.isEmpty) {
        params.put("graduate", graduates(0))
      }
      params.put("stdStatus", student.state.get.status)
      val homes = studentInfoService.getStudentInfo(classOf[Home], student)
      if (!homes.isEmpty) {
        params.put("home", homes(0))
      }
      val journalQuery = OqlBuilder.from(classOf[StudentState], "journal")
      journalQuery.where("journal.std = :std", student).orderBy("journal.beginOn desc").orderBy("journal.endOn desc")
      val journals = entityDao.search(journalQuery)
      params.put("journals", journals)
    }
    params
  }

  //  def stateDateCheck(student: Student, state: StudentState): Boolean = {
  //    stateDateCheck(student, state.id, state.beginOn, state.endOn)
  //  }

  //  def stateDateCheck(student: Student, stateId: Long, beginOn: LocalDate, endOn: LocalDate): Boolean = {
  //    var isOk = true
  //    val sdf = new SimpleDateFormat("yyyyMMdd")
  //    val beginValue = sdf.format(beginOn).toInt
  //    var isContinuity = false
  //    student.states.foreach(state => {
  //      if (null != stateId && null != state.id && stateId.longValue == state.id.longValue) {
  //        continue //todo: continue is not supported
  //
  //      }
  //      if (null == endOn && null == state.getEndOn) {
  //        isOk = false
  //        break //todo: break is not supported
  //
  //      }
  //      if (null == endOn && null != state.getEndOn) {
  //        val hisEndValue: Int = sdf.format(state.getEndOn).toInt
  //        if (beginValue < hisEndValue) {
  //          isOk = false
  //          break //todo: break is not supported
  //
  //        }
  //        else {
  //          if (beginValue == sdf.format(DateUtils.addDays(state.getEndOn, 1)).toInt) {
  //            isContinuity = true
  //          }
  //          continue //todo: continue is not supported
  //
  //        }
  //      }
  //      val endValue: Int = sdf.format(endOn).toInt
  //      val hisBeginValue: Int = sdf.format(state.getBeginOn).toInt
  //      if (null != endOn && null == state.getEndOn) {
  //        if (endValue > hisBeginValue) {
  //          isOk = false
  //          break //todo: break is not supported
  //
  //        }
  //        else {
  //          if (sdf.format(DateUtils.addDays(state.getBeginOn, -(1))).toInt == endValue) {
  //            isContinuity = true
  //          }
  //          continue //todo: continue is not supported
  //
  //        }
  //      }
  //      if (beginValue < sdf.format(state.getEndOn).toInt && endValue > sdf.format(state.getBeginOn).toInt) {
  //        isOk = false
  //        break //todo: break is not supported
  //
  //      }
  //      else {
  //        if (sdf.format(DateUtils.addDays(state.getBeginOn, -(1))).toInt == endValue || beginValue == sdf.format(DateUtils.addDays(state.getEndOn, 1)).toInt) {
  //          isContinuity = true
  //        }
  //      }
  //
  //    })
  //    if (!isContinuity) {
  //      isOk = false
  //    }
  //    isOk
  //  }
  //
  //  def findJournal(student: Student, state: StudentState): StudentState = {
  //    if (null == state || null == state.beginOn || null == state.endOn) {
  //      return null
  //    }
  //    findJournal(student, state.beginOn, state.endOn)
  //  }
  //
  //  def findJournal(student: Student, beginOn: LocalDate, endOn: LocalDate): StudentState = {
  //    if (null == student || null == beginOn || null == endOn || student.states.isEmpty) {
  //      return null
  //    }
  //    val sdf = new SimpleDateFormat("yyyyMMdd")
  //    val beginValue = sdf.format(beginOn).toInt
  //    val endValue = sdf.format(endOn).toInt
  //    val targetStates = Collections.newBuffer[StudentState]
  //    targetStates.addAll(student.states)
  //    //    Collections.sort(targetStates, new Comparator[StudentState]() {
  //    //      def compare(j1: StudentState, j2: StudentState): Int = {
  //    //        return j1.getBeginOn.compareTo(j2.getBeginOn)
  //    //      }
  //    //    })
  //    for (targetState <- student.states) {
  //      //      if (0 == endValue && null == targetState.endOn) {
  //      //        continue //todo: continue is not supported
  //      //
  //      //      }
  //      if (0 != endValue || null != targetState.endOn) {
  //        val targetBeginValue: Int = sdf.format(targetState.beginOn).toInt
  //        val targetEndValue: Int = sdf.format(targetState.endOn).toInt
  //        if (beginValue >= targetBeginValue && beginValue <= targetEndValue && targetBeginValue <= endValue && endValue <= targetEndValue) {
  //          return targetState
  //        }
  //      }
  //    }
  //    null
  //  }
}

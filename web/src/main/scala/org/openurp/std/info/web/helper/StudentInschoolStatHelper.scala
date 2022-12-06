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
import org.beangle.data.dao.EntityDao
import org.openurp.base.model.Project

/**
 * “在籍男女生人数统计”专用辅助类
 *
 */

class StudentInschoolStatHelper(entityDao: EntityDao, project: Project) {
//
//  private var departMap: Map[Integer, Node] = Collections.newMap[Integer, Node]
//  private var gradeMap: Map[String, Node] = null
//  private var genderMap: Map[Integer, Gender] = null
//  private var genderIndexMap: Map[String, Integer] = null
//  private var departHeadNodes: Array[Node] = null
//  private var gradeHeadNodes: Array[Node] = null
//
//  def report: Array[Node] = {
//    val query: OqlBuilder[_] = OqlBuilder.from(classOf[Student], "student")
//    query.where("student.project = :project", project)
//    query.where("student.state.department in (:departments)", project.getDepartments)
//    //    if (CollectUtils.isNotEmpty(project.getStdTypes())) {
//    //      query.where("student.stdType in (:stdTypes)", project.getStdTypes());
//    //    }
//    //    if (CollectUtils.isNotEmpty(project.getLevels())) {
//    //      query.where("student.level in (:levels)", project.getLevels());
//    query.where("student.state.beginOn<= :now and student.state.endOn>=:now and student.registed=true", new Date)
//    query.groupBy("student.state.grade, student.state.department.id, student.person.gender.id")
//    query.select("student.state.grade, student.state.department.id, student.person.gender.id, count(*)")
//    val searchResults: List[Array[AnyRef]] = entityDao.search(query).asInstanceOf[List[Array[AnyRef]]]
//    // 思路：
//    // 1. 横向，院系；纵向，年级；交点，每个性别的人数
//    // 2. 先横次纵后交点
//    for (i <- 0 until searchResults.size) {
//      val dataItems: Array[AnyRef] = searchResults.get(i).asInstanceOf[Array[AnyRef]]
//      val grade: String = dataItems(0).asInstanceOf[String]
//      val departId: Integer = dataItems(1).asInstanceOf[Integer]
//      val genderId: Integer = dataItems(2).asInstanceOf[Integer]
//      // 首先建立“院系”行
//      if (!(departMap.containsKey(departId))) {
//        val departNode: Node = new Node(entityDao.get(classOf[Department], departId))
//        // 对刚新建立“院系”，进行初始化前面已经出现的“年级”列
//        if (null != departHeadNodes) {
//          initDepartRow(departHeadNodes(departHeadNodes.length - 1).next, departNode)
//        }
//        departHeadNodes = ArrayUtils.add(departHeadNodes, departNode)
//        departMap.put(departId, departNode)
//      }
//      val departNode: Node = departMap.get(departId)
//      // 若有新的“年级”出现，则按顺序插入
//      insertGradeNodeWhenNew(grade)
//      // 缓存并提出性别
//      val gender: Gender = initGender(genderId)
//      // 找到对应的性别节点，并赋上值
//      val dataNode: Node = NodeHelper.findInNext(departNode, grade)
//      val genderIndexKey: String = departId + "_" + genderId
//      if (!(genderIndexMap.containsKey(genderIndexKey))) {
//        var foundIndex: Int = 0
//        if (dataNode.nodeArraySize > 0) {
//          while ( {
//            foundIndex < dataNode.nodeArraySize
//          }) {
//            var hisGender: Gender = dataNode.nodeArrayIndexOf(foundIndex).`val`.asInstanceOf[Gender]
//            if (gender.getCode.compareTo(hisGender.getCode) < 0) {
//              for (k <- foundIndex until dataNode.nodeArraySize) {
//                hisGender = dataNode.nodeArrayIndexOf(k).`val`.asInstanceOf[Gender]
//                genderIndexMap.put(departId + "_" + hisGender.getId, k + 1)
//              }
//              break //todo: break is not supported
//
//            }
//
//            foundIndex += 1
//          }
//        }
//        genderIndexMap.put(genderIndexKey, foundIndex)
//        insertGenderNodeToArray(departNode.next, foundIndex, gender)
//      }
//      dataNode.nodeArrayIndexOf(genderIndexMap.get(genderIndexKey)).next(new Node(dataItems(3))) // 赋值
//
//    }
//    return departHeadNodes
//  }
//
//  /**
//   * 按顺序插入有新的“年级”出现
//   *
//   * @param grade
//   * @return
//   */
//  private def insertGradeNodeWhenNew(grade: String): Unit = { // 新增年级列的处理
//    if (!(gradeMap.containsKey(grade))) {
//      val gradeHeadNode: Node = new Node(grade)
//      val gradeNode: Node = new Node(grade)
//      // 向前或向后插入一列年级
//      val n: Int = if (null == gradeHeadNodes) {
//        0
//      }
//      else {
//        gradeHeadNodes.length
//      }
//      if (0 == n) {
//        gradeHeadNodes = ArrayUtils.add(gradeHeadNodes, 0, gradeHeadNode)
//        departHeadNodes(0).next(gradeNode)
//        gradeHeadNodes(0).down(gradeNode)
//      }
//      else {
//        var i: Int = 0
//        val targetGradeValue: Int = loadGradeValue(grade)
//
//        while ( {
//          i < n
//        }) {
//          val gradeValue: Int = loadGradeValue(gradeHeadNodes(i).`val`.toString)
//          if (targetGradeValue < gradeValue) {
//            break //todo: break is not supported
//
//          }
//
//          i += 1
//        }
//        gradeHeadNodes = ArrayUtils.add(gradeHeadNodes, i, gradeHeadNode)
//        if (i < n) {
//          NodeHelper.insertBeforeNodeInColumn(gradeHeadNodes(i + 1).down, gradeHeadNode)
//        }
//        else {
//          NodeHelper.insertAfterNodeInColumn(gradeHeadNodes(i - 1).down, gradeHeadNode)
//        }
//        syncGenderNodeByGradeHeader(gradeHeadNode.down)
//      }
//      // 缓存年级
//      gradeMap.put(grade, gradeHeadNode)
//    }
//  }
//
//  private def loadGradeValue(grade: String): Int = {
//    val gradeSections: Array[String] = StringUtils.split(grade, "-")
//    gradeSections.length match {
//      case 1 =>
//        return StringUtils.leftPad(gradeSections(0), 4, "0").toInt * 100
//      case _ =>
//        return StringUtils.leftPad(gradeSections(0), 4, "0") + StringUtils.leftPad(gradeSections(1), 2, "0").toInt
//    }
//  }
//
//  private def syncGenderNodeByGradeHeader(gradeNode: Node): Unit = {
//    if (null == gradeNode) {
//      return
//    }
//    var fromNode: Node = gradeNode.next
//    if (null == fromNode) {
//      fromNode = gradeNode.prev
//    }
//    if (null == fromNode || null == fromNode.nodeArray) {
//      return
//    }
//    for (genderNode <- fromNode.nodeArray) {
//      gradeNode.addNode(new Node(genderNode.`val`))
//    }
//    syncGenderNodeByGradeHeader(gradeNode.down)
//  }
//
//  /**
//   * 缓存已出现的性别
//   *
//   * @param genderId
//   * @return
//   */
//  private def initGender(genderId: Integer): Gender = {
//    if (!(genderMap.containsKey(genderId))) {
//      genderMap.put(genderId, entityDao.get(classOf[Gender], genderId))
//    }
//    return genderMap.get(genderId)
//  }
//
//  /**
//   * 初始化“院系”行
//   *
//   * @param fromNode
//   * @param toNode
//   */
//  private def initDepartRow(fromNode: Node, toNode: Node): Unit = {
//    if (null == fromNode) {
//      return
//    }
//    toNode.next(new Node(fromNode.`val`))
//    toNode.next.up(fromNode)
//    initDepartRow(fromNode.next, toNode.next)
//  }
//
//  /**
//   * 按顺序插入性别节点
//   *
//   * @param departChildNode
//   * @param index
//   * @param gender
//   */
//  private def insertGenderNodeToArray(departChildNode: Node, index: Int, gender: Gender): Unit = {
//    if (null == departChildNode) {
//      return
//    }
//    departChildNode.nodeArray(ArrayUtils.add(departChildNode.nodeArray, index, new Node(gender)))
//    insertGenderNodeToArray(departChildNode.next, index, gender)
//  }
}

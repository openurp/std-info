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

package org.openurp.commons

import org.beangle.commons.collection.Collections

/**
 * 节点
 *
 */
class Node {
//
//  private var data: Object = _
//
//  private var width: Integer = _
//
//  private var deep: Integer = _
//
//  private var nodeArray = Collections.newBuffer[Node]
//
//  private var prev: Node = _
//
//  private var next: Node = _
//
//  private var down: Node = _
//
//  private var up: Node = _
//
//
//  def this(data: Object) {
//    this
//    this.data = data
//  }
//
//
//  def nodeArraySize: Int = if (null == nodeArray) 0 else nodeArray.length
//
//  def nodeArrayIndexOf(index: Int): Node = try nodeArray(index)
//  catch {
//    case e: Exception =>
//      null
//  }
//
//
//  def addNode(anyNode: Node*): Node = {
//    if (null != anyNode) nodeArray = nodeArray.addAll(anyNode)
//    this
//  }
//
//  def prev: Node = prev
//
//  def prev(node: Node): Unit = {
//    prev = node
//    if (null == node.next) node.next(this)
//    updateWidth(node)
//  }
//
//  def next: Node = next
//
//  def next(node: Node): Unit = {
//    next = node
//    if (null == node.prev) node.prev(this)
//    updateWidth(node)
//  }
//
//  private def updateWidth(node: Node): Unit = {
//    updateWidth(node, true)
//    updateWidth(node.prev, false)
//  }
//
//  private def updateWidth(node: Node, isNext: Boolean): Unit = {
//    if (null == node) return
//    if (isNext) if (null == next) node.width = 0
//    else {
//      updateWidth(node.next, isNext)
//      node.width = node.next.width + 1
//    }
//    else if (null == node.next) node.width = 0
//    else {
//      node.width = node.next.width + 1
//      updateWidth(node.next, isNext)
//    }
//  }
//
//  def up: Node = up
//
//  def up(node: Node): Unit = {
//    up = node
//    if (null == node.down) node.down(this)
//    updateDeep(node)
//  }
//
//  def down: Node = down
//
//  def down(node: Node): Unit = {
//    down = node
//    if (null == node.up) node.up(this)
//    updateDeep(node)
//  }
//
//  private def updateDeep(node: Node): Unit = {
//    updateDeep(node, true)
//    updateDeep(node.up, false)
//  }
//
//  private def updateDeep(node: Node, isDown: Boolean): Unit = {
//    if (null == node) return
//    if (isDown) if (null == node.down) node.deep = 0
//    else {
//      updateDeep(node.down, isDown)
//      node.deep = node.down.deep + 1
//    }
//    else {
//      if (null == node.down) node.deep = 0
//      else node.deep = node.down.deep + 1
//      updateDeep(node.up, isDown)
//    }
//  }
}

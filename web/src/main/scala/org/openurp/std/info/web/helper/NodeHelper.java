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

package org.openurp.std.info.web.helper;

import java.util.Objects;
/**
 * @author zhouqi 2016年11月3日
 */
public class NodeHelper {

  public static Node findInNext(Node targetNode, Object data) {
    return find(targetNode, data, 1);
  }

  public static Node findInPrev(Node targetNode, Object data) {
    return find(targetNode, data, 2);
  }

  public static Node findInDown(Node targetNode, Object data) {
    return find(targetNode, data, 3);
  }

  public static Node findInUp(Node targetNode, Object data) {
    return find(targetNode, data, 4);
  }

  public static Node findInRow(Node targetNode, Object data) {
    return find(targetNode, data, 5);
  }

  public static Node findInColumn(Node targetNode, Object data) {
    return find(targetNode, data, 6);
  }

  /**
   * @param targetNode
   * @param data
   * @param direction
   *          next-1, prev-2, down-3, up-4, row-5, column-6
   * @return
   */
  private static Node find(Node targetNode, Object data, int direction) {
    if (null == targetNode) {
      return null;
    }

    switch (direction) {
    case 1:{
      return Objects.equals(targetNode.val(), data) ? targetNode : find(targetNode.next(), data, direction);
    }
    case 2:{
      return Objects.equals(targetNode.val(), data) ? targetNode : find(targetNode.prev(), data, direction);
    }
    case 3:{
      return Objects.equals(targetNode.val(), data) ? targetNode : find(targetNode.down(), data, direction);
    }
    case 4:{
      return Objects.equals(targetNode.val(), data) ? targetNode : find(targetNode.up(), data, direction);
    }
    case 5:{
      Node foundNode = find(targetNode.next(), data, 1);
      if (null == foundNode) {
        foundNode = find(targetNode.prev(), data, 2);
      }
      return foundNode;
    }
    case 6: {
      Node foundNode = find(targetNode.next(), data, 3);
      if (null == foundNode) {
        foundNode = find(targetNode.prev(), data, 4);
      }
      return foundNode;
    }
    default:
      return null;
    }
  }

  public static Node findInCurrentNodeArray(Node targetNode, Object value) {
    if (null == targetNode || null == value) {
      return null;
    }

    for (Node node : targetNode.nodeArray()) {
      if (Objects.equals(node.val(), value)) {
        return node;
      }
    }

    return null;
  }

  public static int findInCurrentNodeArrayAt(Node targetNode, Object value) {
    if (null == targetNode || null == value) {
      return -1;
    }

    for (int i = 0; i < targetNode.nodeArray().length; i++) {
      if (Objects.equals(targetNode.nodeArrayIndexOf(i).val(), value)) {
        return i;
      }
    }

    return -1;
  }

  public static void insertBeforeNodeInColumn(Node oldNode, Node newHeadNode) {
    if (null == oldNode || null == newHeadNode) {
      return;
    }

    Node cloneNode = new Node(newHeadNode.val());
    Node prevNode = oldNode.prev();
    oldNode.prev(cloneNode);
    if (null != prevNode) {
      cloneNode.prev(prevNode);
      prevNode.next(cloneNode);
    }
    newHeadNode.down(cloneNode);

    insertBeforeNodeInColumn(oldNode.down(), cloneNode);
  }

  public static void insertAfterNodeInColumn(Node oldNode, Node newHeadNode) {
    if (null == oldNode || null == newHeadNode) {
      return;
    }

    Node cloneNode = new Node(newHeadNode.val());
    Node nextNode = oldNode.next();
    oldNode.next(cloneNode);
    if (null != nextNode) {
      cloneNode.next(nextNode);
      nextNode.prev(cloneNode);
    }
    newHeadNode.down(cloneNode);

    insertAfterNodeInColumn(oldNode.down(), cloneNode);
  }
}

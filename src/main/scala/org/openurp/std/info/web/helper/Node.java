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

/**
 *
 */
package org.openurp.std.info.web.helper;

/**
 * 节点
 *
 * @author zhouqi 2016年11月2日
 */
public class Node {

  private Object data;

  private int width;

  private int deep;

  private Node[] nodeArray;

  private Node prev;

  private Node next;

  private Node down;

  private Node up;

  public Node() {
    super();
  }

  public Node(Object data) {
    this();
    this.data = data;
  }

  public int width() {
    return width;
  }

  public void width(int width) {
    this.width = width;
  }

  public int deep() {
    return deep;
  }

  public void deep(int deep) {
    this.deep = deep;
  }

  public Object val() {
    return data;
  }

  public void val(Object value) {
    this.data = value;
  }

  public Node[] nodeArray() {
    return nodeArray;
  }

  public int nodeArraySize() {
    return null == nodeArray ? 0 : nodeArray.length;
  }

  public Node nodeArrayIndexOf(int index) {
    try {
      return nodeArray[index];
    } catch (Exception e) {
      return null;
    }
  }

  public void nodeArray(Node... anyNode) {
    nodeArray = anyNode;
  }

  public Node addNode(Node... anyNode) {
    if (null != anyNode) {
      nodeArray = null;//ArrayUtils.addAll(nodeArray, anyNode);
    }
    return this;
  }

  public Node prev() {
    return prev;
  }

  public void prev(Node node) {
    prev = node;
    if (null == node.next) {
      node.next(this);
    }
    updateWidth(node);
  }

  public Node next() {
    return next;
  }

  public void next(Node node) {
    next = node;
    if (null == node.prev) {
      node.prev(this);
    }
    updateWidth(node);
  }

  private void updateWidth(Node node) {
    updateWidth(node, true);
    updateWidth(node.prev, false);
  }

  private void updateWidth(Node node, boolean isNext) {
    if (null == node) {
      return;
    }

    if (isNext) {
      if (null == node.next) {
        node.width = 0;
      } else {
        updateWidth(node.next, isNext);
        node.width = node.next.width + 1;
      }
    } else {
      if (null == node.next) {
        node.width = 0;
      } else {
        node.width = node.next.width + 1;
        updateWidth(node.next, isNext);
      }
    }
  }

  public Node up() {
    return up;
  }

  public void up(Node node) {
    up = node;
    if (null == node.down) {
      node.down(this);
    }
    updateDeep(node);
  }

  public Node down() {
    return down;
  }

  public void down(Node node) {
    down = node;
    if (null == node.up) {
      node.up(this);
    }
    updateDeep(node);
  }

  private void updateDeep(Node node) {
    updateDeep(node, true);
    updateDeep(node.up, false);
  }

  private void updateDeep(Node node, boolean isDown) {
    if (null == node) {
      return;
    }

    if (isDown) {
      if (null == node.down) {
        node.deep = 0;
      } else {
        updateDeep(node.down, isDown);
        node.deep = node.down.deep + 1;
      }
    } else {
      if (null == node.down) {
        node.deep = 0;
      } else {
        node.deep = node.down.deep + 1;
      }
      updateDeep(node.up, isDown);
    }
  }
}

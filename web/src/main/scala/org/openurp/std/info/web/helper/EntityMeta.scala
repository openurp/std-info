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

import org.beangle.data.model.IntId

import scala.collection.mutable

/**
 * 实体元信息 记录实体信息的元信息描述。
 */
case class EntityMeta(name: String, comments: String, attrs: mutable.Buffer[PropertyMeta]) {
  def add(name: String, comments: String): this.type = {
    attrs.addOne(PropertyMeta(name, comments))
    this
  }

  def add(tuples2: (String, String)*): this.type = {
    tuples2 foreach { tuple =>
      attrs.addOne(PropertyMeta(tuple._1, tuple._2))
    }
    this
  }
}

/*
属性元数据实现
 */
case class PropertyMeta(name: String, comments: String) {

}

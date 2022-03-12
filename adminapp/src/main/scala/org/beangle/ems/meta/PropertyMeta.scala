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

package org.beangle.ems.meta

import org.beangle.data.model.IntId

/*
属性元数据实现
 */
class PropertyMeta extends IntId {
  /** 所属元数据 */
  var meta: EntityMeta = _
  /** 属性名称 */
  var name: String = _
  /** 类型 */
  var `type`: String = _
  /** 属性说明 */
  var comments: Option[String] = _
  /** 备注 */
  var remark: Option[String] = _
}

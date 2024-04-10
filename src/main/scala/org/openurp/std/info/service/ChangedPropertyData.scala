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

import org.beangle.data.model.NumId

import java.text.SimpleDateFormat
import java.time.LocalDate

class ChangedPropertyData {

  var property: String = _
  var oldValue: String = _
  var value: String = _

//  def this(property: String, oldValue: Object, value: Object) {
//    this()
//    this.property = property
//    this.oldValue = load(oldValue)
//    this.value = load(value)
//  }

//  private def load(value: Object): String = {
//    if (null == value) {
//      return null
//    }
//    var v = value
//    if (v.isInstanceOf[NumId]) {
//      v = (v.asInstanceOf[NumId]).id
//    }
//    else if (null != v && v.isInstanceOf[LocalDate]) {
//      v = new SimpleDateFormat("yyyy-MM-dd").format(v)
//    }
//    if (null == v) {
//      null
//    }
//    else {
//      String.valueOf(v)
//    }
//  }

}

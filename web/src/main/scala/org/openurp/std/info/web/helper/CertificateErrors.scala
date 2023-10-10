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

object CertificateErrors {

  val No = "no"
  val NotInSchool = "not-in-school"
  val Outdated = "outdated"

  def translate(cause: String): String = {
    cause match {
      case Outdated => "你现在不在就读时间内，还不能打印在读证明."
      case No => "没有我校学籍，本学籍在读证明不适用。"
      case NotInSchool => "不在校期间，不能打印在读证明。"
    }
  }
}

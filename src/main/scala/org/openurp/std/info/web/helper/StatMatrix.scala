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
import org.beangle.commons.lang.Strings
import org.beangle.data.dao.{EntityDao, OqlBuilder}
import org.beangle.data.model.Entity

object StatMatrix {

  case class Row(keys: Seq[Any], counters: Array[Double])

  case class Dimension(name: String, clazz: Class[_], values: Iterable[Any])

  def statDimensions(entityDao: EntityDao, datas: collection.Seq[StatMatrix.Row],
                     types: Seq[(String, Class[_])]): Seq[StatMatrix.Dimension] = {
    val dimensions = Collections.newBuffer[StatMatrix.Dimension]
    var idx = 0
    types foreach { t =>
      val keys = datas.map(_.keys(idx)).toSet
      val values =
        if (classOf[Entity[_]].isAssignableFrom(t._2)) {
          val q = OqlBuilder.from[Entity[_]](t._2.getName, "t").where("t.id in (:ids)", keys)
          val objects = entityDao.search(q)
          objects.map(x => (x.id, x)).toMap
        } else {
          keys
        }
      dimensions.addOne(new StatMatrix.Dimension(t._1, t._2, values))
      idx += 1
    }
    dimensions.toSeq
  }

}

class StatMatrix(val dimensions: Seq[StatMatrix.Dimension], val datas: collection.Seq[StatMatrix.Row]) {

  def getDimension(name: String): StatMatrix.Dimension = {
    dimensions.find(_.name == name).head
  }

  def groupBy(dimensionNames: String): StatMatrix = {
    val names = Strings.split(dimensionNames)
    val newDimensions = Collections.newBuffer[StatMatrix.Dimension]
    names foreach { n => newDimensions.addAll(dimensions.find(x => x.name == n)) }
    groupBy(newDimensions.toSeq)
  }

  def groupBy(newDimensions: Seq[StatMatrix.Dimension]): StatMatrix = {
    val indices = newDimensions.map(x => dimensions.indexOf(x))
    val newRows = Collections.newBuffer[StatMatrix.Row]
    datas.groupBy(d => indices.map(x => d.keys(x))) foreach { d =>
      val counters = d._2.map(_.counters)
      val rs = new Array[Double](datas.head.counters.length)
      for (i <- counters.indices; j <- counters(i).indices) {
        rs(j) += counters(i)(j)
      }
      newRows.addOne(StatMatrix.Row(d._1, rs))
    }
    new StatMatrix(newDimensions, newRows)
  }

  def getCounter(keys: AnyRef*): Option[Any] = {
    datas.find(x => x.keys == keys).map(_.counters)
  }

  def sum: Array[Double] = {
    val rs = new Array[Double](datas.head.counters.length)
    for (i <- datas.indices; j <- datas(i).counters.indices) {
      rs(j) += datas(i).counters(j)
    }
    rs
  }
}

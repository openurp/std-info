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

package org.openurp.base.service

import org.beangle.commons.lang.Strings
import org.beangle.data.dao.EntityDao
import org.beangle.security.codec.DefaultPasswordEncoder
import org.openurp.base.code.model.UserCategory
import org.openurp.base.edu.model.Teacher
import org.openurp.base.model.User
import org.openurp.base.std.model.Student
import org.springframework.jdbc.core.JdbcTemplate

import java.time.LocalDate
import javax.sql.DataSource

class UrpUserService {

  var entityDao: EntityDao = _

  var securityDataSource: DataSource = _

  def createTeacherUser(teacher: Teacher): Unit = {
    val category = new UserCategory
    //    category.id=UserCategory.Teacher
    category.id = 1
    val password = "1"
    val template = new JdbcTemplate(securityDataSource)
    val orgId = template.queryForObject("select id from cfg.orgs", classOf[Integer])
    val domainId = template.queryForObject("select id from cfg.domains", classOf[Integer])
    val teacherRoleId = template.queryForObject("select id from usr.roles where domain_id=? and name=?", classOf[Long], domainId, "教师")
    createAccount(orgId, domainId, teacher.user.code, teacher.user.name, password, category.id, teacherRoleId)
  }

  private def createAccount(orgId: Integer, domainId: Integer, code: String, name: String, password: String, categoryId: Integer, roleId: Long): Unit = {
    val template = new JdbcTemplate(securityDataSource)
    val userIds = template.queryForList("select id from usr.users where org_id=" + orgId + " and code=? ", classOf[Long], code)
    val userId = if (userIds.isEmpty) {
      template.queryForObject("select datetime_id()", classOf[Long])
    } else {
      userIds.get(0)
    }
    if (userIds.isEmpty) {
      template.update("insert into usr.users (id,code,name,org_id,category_id,updated_at,begin_on)" + "values(?,?,?,?,?,now(),current_date);", template.queryForObject("select datetime_id()", classOf[Long]), code, name, orgId, categoryId) //"{MD5}" + EncryptUtil.encode(password),
    }
    val accountCount = template.queryForObject("select count(*) from usr.accounts where user_id=? and domain_id=? ", classOf[Integer], userId, domainId)
    if (accountCount == 0) {
      val accountId = template.queryForObject("select datetime_id()", classOf[Long])
      template.update("insert into usr.accounts (id,user_id,domain_id,password,passwd_expired_on,locked,enabled,begin_on,updated_at)" + "values(?,?,?,?,current_date+180,false,true,current_date,now());", accountId, userId, domainId, "{MD5}" + DefaultPasswordEncoder.verify("{MD5}", password))
    }
    val roleCount = template.queryForObject("select count(*) from usr.role_members where user_id=? and role_id=? ", classOf[Integer], userId, roleId)
    if (roleCount == 0) {
      template.update("insert into usr.role_members(id,user_id,role_id,is_member,is_granter,is_manager,updated_at)" + "values(datetime_id(),?,?,true,false,false,current_date);", userId, roleId)
    }
  }

  def createStudentUser(std: Student): Unit = {
    val category: UserCategory = new UserCategory
    //    category.setId(UserCategory.Student)
    category.id = 2
    val idcard = std.person.code
    var password = "1"
    if (!idcard.isBlank) {
      if (idcard.length > 6) {
        password = Strings.substring(idcard, idcard.length - 6, idcard.length)
      } else {
        password = idcard
      }
    }
    val template = new JdbcTemplate(securityDataSource)
    val orgId = template.queryForObject("select id from cfg.orgs", classOf[Integer])
    val domainId = template.queryForObject("select id from cfg.domains", classOf[Integer])
    val stdRoleId = template.queryForObject("select id from usr.roles where domain_id=? and name=?", classOf[Long], domainId, "学生")
    createAccount(orgId, domainId, std.user.code, std.user.name, password, category.id, stdRoleId)
  }

  def activate(users: Iterable[User], active: Boolean): Unit = {
    users.foreach(user => {
      if (active) {
        user.endOn = null
      }
      else {
        user.endOn = Option(LocalDate.now())
      }
    })
    entityDao.saveOrUpdate(users)
    val template = new JdbcTemplate(securityDataSource)
    val orgId = template.queryForObject("select id from cfg.orgs", classOf[Integer])
    val domainId = template.queryForObject("select id from cfg.domains", classOf[Integer])
    users.foreach(user => {
      template.update("update usr.users u set end_on=?  where u.org_id= ? and  u.code=?", user.endOn, if (null == user.endOn) true else false, orgId, user.code)
      template.update("update usr.accounts a set end_on=? where a.domain_id= ? and exists(select * from  usr.users u where u.id=a.user_id and  u.code=?)", user.endOn, if (null == user.endOn) true else false, domainId, user.code)
    })
  }

  def updatePassword(savedUser: User, encoded: String): Unit = {
    new JdbcTemplate(securityDataSource).update("update usr.users u set password=? where u.code=?", "{MD5}" + encoded, savedUser.code)
  }

}

[#ftl/]
[@b.head/]
[@b.toolbar title="班级信息"][/@]
<table class="formTable" width="60%" align="center">
  <tr><td align="center" colspan="4" class="index_view"><b>班级基本信息</b></td></tr>
  <tr>
    <td class="title" width="20%">班级名称:</td>
    <td class="brightStyle" width="30%">${(normalclass.name)!}</td>
    <td class="title" width="20%">教学项目:</td>
    <td class="brightStyle" width="30%">${(normalclass.project.name)!}</td>
  </tr>
  <tr>
    <td class="title" width="20%">培养层次:</td>
    <td width="30%">${(normalclass.level.name)!}</td>
    <td class="title" width="20%">生效日期:</td>
    <td width="30%">${(normalclass.beginOn)!}</td>
  </tr>
  <tr>
    <td class="title" width="20%">失效日期:</td>
    <td width="30%">${(normalclass.endOn)!}</td>
  </tr>
</table>
<div style="width:60%;margin-left:auto;margin-right:auto;background-color:#E1ECFF;text-align:center">
  <b>班级学生列表</b>
</div>
[#--]
<div style="width:60%;margin-left:auto;margin-right:auto">
  [@b.grid items=students var="student" sortable="true"]
         [@b.row]
      [@b.col property="name" title="姓名" width="15%"]
             ${(student.user.name)!}
           [/@]
      [@b.col property="code" title="学号" width="20%" ]
        <a href="studentSearch!info.action?studentId=${(student.id)!}" target="_blank" title="查看学生详细信息">${(student.user.code)!}</a>
      [/@]
      [@b.col property="gender.name" title="性别" width="20%" ]
        ${(student.person.gender.name)!}
      [/@]
      [@b.col property="department.name" title="院系" width="20%" ]
        ${(student.state.department.name)!}
      [/@]
      [@b.col property="stdType.name" title="学生类别" width="20%" ]
        ${(student.stdType.name)!}
      [/@]
      [@b.col property="registed" title="是否有学籍" width="20%" ]
        ${((student.registed)?string("是","否"))!}
      [/@]
      [/@]
  [/@]
</div>
[--]
  <div style="width:60%;margin-left:auto;margin-right:auto">
    [#list students! as student]
      [#if student_index%3==0]
        <table align="center" width="100%" style="border:1px solid #A6C9E2;">
          <tr>
      [/#if]
          <td width="30%" style="background-color:#e8eefa;">
          <table width="100%">
              <tr>
                <td rowspan="3" width="80px">[@eams.avatar user= student.user/]</td>
              </tr>
              <tr>
                   <td><a href="studentSearch!info.action?studentId=${(student.id)!}" target="_blank"  title="查看学生详细信息">${(student.user.code)!}</a></td>
              </tr>
              <tr>
                   <td>
                     ${(student.user.name)!}&nbsp;
                     ${(student.person.gender.name)!}<br>
                     [#if status[student.user.code]?? && status[student.user.code].inschool]
                         在校
                     [/#if]
                     [#if status[student.user.code]?? && !status[student.user.code].inschool]
                         <font color="red">${(status[student.user.code].status.name)!}</font>
                     [/#if]
                   </td>
              </tr>
           </table>
         </td>
      [#if student_index%3==2]
          </tr>
        </table>
      [/#if]
      [#if (students?size)%3==1&&student_index==(students?size-1)]
          </tr>
        </table>
      [/#if]
      [#if (students?size)%3==2&&student_index==(students?size-1)]
            <td width="30%" style="background-color:#e8eefa;">
              <table width="100%">
                  <tr><td>&nbsp;</td></tr>
                  <tr><td>&nbsp;</td></tr>
                  <tr><td>&nbsp;</td></tr>
               </table>
             </td>
           </tr>
        </table>
      [/#if]
    [/#list]
    [#if (students!?size)==0]
      <div align="center" style="color:#666666;background:#E1ECFF;"><b>该班级没有学生!</b></div>
    [/#if]
  </div>
[@b.foot /]

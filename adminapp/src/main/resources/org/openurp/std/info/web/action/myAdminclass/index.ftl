[#ftl/]
[@b.head/]
[@b.toolbar title="班级信息"][/@]
[#if me.squad??]
[#assign squad=me.squad/]
<table class="formTable" width="80%" align="center">
  <tr><td align="center" colspan="4" class="index_view"><b>班级基本信息</b></td></tr>
  <tr>
    <td class="title" width="20%">班级名称:</td>
    <td class="brightStyle" width="30%">${(squad.name)!}</td>
    <td class="title" width="20%">班级代码:</td>
    <td class="brightStyle" width="30%">${(squad.code)!}</td>
  </tr>
  <tr>
    <td class="title" width="20%">院系:</td>
    <td width="30%">${(squad.department.name)!}</td>
    <td class="title" width="20%">学生类别:</td>
    <td width="30%">${(squad.stdType.name)!}</td>
  </tr>
  <tr>
    <td class="title" width="20%">专业:</td>
    <td width="30%">${(squad.major.name)!}</td>
    <td class="title" width="20%">方向:</td>
    <td width="30%">${(squad.direction.name)!}</td>
  </tr>
  <tr>
    <td class="title" width="20%">计划人数:</td>
    <td width="30%">${(squad.planCount)!}</td>
    <td class="title" width="20%">实际人数:</td>
    <td width="30%">${(squad.stdCount)!}</td>
  </tr>
  <tr>
    <td class="title" width="20%">创建日期:</td>
    <td width="30%">${(squad.createdAt)!}</td>
    <td class="title" width="20%">更新日期:</td>
    <td width="30%">${(squad.updatedAt)!}</td>
  </tr>
</table>
<div style="width:80%;margin-left:auto;margin-right:auto;background-color:#E1ECFF;text-align:center">
  <b>班级学生列表</b>
</div>
<div style="width:80%;margin-left:auto;margin-right:auto">
  [@b.grid items=squad.students var="student" sortable="false"]
    [@b.row]
      [@b.col title="序号" width="5%" ]${student_index+1}[/@]
      [@b.col property="code" title="学号" width="20%" /]
      [@b.col property="name" title="姓名" width="15%"/]
      [@b.col property="gender.name" title="性别" width="10%" /]
      [@b.col property="major.name" title="专业" width="20%" /]
      [@b.col property="direction.name" title="方向" width="20%" /]
      [@b.col property="stdType.name" title="学生类别" width="10%" /]
    [/@]
  [/@]
</div>
[#else]
  你还没有编入行政班级中。
[/#if]
[@b.foot/]

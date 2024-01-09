[#ftl]
<style>
.list.infoTable tbody > tr.red {
  background-color: DarkSalmon;
}

</style>
  <table class="infoTable" align="center" width="100%">
    <tr>
      <td class="title" width="100px">学号姓名:</td>
      <td>${student.code}[#if !student.registed]<sup>无学籍</sup>[/#if] ${student.name}</td>
      <td class="title" width="100px">年级:</td>
      <td>${(student.state.grade)!}</td>
      <td class="title" width="100px" rowspan="5">照片:</td>
      <td rowspan="5"><img width="80px" height="110px" src="${avatarUrl}" alt="${(student.name)!}" title="${(student.name)!}"/></td>
    </tr>
    <tr>
      <td class="title">培养层次:</td>
      <td>${(student.level.name)!}</td>
      <td class="title">院系:</td>
      <td>${(student.state.department.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">培养类型:</td>
      <td>${(student.eduType.name)!}</td>
      <td class="title">专业:</td>
      <td>${(student.state.major.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">学制:</td>
      <td>${student.duration}</td>
      <td class="title">专业方向:</td>
      <td>${(student.state.direction.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">学生类别:</td>
      <td>${(student.stdType.name)!}</td>
      <td class="title">行政班:</td>
      <td>${(student.state.squad.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">学习形式:</td>
      <td>${(student.studyType.name)!}</td>
      <td class="title">是否在校:</td>
      <td>${(student.state.inschool?string("是", "否"))!}</td>
      <td class="title">校区:</td>
      <td>${(student.state.campus.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">学籍有效:</td>
      <td>${(student.beginOn?string("yyyy-MM-dd"))!}~${(student.endOn?string("yyyy-MM-dd"))!}</td>
      <td class="title">学籍状态:</td>
      <td>${(student.state.status.name)?if_exists}</td>
      <td class="title">[#if student.tutor??]导师[#else]班主任[/#if]:</td>
      <td>
      [#if student.tutor??]${(student.tutor.name)!}[#else]${(student.state.squad.master.name)!}[/#if]
      [#if student.advisor??]&nbsp;&nbsp;学位论文导师:${student.advisor.name}[/#if]
      </td>
    </tr>
    <tr>
      <td class="title">入学~毕业:</td>
      <td>${(student.studyOn?string("yyyy-MM-dd"))!}~[#if (graduation.graduateOn)??]${graduation.graduateOn?string('yyyy-MM-dd')}[#else]${(student.graduateOn?string("yyyy-MM-dd"))!}[/#if]</td>
      <td class="title">备注:</td>
      <td colspan="3">${(student.remark?html)!}</td>
    </tr>
  </table>

  [#-- 学籍状态日志 --]
  [#if student.states?size>1]
  <div style="height: 5px"></div>
  <table class="list infoTable">
    <thead>
      <tr style="text-align:center">
        <th width="15%">时间</th>
        <th width="6%">年级</th>
        <th width="10%">院系</th>
        <th>专业、方向</th>
        <th>行政班</th>
        <th width="6%">是否在校</th>
        <th width="6%">状态</th>
        <th width="8%">校区</th>
        <th width="6%">备注</th>
      </tr>
    </thead>
    <tbody>
      [#list student.states?sort_by("beginOn")?reverse as state]
      <tr[#if (state.id!0) != student.state.id] class="text-muted"[/#if] style="text-align:center">
        <td>${state.beginOn?string("yyyy-MM-dd")}~${(state.endOn?string("yyyy-MM-dd"))!}</td>
        <td>${state.grade}</td>
        <td>${state.department.shortName!state.department.name}</td>
        <td>${(state.major.name)?if_exists} ${(state.direction.name)!}</td>
        <td class="text-ellipsis">${(state.squad.shortName)?default((state.squad.name)!)}</td>
        <td>${state.inschool?string("是", "否")}</td>
        <td>${state.status.name}</td>
        <td>${(state.campus.shortName!state.campus.name)!}</td>
        <td>${(state.remark?html)!}</td>
      </tr>
      [/#list]
    </tbody>
  </table>
  [/#if]

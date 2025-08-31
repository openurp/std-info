[#ftl]
<style>
  td.title{
    padding: 0.2rem 0rem;
    text-align: right;
    color: #6c757d !important;
  }
  .table-mini th{
    color:#6c757d !important;
    font-weight: normal;
  }
  .table-mini{
    table-layout: fixed;
  }
</style>
  <table class="table table-sm" style="table-layout:fixed;" >
    <colgroup>
      <col width="13%">
      <col width="20%">
      <col width="13%">
      <col width="20%">
      <col width="14%">
      <col width="20%">
    </colgroup>
    <tr>
      <td class="title">学号姓名:</td>
      <td>${student.code}[#if !student.registed]<sup>无学籍</sup>[/#if] ${student.name}</td>
      <td class="title">年级:</td>
      <td>${(student.state.grade)!}</td>
      <td class="title" rowspan="5">照片:</td>
      <td rowspan="5"><img height="110px" src="${avatarUrl}" alt="${(student.name)!}" title="${(student.name)!}"/></td>
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
      <td class="title">班级:</td>
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
      <td class="title">入学~预计毕业:</td>
      <td>${(student.beginOn?string("yyyy-MM-dd"))!}~${(student.graduateOn?string("yyyy-MM-dd"))!}[#if (graduate.graduateOn)??]<span class="text-muted">[#if graduate.graduateOn!=student.graduateOn]实际${graduate.graduateOn?string('yyyy-MM-dd')}[#else]如期毕业[/#if]</span>[/#if]</td>
      <td class="title">学籍状态:</td>
      <td>${(student.state.status.name)?if_exists} [#if student.graduationDeferred]延期[/#if]</td>
      <td class="title">[#if student.majorTutors?size>0]导师[#else]班主任[/#if]:</td>
      <td>
      [#if student.majorTutors?size>0][#list student.majorTutors as t]${t.name}[#sep],[/#list][#else]${(student.state.squad.master.name)!}[/#if]
      [#if student.advisor??]&nbsp;&nbsp;学位论文导师:${student.advisor.name}[/#if]
      </td>
    </tr>
    <tr>
      <td class="title">预计离校~最晚:</td>
      <td>${(student.endOn?string("yyyy-MM-dd"))!}[#if student.maxEndOn != student.endOn]~${(student.maxEndOn?string("yyyy-MM-dd"))}[/#if]</td>
      <td class="title">备注:</td>
      <td colspan="3">${(student.remark?html)!}</td>
    </tr>
  </table>

  [#-- 学籍状态日志 --]
  [#if student.states?size>1]
  <table class="table table-sm table-mini">
    <thead>
      <tr style="text-align:center">
        <th width="3%"></th>
        <th width="15%">时间</th>
        <th width="6%">年级</th>
        <th width="10%">院系</th>
        <th>专业、方向、班级</th>
        <th width="6%">是否在校</th>
        <th width="9%">状态</th>
        <th width="8%">校区</th>
        <th width="8%">备注</th>
      </tr>
    </thead>
    <tbody>
      [#list student.states?sort_by("beginOn")?reverse as state]
      <tr[#if (state.id!0) != student.state.id] class="text-muted"[/#if] style="text-align:center">
        <td>[#if (state.id!0) == student.state.id]🚩[/#if]</td>
        <td>${state.beginOn?string("yyyy-MM-dd")}~${(state.endOn?string("yyyy-MM-dd"))!}</td>
        <td>${state.grade}</td>
        <td>${state.department.shortName!state.department.name}</td>
        <td class="text-ellipsis">${(state.major.name)?if_exists} ${(state.direction.name)!} ${(state.squad.shortName)?default((state.squad.name)!)}</td>
        <td>${state.inschool?string("是", "否")}</td>
        <td>${state.status.name}</td>
        <td>${(state.campus.shortName!state.campus.name)!}</td>
        <td>${(state.remark?html)!}</td>
      </tr>
      [/#list]
    </tbody>
  </table>
  [/#if]

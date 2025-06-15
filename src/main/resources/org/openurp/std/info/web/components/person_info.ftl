[#ftl]
[#if !((student.person.id)??)]
<div style="color: red">当前学生基本信息还未配置！</div>
[#else]
<style>
  td.title{
    padding: 0.2rem 0rem;
    text-align: right;
    color: #6c757d !important;
  }
</style>
  <table class="table table-sm" style="table-layout:fixed;margin-bottom: 0px;">
    <colgroup>
      <col width="13%">
      <col width="20%">
      <col width="13%">
      <col width="20%">
      <col width="14%">
      <col width="20%">
    </colgroup>
    <tr>
      <td class="title">姓名:</td>
      <td>${student.name?html}</td>
      <td class="title">姓名拼音:</td>
      <td>${(student.person.phoneticName?html)!}</td>
      <td class="title">曾用名:</td>
      <td>${(student.person.formerName?html)!}</td>
    </tr>
    <tr>
      <td class="title">国家地区:</td>
      <td>${(student.person.country.name)!}</td>
      <td class="title">性别:</td>
      <td>${(student.person.gender.name)!}</td>
      <td class="title">出生年月:</td>
      <td>${((student.person.birthday)?string("yyyy-MM-dd"))!}</td>
    </tr>
    <tr>
      <td class="title">民族:</td>
      <td>${(student.person.nation.name)!}</td>
      <td class="title">证件类型:</td>
      <td>${(student.person.idType.name)!}</td>
      <td class="title">证件号码:</td>
      <td>${(student.person.code)!"<br>"}</td>
    </tr>
    <tr>
      <td class="title">籍贯:</td>
      <td>${((student.person.homeTown?html))!}</td>
      <td class="title">政治面貌:</td>
      <td>${(student.person.politicalStatus.name)!}</td>
      <td class="title">维护时间:</td>
      <td>${(student.person.updatedAt?string("yyyy-MM-dd HH:mm:ss"))!}</td>
    </tr>
  </table>
[/#if]
[#include "/org/openurp/std/info/web/components/contact_info.ftl"/]

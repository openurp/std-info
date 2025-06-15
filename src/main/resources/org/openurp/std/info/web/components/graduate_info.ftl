[#ftl]
[#if !((graduate.id)??)]
<div style="color: red">当前学生毕业信息还未配置！</div>
[/#if]
<style>
  td.title{
    padding: 0.2rem 0rem;
    text-align: right;
    color: #6c757d !important;
  }
</style>
  <table class="table table-sm" style="table-layout:fixed">
    <colgroup>
      <col width="13%">
      <col width="20%">
      <col width="13%">
      <col width="20%">
      <col width="14%">
      <col width="20%">
    </colgroup>
    <tr>
      <td class="title">毕结业情况:</td>
      <td width="23%">${(graduate.result.name)!}</td>
      <td class="title">毕业日期:</td>
      <td>${(graduate.graduateOn?string('yyyy-MM-dd'))!}</td>
      <td class="title">毕业证书编号:</td>
      <td width="23%">${(graduate.certificateNo)!}</td>
    </tr>
    <tr>
      <td class="title">学位:</td>
      <td>${(graduate.degree.name)!}</td>
      <td class="title">学位授予日期:</td>
      <td>${(graduate.degreeAwardOn?string("yyyy-MM-dd"))!}</td>
      <td class="title">学位证书号:</td>
      <td>${(graduate.diplomaNo)!}</td>
    </tr>
    <tr>
      <td class="title" >毕业界别:</td>
      <td>${(graduate.season.name)!}</td>
      <td class="title">毕业轮次:</td>
      <td>${graduate.batchNo!}</td>
      <td class="title">最近维护时间:</td>
      <td>${(graduate.updatedAt?string("yyyy-MM-dd HH:mm:ss"))!}</td>
    </tr>
  </table>

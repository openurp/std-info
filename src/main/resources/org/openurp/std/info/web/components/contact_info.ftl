[#ftl]
[#if !((contact.id)??)]
<div style="color: red">当前学生联系信息还未配置！</div>
[#else]
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
      <td class="title">电子邮箱:</td>
      <td>${(contact.email?html)!}</td>
      <td class="title">电话:</td>
      <td>${(contact.phone?html)!}</td>
      <td class="title">移动电话:</td>
      <td>${(contact.mobile?html)!}</td>
    </tr>
    <tr>
      <td class="title">联系地址:</td>
      <td colspan="3">${(contact.address?html)!}</td>
      <td class="title">维护时间:</td>
      <td>${(contact.updatedAt?string("yyyy-MM-dd HH:mm"))!}</td>
    </tr>
  </table>
[/#if]

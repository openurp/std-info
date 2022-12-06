[#ftl]
[#if !((contact.id)??)]
<div style="color: red">当前学生联系信息还未配置！</div>
[#else]
  <table class="infoTable">
    <tr>
      <td class="title" width="100px">电子邮箱：</td>
      <td>${(contact.mail?html)!}</td>
      <td class="title" width="100px">电话：</td>
      <td>${(contact.phone?html)!}</td>
      <td class="title" width="100px">移动电话：</td>
      <td>${(contact.mobile?html)!}</td>
    </tr>
    <tr>
      <td class="title">联系地址：</td>
      <td>${(contact.address?html)!}</td>
      <td class="title">维护时间：</td>
      <td>${(contact.updatedAt?string("yyyy-MM-dd"))!}</td>
      <td colspan="2"></td>
    </tr>
  </table>
[/#if]

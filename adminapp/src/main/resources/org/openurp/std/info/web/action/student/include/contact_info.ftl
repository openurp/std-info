[#ftl]
[#if !((student.person.id)??)]
<div style="color: red">请先配置<span style="font-weight: bold">学生基本信息</span>！</div>
[#elseif !((contact.id)??)]
<div style="color: red">当前学生联系信息还未配置！</div>
[/#if]
  <table class="infoTable">
    <tr>
      <td class="title" width="10%">电子邮箱：</td>
      <td width="23%">${(contact.mail?html)!}</td>
      <td class="title" width="10%">电话：</td>
      <td width="23%">${(contact.phone?html)!}</td>
      <td class="title" width="10%">移动电话：</td>
      <td>${(contact.mobile?html)!}</td>
    </tr>
    <tr>
      <td class="title">联系地址：</td>
      <td>${(contact.address?html)!}</td>
      <td class="title">最近维护时间：</td>
      <td>${(contact.updatedAt?string("yyyy-MM-dd"))!}</td>
      <td colspan="2"></td>
    </tr>
  </table>

<#if contact?exists>
<table style="width:95%" align="center" class="infoTable">
    <tr>
        <td colspan="13" style="font-weight:bold;text-align:center" class="darkColumn">联系信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>电子邮箱：</td>
        <td ${ContentTdHTML1}>${(contact.mail)?if_exists}</td>
       <td class="title"${titleTdHTML}>联系电话：</td>
        <td ${ContentTdHTML2}>${(contact.phone)?if_exists}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>移动电话：</td>
        <td ${ContentTdHTML1}>${(contact.mobile)?if_exists}</td>
       <td class="title"${titleTdHTML}>通讯地址：</td>
        <td ${ContentTdHTML2}>${(contact.address)?if_exists}</td>
    </tr>
</table>
</#if>

<#if graduation?exists>
<table style="width:95%" align="center" class="infoTable">
  <tr>
        <td colspan="4" style="font-weight:bold;text-align:center" class="darkColumn">毕业信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>毕结业情况：</td>
        <td ${ContentTdHTML1}>${(graduation.graduateState.name)!}</td>
      <td class="title"${titleTdHTML}>毕业证书编号：</td>
      <td ${ContentTdHTML2}>${(graduation.certificateNo)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>学位：</td>
        <td>${(graduation.degree.name)!}</td>
        <td class="title"${titleTdHTML}>学位授予日期：</td>
        <td>${(graduation.degreeAwardOn)!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>学位证书号：</td>
        <td colSpan="3">${(graduation.diplomaNo)!}</td>
  </tr>
</table>
</#if>

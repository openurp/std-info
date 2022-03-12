<#if abroadStudent?exists>
<table style="width:95%" align="center" class="infoTable">
  <tr>
        <td colspan="13" style="font-weight:bold;text-align:center" class="darkColumn">留学生信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>CSC编号：</td>
        <td ${ContentTdHTML1}>${(abroadStudent.cscno)?if_exists}</td>
        <td class="title"${titleTdHTML}>HSK等级：</td>
        <td ${ContentTdHTML2}>${(abroadStudent.HskLevel.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>护照编号：</td>
        <td>${(abroadStudent.passportNo)?if_exists}</td>
        <td class="title"${titleTdHTML}>护照到期时间：</td>
        <td>${(abroadStudent.passportExpiredOn)?if_exists}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>护照类别：</td>
        <td>${(abroadStudent.passportType.name)?if_exists}</td>
        <td class="title"${titleTdHTML}>签证编号：</td>
        <td>${(abroadStudent.visaNo)?if_exists}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>签证到期时间：</td>
        <td>${(abroadStudent.visaExpiredOn)?if_exists}</td>
        <td class="title"${titleTdHTML}>签证类别：</td>
        <td>${(abroadStudent.visaType.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>居住许可证编号：</td>
        <td>${(abroadStudent.resideCaedNo)?if_exists}</td>
        <td class="title"${titleTdHTML}>居住许可证到期时间：</td>
        <td>${(abroadStudent.resideCaedExpiredOn)?if_exists}</td>
    </tr>
</table>
</#if>

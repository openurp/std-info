<#if enrollInfo?exists>
<table style="width:95%" align="center" class="infoTable">
  <tr>
        <td colspan="4" style="font-weight:bold;text-align:center" class="darkColumn">入学信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>入学方式：</td>
        <td ${ContentTdHTML1}>${(enrollInfo.enrollMode.name)!}</td>
      <td class="title"${titleTdHTML}>培养方式：</td>
      <td ${ContentTdHTML2}>${(enrollInfo.educationMode.name)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>生源地：</td>
      <#--等待研发部做 省市区级联组件-->
        <td>${(enrollInfo.originDivision.parent.name)!}</td>
        <td class="title"${titleTdHTML}>费用来源：</td>
        <td>${(enrollInfo.feeOrigin.name)!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>准考证号：</td>
        <td>${(enrollInfo.examNumber)!}</td>
        <td class="title"${titleTdHTML}>考生号：</td>
        <td colspan="3">${(enrollInfo.examineeCode)!}</td>
  </tr>
  <#--tr>
         <td class="title"${titleTdHTML}>高考报名号：</td>
        <td>${(enrollInfo.enrollNumber)!}</td>
    </tr-->
</table>
</#if>

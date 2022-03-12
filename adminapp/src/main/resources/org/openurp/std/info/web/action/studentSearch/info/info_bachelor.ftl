<#if bachelorInfo?exists>
<table style="width:95%" align="center" class="infoTable">
    <tr>
        <td colspan="13" style="font-weight:bold;text-align:center" class="darkColumn">本科阶段学历学位信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>大学毕业专业：</td>
        <td ${ContentTdHTML1}>${(bachelorInfo.majorName)!}</td>
        <td class="title"${titleTdHTML}>学科门类：</td>
        <td ${ContentTdHTML2}>${(bachelorInfo.subjectCategory.name)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>毕业日期：</td>
        <td>${(bachelorInfo.graduateOn)!}</td>
    </tr>
</table>
</#if>

<#if admission?exists>
<table style="width:95%" align="center" class="infoTable">
    <tr>
        <td colspan="13" style="font-weight:bold;text-align:center" class="darkColumn">录取信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>录取通知书号：</td>
        <td ${ContentTdHTML1}>${(admission.letterNo)!}</td>
        <td class="title"${titleTdHTML}>录取第几志愿：</td>
        <td ${ContentTdHTML2}>${(admission.admissionIndex)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>录取类别：</td>
        <td ${ContentTdHTML1}>${(admission.admissionType.name)!}</td>
        <td class="title"${titleTdHTML}>收费类别：</td>
        <td ${ContentTdHTML2}>${(admission.feeOrigin.name)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>录取院系：</td>
        <td ${ContentTdHTML1}>${(admission.department.name)!}</td>
        <td class="title"${titleTdHTML}>录取专业：</td>
        <td ${ContentTdHTML2}>${(admission.major.name)!}</td>
    </tr>
    <#if admissionMajor??>
    <tr>
      <td class="title"${titleTdHTML}>毕业专业代码：</td>
        <td>${(admissionMajor.majorCode)!}</td>
        <td class="title"${titleTdHTML}>毕业专业：</td>
        <td>${(admissionMajor.majorName)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>学位：</td>
        <td>${(admissionMajor.degree.name)!}</td>
        <td class="title"${titleTdHTML}>学历毕业日期：</td>
        <td>${(admissionMajor.degreeAwardOn?string('yyyy-MM'))!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>学位授予单位：</td>
        <td>${(admissionMajor.degreeAwardBy)!}</td>
        <td class="title"${titleTdHTML}>推荐单位：</td>
        <td>${(admissionMajor.recommendBy)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>学科门类：</td>
        <td>${(admissionMajor.disciplineCategory.name)!}</td>
        <td class="title"${titleTdHTML}>毕业证书编号：</td>
        <td>${(admissionMajor.certificateNo)!}</td>
    </tr>
    </#if>
</table>
</#if>

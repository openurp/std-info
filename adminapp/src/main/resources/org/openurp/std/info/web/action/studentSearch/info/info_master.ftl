<#if student.studentMaster?exists>
<table style="width:95%" align="center" class="infoTable">
    <tr>
        <td colspan="13" style="font-weight:bold;text-align:center" class="darkColumn">硕士阶段学历学位信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>学位授予学校：</td>
        <td ${ContentTdHTML1}>${(stdMaster.degreeAwardBy)!}</td>
        <td class="title"${titleTdHTML}>毕业学校：</td>
        <td ${ContentTdHTML2}>${(stdMaster.degreeSchool)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>学位获得日期：</td>
        <td>${(stdMaster.degreeAwardOn)!}</td>
        <td class="title"${titleTdHTML}>学历毕业日期：</td>
        <td>${(stdMaster.eduDegreeDate)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>最后学位专业：</td>
        <td>${(stdMaster.degreeSpecialityName)!}</td>
        <td class="title"${titleTdHTML}>最后学历专业：</td>
        <td>${(stdMaster.specialityName)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>学位证书号码：</td>
        <td>${(stdMaster.degreeNumber)!}</td>
        <td class="title"${titleTdHTML}>学历证书编号：</td>
        <td>${(stdMaster.certifacateNumber)!}</td>
    </tr>
</table>
<#--/#if-->

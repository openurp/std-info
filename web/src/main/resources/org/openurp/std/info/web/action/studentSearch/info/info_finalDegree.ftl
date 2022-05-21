<#--if student.finalDegreeInfo?exists-->
<table style="width:95%" align="center" class="infoTable">
  <tr>
        <td colspan="13" style="font-weight:bold;text-align:center" class="darkColumn">最后学位学历信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>最后学位：</td>
        <td ${ContentTdHTML1}>${(student.finalDegreeInfo.finalDegree.name)?if_exists}</td>
        <td class="title"${titleTdHTML}>最后学历：</td>
        <td ${ContentTdHTML2}>${(student.finalDegreeInfo.finalEduDegree.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>最后学位学校：</td>
        <td>${(student.finalDegreeInfo.finalDegreeSchool)?if_exists}</td>
        <td class="title"${titleTdHTML}>最后学历学校：</td>
        <td>${(student.finalDegreeInfo.finalSchool)!}</td>
    </tr>
  <tr>
      <td class="title"${titleTdHTML}>最后学位专业：</td>
        <td>${(student.finalDegreeInfo.degreeSpecialityName)?if_exists}</td>
        <td class="title"${titleTdHTML}>最后学历专业：</td>
        <td>${(student.finalDegreeInfo.specialityName)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>专业所属学科门类：</td>
        <td>${(student.finalDegreeInfo.subjectCategory.name)?if_exists}</td>
        <td class="title"${titleTdHTML}>专业所属一级学科：</td>
        <td>${(student.finalDegreeInfo.subject.name)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>最后学位获得日期：</td>
        <td>${(student.finalDegreeInfo.degreeDate)?if_exists}</td>
        <td class="title"${titleTdHTML}>最后学历毕业日期：</td>
        <td>${(student.finalDegreeInfo.eduDegreeDate)!}</td>
    </tr>
</table>
<#--/#if-->

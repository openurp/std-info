<#if examinee?exists>
<table style="width:95%" align="center" class="infoTable">
  <tr>
        <td colspan="4" style="font-weight:bold;text-align:center" class="darkColumn">考生信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>入学层次：</td>
        <td ${ContentTdHTML1}>${(examinee.level.name)!}</td>
      <td class="title"${titleTdHTML}>生源地：</td>
        <td>${(examinee.originDivision.name)!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>准考证号：</td>
        <td>${(examinee.examNumber)!}</td>
        <td class="title"${titleTdHTML}>考生号：</td>
        <td colspan="3">${(examinee.examineeCode)!}</td>
  </tr>
    <tr>
        <td class="title"${titleTdHTML}>毕业学校编号：</td>
        <td>${(examinee.schoolNo)!}</td>
        <td class="title"${titleTdHTML}>毕业学校名称：</td>
        <td colspan="3">${(examinee.schoolName)!}</td>
  </tr>
    <tr>
        <td class="title"${titleTdHTML}>毕业日期：</td>
        <td>${(examinee.graduateOn?string("yyyy-MM"))!}</td>
      <td class="title"${titleTdHTML}>入学方式：</td>
        <td ${ContentTdHTML1}>${(examinee.enrollMode.name)!}</td>
  </tr>
    <tr>
      <td class="title"${titleTdHTML}>培养方式：</td>
      <td ${ContentTdHTML2}>${(examinee.educationMode.name)!}</td>
      <td class="title"${titleTdHTML}>生源类别：</td>
      <td ${ContentTdHTML2}>${(examinee.examineeType.name)!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>招生录取总分：</td>
        <td>${(examinee.score)!}</td>
        <td class="title"${titleTdHTML}>其他各科分数：</td>
        <td><#list hschGradeTypes as t><#if examinee.scores.get(t.id)??>${t.name} ${examinee.scores.get(t.id)} </#if></#list></td>
    </tr>
</table>
</#if>

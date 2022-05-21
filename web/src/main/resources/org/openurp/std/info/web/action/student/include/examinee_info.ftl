[#ftl]
[#if !((student.person.id)??)]
<div style="color: red">请先配置<span style="font-weight: bold">学生基本信息</span>！</div>
[#elseif !((examinee.id)??)]
<div style="color: red">当前考生信息还未配置！</div>
[/#if]

  <table class="infoTable">
    <tr>
      <td class="title" width="10%">考生号：</td>
      <td width="23%">${(examinee.code?html)!}</td>
      <td class="title" width="10%">准考证号：</td>
      <td width="23%">${(examinee.examNo?html)!}</td>
      <td class="title" width="10%">生源地：</td>
      <td >${(examinee.originDivision.name?html)!}</td>
    </tr>
    <tr>
      <td class="title">毕业学校编号：</td>
      <td>${(examinee.schoolNo?html)!}</td>
      <td class="title" width="10%">毕业学校名称：</td>
      <td>${(examinee.schoolName?html)!}</td>
      <td class="title">毕业日期：</td>
      <td>${(examinee.graduateOn?string("yyyy-MM-dd"))!}</td>
    </tr>
    <tr>
      <td class="title">招生录取总分：</td>
      <td>${(examinee.score?html)!}</td>
      <td class="title">最近维护时间：</td>
      <td colspan="3">${(examinee.updatedAt?string("yyyy-MM-dd"))!}</td>
    </tr>
  </table>

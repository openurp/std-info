[#ftl]
[#if !((examinee.id)??)]
<div style="color: red">当前考生信息还未配置！</div>
[#else]
  <table class="table table-sm table-detail">
    <colgroup>
      <col width="13%">
      <col width="20%">
      <col width="13%">
      <col width="20%">
      <col width="14%">
      <col width="20%">
    </colgroup>
    <tr>
      <td class="title">考生号:</td>
      <td>${(examinee.code?html)!}</td>
      <td class="title">准考证号:</td>
      <td>${(examinee.examNo?html)!}</td>
      <td class="title">生源地:</td>
      <td>${(examinee.originDivision.name?html)!}</td>
    </tr>
    <tr>
      <td class="title">毕业学校:</td>
      <td>${(examinee.schoolName?html)!}</td>
      <td class="title">毕业日期:</td>
      <td>${(examinee.graduateOn?string("yyyy-MM-dd"))!}</td>
      <td class="title">录取成绩:</td>
      <td>${(examinee.score?html)!}</td>
    </tr>
    <tr>
      <td class="title">培养方式:</td>
      <td>${(examinee.educationMode.name)!}</td>
      <td class="title">入学方式:</td>
      <td>${(examinee.enrollMode.name)!}</td>
      <td class="title">委培单位:</td>
      <td>${(examinee.client)!}</td>
    </tr>
  </table>
[/#if]

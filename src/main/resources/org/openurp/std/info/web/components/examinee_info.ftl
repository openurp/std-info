[#ftl]
[#if !((examinee.id)??)]
<div style="color: red">当前考生信息还未配置！</div>
[#else]
  <table class="infoTable">
    <tr>
      <td class="title" width="100px">考生号:</td>
      <td>${(examinee.code?html)!}</td>
      <td class="title" width="100px">准考证号:</td>
      <td>${(examinee.examNo?html)!}</td>
      <td class="title" width="100px">生源地:</td>
      <td>${(examinee.originDivision.name?html)!}</td>
    </tr>
    <tr>
      <td class="title" width="11%">毕业学校:</td>
      <td>${(examinee.schoolName?html)!}</td>
      <td class="title">毕业日期:</td>
      <td>${(examinee.graduateOn?string("yyyy-MM-dd"))!}</td>
      <td class="title">录取总分:</td>
      <td>${(examinee.score?html)!}</td>
    </tr>
    <tr>
      <td class="title">培养方式:</td>
      <td>${(examinee.educationMode.name)!}</td>
      <td class="title">委培单位:</td>
      <td>${(examinee.client)!}</td>
      <td class="title">维护时间:</td>
      <td>${(examinee.updatedAt?string("yyyy-MM-dd"))!}</td>
    </tr>
  </table>
[/#if]

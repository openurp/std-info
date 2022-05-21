[#ftl]
[#if !((graduation.id)??)]
<div style="color: red">当前学生毕业信息还未配置！</div>
[/#if]
  <table class="infoTable">
    <tr>
      <td class="title" width="10%">毕结业情况：</td>
      <td width="23%">${(graduation.educationResult.name)!}</td>
      <td class="title" width="10%">毕业证书编号：</td>
      <td width="23%">${(graduation.code)!}</td>
      <td class="title" width="10%">毕业日期：</td>
      <td>${(graduation.graduateOn?string('yyyy-MM-dd'))!}</td>
    </tr>
    <tr>
      <td class="title" width="10%">学位：</td>
      <td>${(graduation.degree.name)!}</td>
      <td class="title">学位证书号：</td>
      <td>${(graduation.diplomaNo)!}</td>
      <td class="title">学位授予日期：</td>
      <td>${(graduation.degreeAwardOn?string("yyyy-MM-dd"))!}</td>
    </tr>
    <tr>
      <td class="title">最近维护时间：</td>
      <td colspan="5">${(graduation.updatedAt?string("yyyy-MM-dd HH:mm:ss"))!}</td>
    </tr>
  </table>

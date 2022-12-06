[#ftl]
[#if !((student.person.id)??)]
<div style="color: red">当前学生基本信息还未配置！</div>
[#else]
  <table class="infoTable">
    <tr>
      <td class="title" width="100px">姓名：</td>
      <td>${student.name?html}</td>
      <td class="title" width="100px">英文名：</td>
      <td>${(student.person.phoneticName?html)!}</td>
      <td class="title" width="100px">曾用名：</td>
      <td>${(student.person.formerName?html)!}</td>
    </tr>
    <tr>
      <td class="title">国家地区：</td>
      <td>${(student.person.country.name)!}</td>
      <td class="title">性别：</td>
      <td>${(student.person.gender.name)!}</td>
      <td class="title">出生年月：</td>
      <td>${((student.person.birthday)?string("yyyy-MM-dd"))!}</td>
    </tr>
    <tr>
      <td class="title">民族：</td>
      <td>${(student.person.nation.name)!}</td>
      <td class="title">证件类型：</td>
      <td>${(student.person.idType.name)!}</td>
      <td class="title">证件号码：</td>
      <td>${(student.person.code)!"<br>"}</td>
    </tr>
    <tr>
      <td class="title">籍贯：</td>
      <td>${((student.person.homeTown?html))!}</td>
      <td class="title">政治面貌：</td>
      <td>${(student.person.politicalStatus.name)!}</td>
      <td class="title">维护时间：</td>
      <td>${(student.person.updatedAt?string("yyyy-MM-dd HH:mm:ss"))!}</td>
    </tr>
  </table>
[/#if]

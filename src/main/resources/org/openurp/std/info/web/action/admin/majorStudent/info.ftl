[#ftl]
[@b.head/]
[@b.toolbar title="辅修学生主修信息"]
  bar.addBack("${b.text("action.back")}");
[/@]
<table class="infoTable">
  <tr>
    <td class="title">学号:</td>
    <td class="content">${majorStudent.std.code}</td>
    <td class="title">姓名:</td>
    <td class="content">${majorStudent.std.name}</td>
  </tr>
  <tr>
    <td class="title">主修学号:</td>
    <td class="content">${majorStudent.code}</td>
    <td class="title">主修学校:</td>
    <td class="content">${(majorStudent.school.name)!}</td>
  </tr>
  <tr>
    <td class="title">主修专业:</td>
    <td class="content">${majorStudent.majorName!}</td>
    <td class="title">主修专业学科门类:</td>
    <td class="content">${(majorStudent.majorCategory.name)!}</td>
  </tr>
  <tr>
    <td class="title">主修专业英文名:</td>
    <td class="content">${majorStudent.enMajorName!}</td>
  </tr>
</table>

[@b.foot/]

[#ftl/]
[@b.messages slash="4"/]
<table class="infoTable">
    <tr>
      <td class="title" width="10%">学年学期：</td>
      <td width="23%">${register.semester.schoolYear} 学年度 ${register.semester.name}学期</td>
      <td class="title" width="10%">学号姓名：</td>
      <td width="23%">${register.std.user.code} ${register.std.user.name}</td>
      <td class="title" width="10%">注册日期</td>
      <td>${(register.registerAt)?string("yyyy-MM-dd")}</td>
    </tr>
    <tr>
      <td class="title">年级：</td>
      <td>${register.std.state.grade}</td>
      <td class="title">院系：</td>
      <td>${register.std.state.department.name}</td>
      <td class="title">专业：</td>
      <td>${(register.std.state.major.name)!} ${(register.std.state.direction.name)!}</td>
    </tr>
    <tr>
      <td class="title">班级：</td>
      <td>${(register.std.state.squad.name)!} </td>
      <td class="title">学籍状态：</td>
      <td>${register.std.state.status.name}</td>
      <td class="title">联系电话：</td>
      <td>${register.std.user.mobile}</td>
    </tr>
  </table>

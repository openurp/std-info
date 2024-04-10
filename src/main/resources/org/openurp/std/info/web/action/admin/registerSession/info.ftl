[#ftl/]
[@b.messages slash="4"/]
<table class="infoTable">
    <tr>
      <td class="title" width="120px">年级：</td>
      <td >${session.grades}</td>
      <td class="title" width="120px">培养层次：</td>
      <td>${session.level.name}</td>
    </tr>
    <tr>
      <td class="title" >起始截至时间：</td>
      <td colspan="3">${session.beginAt?string("yyyy-MM-dd HH:mm")}~${session.endAt?string("yyyy-MM-dd HH:mm")}</td>
    </tr>
  </table>

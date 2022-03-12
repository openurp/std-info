[#ftl]
[#macro subTitleHTML caption]<span style="color: blue; font-weight: bold">${caption!}</span>[/#macro]
<div>
  [@subTitleHTML "本班级："/]
  <table id="distributeTable" class="gridtable" width="100%">
    <thead class="gridhead">
      <tr>
        <th>班级代码</th>
        <th>班级名称</th>
        <th>班级年级</th>
        <th>班级培养层次</th>
        <th>班级学生类别</th>
        <th>班级院系</th>
        <th>班级专业</th>
        <th>班级方向</th>
        <th>班级校区</th>
      </tr>
    </thead>
    <tbody>
      <tr class="griddata-even">
        <td>${squad.code}</td>
        <td>${squad.name}</td>
        <td>${squad.grade}</td>
        <td>${squad.level.name}</td>
        <td>${squad.stdType.name}</td>
        <td>${squad.department.name}</td>
        <td>${squad.major.name}</td>
        <td>${(squad.direction.name)!}</td>
        <td>${(squad.campus.name)!}</td>
      </tr>
    </tbody>
  </table>
</div>
<div style="margin-top: 20px">
  [@subTitleHTML "可调学生："/]
</div>
[@b.div id="distributableStudentsDiv" style="height: 380px; overflow-y: auto"/]
<script>
  $(function() {
    $(document).ready(function() {
      $.ajax({
        "type": "post",
        "url": "${base}/squadStudent!loadDistributableStudentsInAjax.action",
        "async": false,
        "dataType": "html",
        "data": {
          "squad.id": "${Parameters["squad.id"]}",
          "freshmen": "${Parameters["freshmen"]}",
          "brothers": "${Parameters["brothers"]}",
          "otherFlags": "${Parameters["otherFlags"]}",
          "otherFreshmen": "${Parameters["otherFreshmen"]}",
          "isSingle": ${Parameters["isSingle"]!0}
        },
        "success": function(data) {
          $("div#distributableStudentsDiv").html(data);
        }
      });
    });
  });
</script>

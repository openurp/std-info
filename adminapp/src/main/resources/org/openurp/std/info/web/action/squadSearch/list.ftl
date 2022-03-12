[#ftl/]
[@b.head/]
  <script src="${base}/static/scripts/common.js?v=2"></script>
  [@b.grid items=squades var="squad" sortable="true"]
    [@b.gridbar]
      [#--
      bar.addItem("班级名单", function() {
        var squadIds = bg.input.getCheckBoxValues("squad.id");
        if (isBlank(squadIds)) {
          alert("请选择操作的记录，谢谢！");
          return;
        }
        var form = document.squadListForm;
        form["squadIds"].value = squadIds;
        bg.form.submit(form.name, "squadSearch!batchPrint.action", "_blank");
      });
       --]

      bar.addItem("班级导出", function() {
        $.ajax({
          "type": "POST",
          "url": "${base}/squadSearch!loadSquadExportFieldAjax.action",
          "dataType": "json",
          "async": false,
          "success": function(data) {
            var form = document.squadListForm;
            form["flag"].value = 1;
            form["keys"].value = data.keys;
            form["titles"].value = data.titles;
            form["fileName"].value = "班级查询结果导出";
            bg.form.submit("squadListForm", "squadSearch!export.action", "_blank");
          }
        });
      }, "excel.png");

      bar.addItem("班级学生导出", function() {
        var squadId = bg.input.getCheckBoxValues("squad.id");
        if (isBlank(squadId) || squadId.split(",").length > 1) {
          alert("请选择一条操作的记录，谢谢！");
          return;
        }

        $.ajax({
          "type": "POST",
          "url": "${base}/squadSearch!loadStudentExportFiedlAjax.action",
          "dataType": "json",
          "async": false,
          "data": {
            "squadId": squadId
          },
          "success": function(data) {
            var form = document.squadListForm;
            form["flag"].value = 2;
            form["squadId"].value = squadId;
            form["keys"].value = data.keys;
            form["titles"].value = data.titles;
            form["fileName"].value = "班级学生名单导出";
            bg.form.submit("squadListForm", "squadSearch!studentExport.action", "_blank");
          }
        });
      }, "excel.png");
    [/@]
    [@b.row]
      [@b.boxcol/]
      [@b.col property="code" title="班级代码" width="15%"/]
      [@b.col sort="squad.name" title="班级名称" width="20%" ]
        [@b.a href="!info?squadId=${squad.id}" title="查看班级详细信息"]${(squad.name)!}[/@]
      [/@]
      [@b.col property="department.name" title="院系" width="20%"/]
      [@b.col property="stdType.name" title="学生类别" width="20%"/]
      [@b.col sort="squad.stdCount" title="计划/实际(人数)" width="20%" ]
        ${(squad.planCount)!}/${(squad.stdStates?size)!0}
      [/@]
    [/@]
  [/@]
  [@b.form name="squadListForm" action="squadSearch!search"]
    <input type="hidden" name="squadId" value=""/>
    <input type="hidden" name="squadIds" value=""/>
    <input type="hidden" name="flag" value=""/>
    <input type="hidden" name="keys" value="code,name,shortName,grade,stdType.name,department.name,major.name,direction.name,planCount,beginOn,endOn,stdCount,instructor.user.name,tutor.name,campus.name"/>
    <input type="hidden" name="titles" value="班级代码,班级名称,简称,年级,学生类别,院系,专业,方向,计划人数,开始日期,结束日期,学籍有效人数,辅导员,班导师,校区"/>
    <input type="hidden" name="fileName" value="班级查询结果导出"/>
    [#list Parameters?keys as key]
    <input type="hidden" name="${key}" value="${Parameters[key]!}"/>
    [/#list]
  [/@]
[@b.foot/]

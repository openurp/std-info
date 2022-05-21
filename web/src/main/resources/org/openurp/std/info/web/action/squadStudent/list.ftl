[#ftl/]
[@b.head/]
  [@b.messages slash = "7"/]
  [@b.grid items=squades var="squad" sortable="true"]
    [@b.gridbar]
      bar.addItem("单个调配学生", function() {
        var squadId = bg.input.getCheckBoxValues("squad.id");
        if (isBlank(squadId) || squadId.split(",").length > 1) {
          alert("请选择一个要分配学生的班级，谢谢！");
          return;
        }

        var form = document.squadStudentListForm;
        form.action = "${base}/squadStudent!distributeSingleEdit.action";
        form["squadId"].value = squadId;
        form.target = "squadStudentDiv";
        bg.form.submit(form);
      }, "update.png");

      bar.addItem("批量调配学生", function() {
        var squadIds = bg.input.getCheckBoxValues("squad.id");
        if (isBlank(squadIds) || squadIds.split(",").length > 10) {
          alert("请选择要分配学生的班级，一次选择目前最多支持 10 个，谢谢！");
          return;
        }

        var form = document.squadStudentListForm;
        form.action = "${base}/squadStudent!distributeEdit.action";
        form["squadIds"].value = squadIds;
        form.target = "squadStudentDiv";
        bg.form.submit(form);
      }, "update.png");
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
        [#assign inSchoolCount = 0 /]
        [#list studentsMap(squad.id)! as student]
          [#if (student.state.inschool)?default(false)]
            [#assign inSchoolCount = inSchoolCount + 1 /]
          [/#if]
        [/#list]
        ${(squad.planCount)!}/${(inSchoolCount)!0}
      [/@]
    [/@]
  [/@]
  [@b.form name="squadStudentListForm" action="squadStudent!search"]
    <input type="hidden" name="squadId" value=""/>
    <input type="hidden" name="squadIds" value=""/>
    [#list Parameters?keys as key]
    <input type="hidden" name="${key}" value="${Parameters[key]!}"/>
    [/#list]
  [/@]
[@b.foot/]

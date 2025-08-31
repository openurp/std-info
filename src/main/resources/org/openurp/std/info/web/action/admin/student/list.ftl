[@b.head/]
  [@b.form name="studentListForm" action="!search"]
    [@b.grid items=students var="student" sortable="true"]
      [@b.gridbar]
        bg.load(["jquery-colorbox"]);
        bar.addItem("新增", action.add());
        bar.addItem("修改", action.edit());
        bar.addItem("导出..",function() {
          var paramMap = {};
          $("#studentSearchForm").find("[name]").each(function() {
            if($(this).attr("name")){
              paramMap[$(this).attr("name")] = $(this).val();
            }
          });
          $(this).colorbox({
            "transition": "none",
            "opacity" :0.2,
            "title": "按顺序选择字段导出",
            "overlayClose": false,
            "speed": 0,
            "width": "800px",
            "height": "480px",
            "href": "${b.url('!displayExpAttrs')}",
            "data": paramMap
          });
        });
        var m1 = bar.addMenu("高级...");
        m1.addItem("补足姓名拼音",action.multi("batchUpdateEnName"));
        m1.addItem("更新姓名拼音",action.multi("batchUpdateEnName","确定覆盖更新？","&forceUpdate=1"));
        m1.addItem("删除学籍",action.remove());
      [/@]
      [@b.row]
        [@b.boxcol/]
        [@b.col property="code" title="学号" width="120px"/]
        [@b.col property="name" title="姓名" width="80px"]
          [@b.a href="!info?id=${student.id}" target="_blank"]<div title="${student.name}" class="text-ellipsis">${student.name}</div>[/@]
        [/@]
        [@b.col property="gender.name" title="性别" width="50px"/]
        [@b.col property="state.grade" title="年级" width="60px"/]
        [@b.col property="level.name" title="培养层次" width="60px"/]
        [#if project.eduTypes?size>1]
        [@b.col property="eduType.name" title="培养类型" width="60px"/]
        [/#if]
        [@b.col property="state.department.name" title="院系" width="100px"]
          ${student.state.department.shortName!student.state.department.name}
        [/@]
        [@b.col property="state.major.name" title="专业与方向"]
          ${(student.state.major.name)!} ${(student.state.direction.name)!}
        [/@]
        [@b.col property="duration" title="学制" width="50px"/]
        [#if squadSupported]
        [@b.col property="state.squad.name" title="班级"]
          <div title="${(student.state.squad.name)!}" class="text-ellipsis">${(student.state.squad.name)!}</div>
        [/@]
        [/#if]
        [#if tutorSupported]
        [@b.col property="majorTutorNames" title="导师" width="80px" sortable="false"/]
        [/#if]
        [@b.col property="state.status.name" title="学籍状态"  width="60px"/]
        [@b.col property="studyType.name" title="学习形式" width="80px"/]
        [@b.col property="beginOn" title="入学年月" width="60px"]${(student.beginOn?string("yyyy-MM"))!}[/@]
      [/@]
    [/@]
  [/@]
<input type="hidden" id="totalNumber" value="${students.totalItems}"/>
[@b.foot/]

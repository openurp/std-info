[@b.head/]
  [@b.form name="studentListForm" action="!search"]
    [#assign widthes = {
      "user.code": 120,
      "user.name": 80,
      "person.gender.name": 50,
      "state.department.name": 115,
      "state.grade": 60,
      "state.major.name": 150,
      "duration": 50,
      "state.squad.name": 185,
      "state.status.name": 60,
      "user.mobile": 90,
      "person.code": 140,
      "studyType.name": 60,
      "beginOn": 60,
      "level.name": 60,
      "student.address": 200,
      "remark": 150
    }/]
    [#assign sumWidth = 0/]
    [#list widthes?keys as name][#assign sumWidth = sumWidth + widthes[name]/][/#list]
    [@b.grid items=students var="student" sortable="true" overflow="auto"]
      [@b.gridbar]
        bar.addItem("新增", function() {
          bg.form.submit("studentListForm", "add", "_blank");
        }, "new.png");
        bar.addItem("修改", function() {
          var stdIds = bg.input.getCheckBoxValues("student.id");
          if(stdIds=="" || stdIds==null)
            window.alert('你没有选择要操作的记录！');
          else {
            if(stdIds.indexOf(',')!=-1){alert("请仅选择一个");return;}
            bg.form.submit("studentListForm",stdIds+"/edit","_blank");
          }
        }, "update.png");
        [#--
        bar.addItem("查看修改申请", "showStdApplyEditInfo()");
         --]
      [/@]
      [@b.row]
        [@b.boxcol/]
        [@b.col property="user.code" title="学号" width=widthes["user.code"] + "px"/]
        [@b.col property="user.name" title="姓名" width=widthes["user.name"] + "px"]
          [@b.a href="!info?id=${student.id}" target="_blank"]${(student.user.name)?if_exists}[/@]
        [/@]
        [@b.col property="person.gender.name" title="性别" width=widthes["person.gender.name"] + "px"/]
        [@b.col property="state.department.name" title="院系" class="departName" width=widthes["state.department.name"] + "px"/]
        [@b.col property="state.grade" title="年级" class="stdGrade" width=widthes["state.grade"] + "px"/]
        [@b.col property="level.name" title="培养层次" width=widthes["level.name"] + "px"/]
        [@b.col property="state.major.name" title="专业" class="majorName" width=widthes["state.major.name"] + "px"/]
        [@b.col property="duration" title="学制" class="duration" width=widthes["duration"] + "px"/]
        [@b.col property="state.squad.name" title="班级" class="duration" width=widthes["state.squad.name"] + "px"/]
        [@b.col property="state.status.name" title="学籍状态" class="stateStatus" width=widthes["state.status.name"] + "px"/]
        [@b.col property="user.mobile" title="手机" class="mobile" width=widthes["user.mobile"] + "px"/]
        [@b.col property="person.code" title="证件号码" class="PersonCode" width=widthes["person.code"] + "px"/]
        [@b.col property="studyType.name" title="学习形式" class="studyType" width=widthes["studyType.name"] + "px"/]
        [@b.col property="beginOn" title="入学年月" width=widthes["beginOn"] + "px"]${(student.beginOn?string("yyyy-MM"))!}[/@]
        [@b.col title="住址" width=widthes["student.address"] + "px"/]
        [@b.col property="remark" title="备注" class="remark" width=widthes["remark"] + "px"/]
      [/@]
    [/@]
  [/@]
<input type="hidden" id="totalNumber" value="${students.totalItems}"/>
[@b.foot/]

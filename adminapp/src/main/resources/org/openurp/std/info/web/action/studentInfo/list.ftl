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
[#--					bar.addItem("修改", function() {--]
[#--					var stdIds = bg.input.getCheckBoxValues("student.id");--]
[#--					if(stdIds=="" || stdIds==null)--]
[#--					window.alert('你没有选择要操作的记录！');--]
[#--					else {--]
[#--					if(stdIds.indexOf(',')!=-1){alert("请仅选择一个");return;}--]
[#--					bg.form.submit("studentListForm",stdIds+"/edit","_blank");--]
[#--					}--]
[#--					}, "update.png");--]
[#--          bar.addItem("查看", function() {--]
[#--            var stdIds = bg.input.getCheckBoxValues("student.id");--]
[#--            if(stdIds=="" || stdIds==null)--]
[#--            window.alert('你没有选择要操作的记录！');--]
[#--            else {--]
[#--            if(stdIds.indexOf(',')!=-1){alert("请仅选择一个");return;}--]
[#--            bg.form.submit("studentListForm","viewForm?student.id="+stdIds,"_blank");--]
[#--            }--]
[#--          }, "update.png");--]
          bar.addItem("联系信息", function() {
            var stdIds = bg.input.getCheckBoxValues("student.id");
            if(stdIds=="" || stdIds==null)
            window.alert('你没有选择要操作的记录！');
            else {
            if(stdIds.indexOf(',')!=-1){alert("请仅选择一个");return;}
            bg.form.submit("studentListForm","editContact?student.id="+stdIds,"_blank");
            }
            }, "update.png");
          bar.addItem("家庭信息", function() {
            var stdIds = bg.input.getCheckBoxValues("student.id");
            if(stdIds=="" || stdIds==null)
            window.alert('你没有选择要操作的记录！');
            else {
            if(stdIds.indexOf(',')!=-1){alert("请仅选择一个");return;}
            bg.form.submit("studentListForm","editHome?student.id="+stdIds,"_blank");
            }
            }, "update.png");
          bar.addItem("考生信息", function() {
            var stdIds = bg.input.getCheckBoxValues("student.id");
            if(stdIds=="" || stdIds==null)
            window.alert('你没有选择要操作的记录！');
            else {
            if(stdIds.indexOf(',')!=-1){alert("请仅选择一个");return;}
            bg.form.submit("studentListForm","editExaminee?student.id="+stdIds,"_blank");
            }
            }, "update.png");
        [/@]
        [@b.row]
            [@b.boxcol width="30px"/]
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
        [/@]
    [/@]
[/@]
<input type="hidden" id="totalNumber" value="${students.totalItems}"/>
[@b.foot/]

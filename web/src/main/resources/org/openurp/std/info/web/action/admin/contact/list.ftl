[@b.head/]
  [#assign widthes = {
    "code": 120,
    "name": 80,
    "gender.name": 50,
    "state.department.name": 115,
    "state.grade": 60,
    "state.major.name": 150,
    "duration": 50,
    "state.squad.name": 185,
    "state.status.name": 60,
    "person.code": 140,
    "studyType.name": 60,
    "beginOn": 60,
    "level.name": 60,
    "eduType.name": 60,
    "tutor.name":80
  }/]
[@b.form name="studentListForm" action="!search"]
    [@b.grid items=students var="student" sortable="true" overflow="auto"]
      [@b.gridbar]
        bar.addItem("修改", action.edit());
      [/@]
      [@b.row]
        [@b.boxcol/]
        [@b.col property="code" title="学号" width="120px"/]
        [@b.col property="name" title="姓名" width="90px"]
          [@b.a href="!info?id=${student.id}" target="_blank"]${(student.name)?if_exists}[/@]
        [/@]
        [@b.col property="gender.name" title="性别" width="60px"/]
        [@b.col property="state.grade" title="年级" width="60px"/]
        [@b.col property="level.name" title="培养层次" width="70px"/]
        [@b.col property="state.department.name" title="院系"  /]
        [@b.col property="state.major.name" title="专业" width="160px"]
          ${(student.state.major.name)!}
        [/@]
        [@b.col title="移动电话" width="100px" ]${(contactMap.get(student).mobile)!}[/@]
        [@b.col property="state.status.name" title="学籍状态" width="80px"/]
      [/@]
    [/@]
[/@]
<input type="hidden" id="totalNumber" value="${students.totalItems}"/>
[@b.foot/]

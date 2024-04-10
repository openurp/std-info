[@b.head/]
[@b.form name="studentListForm" action="!search"]
  [@b.grid items=students var="student" sortable="true" overflow="auto"]
    [@b.gridbar]
      bar.addItem("修改", action.edit());
    [/@]
    [@b.row]
      [@b.boxcol/]
      [@b.col property="code" title="学号" width="120px"/]
      [@b.col property="name" title="姓名" width="90px"]
        <div class="text-ellipsis" title="${student.name}">
          [@b.a href="student!info?id=${student.id}" target="_blank"]${student.name}[/@]
        </div>
      [/@]
      [@b.col property="gender.name" title="性别" width="60px"/]
      [@b.col property="state.grade" title="年级" width="60px"/]
      [@b.col property="level.name" title="培养层次" width="70px"/]
      [@b.col property="state.department.name" title="院系" width="100px"]
        ${student.department.shortName!student.department.name}
      [/@]
      [@b.col property="state.major.name" title="专业" width="160px"]
        ${(student.state.major.name)!}
      [/@]
      [@b.col title="移动电话" width="100px" ]${(contactMap.get(student).mobile)!}[/@]
      [@b.col title="家庭电话" width="100px" ]${(homeMap.get(student).phone)!}[/@]
      [@b.col title="家庭地址" ]${(homeMap.get(student).address)!}[/@]
      [@b.col property="state.status.name" title="学籍状态" width="80px"/]
    [/@]
  [/@]
[/@]
<input type="hidden" id="totalNumber" value="${students.totalItems}"/>
[@b.foot/]

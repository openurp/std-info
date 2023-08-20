[@b.head/]
<style>
.limit_line {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
  [@b.form name="studentListForm" action="!search"]
    [@b.grid items=students var="student" sortable="true"]
      [@b.row]
        [@b.boxcol/]
        [@b.col property="code" title="学号" width="120px"/]
        [@b.col property="name" title="姓名" width="80px"]
          [@b.a href="!info?id=${student.id}" target="_blank"]<div title="${student.name}" class="limit_line">${student.name}</div>[/@]
        [/@]
        [@b.col property="gender.name" title="性别" width="50px"/]
        [@b.col property="state.grade" title="年级" width="60px"/]
        [@b.col property="level.name" title="培养层次" width="60px"/]
        [@b.col property="eduType.name" title="培养类型" width="60px"/]
        [@b.col property="state.department.name" title="院系" width="100px"]
          ${student.state.department.shortName!student.state.department.name}
        [/@]
        [@b.col property="state.major.name" title="专业与方向"]
          ${(student.state.major.name)!} ${(student.state.direction.name)!}
        [/@]
        [@b.col property="duration" title="学制" width="50px"/]
        [#if squadSupported]
        [@b.col property="state.squad.name" title="班级"/]
        [/#if]
        [#if tutorSupported]
        [@b.col property="tutor.name" title="导师" width="80px"/]
        [/#if]
        [@b.col property="state.status.name" title="学籍状态"  width="60px"/]
        [@b.col property="studyType.name" title="学习形式" width="60px"/]
        [@b.col property="beginOn" title="入学年月" width="60px"]${(student.beginOn?string("yyyy-MM"))!}[/@]
      [/@]
    [/@]
  [/@]
[@b.foot/]

[#ftl]
<link rel="stylesheet" type="text/css" href="static/css/ext-like-table.css" />
[@b.form name="preBindForm" target="contentDiv" title="预览" action="!save" theme="html"]
<table width="100%" class="extTable">
  <caption class="normal">
    班级学生方向更新预览
    &nbsp;&nbsp;<input type="button" value="保存" onClick="bg.form.submit('preBindForm')"/>
    <input type="hidden" name="params" value="${Parameters['params']!}"/>
  </caption>
  <thead>
    <tr>
      <th>
        ${b.text("attr.stdNo")}
      </th>
      <th>
        ${b.text("attr.personName")}
      </th>
      <th>
        性别
      </th>
      <th>
        ${b.text("std.state.grade")}
      </th>
      <th>
        ${b.text("entity.studentType")}
      </th>
      <th>
        ${b.text("entity.EducationLevel")}
      </th>
      <th>
        管理院系
      </th>
      <th>
        ${b.text("entity.major")}
      </th>
      <th>
        方向
      </th>
      <th>
        培养计划
      </th>
    </tr>
  </thead>
  <tbody>
    [#list students?sort_by("code") as student]
    <tr>
      <td>
        ${(student.user.code)!}
        <input type="hidden" value="${student.id}" name="student.id"/>
        <input type="hidden" value="${(student.state.direction.id)!}" name="student.state.direction.id${student.id}"/>
      </td>
      <td>
        ${(student.user.name)!}
      </td>
      <td>
        ${(student.person.gender.name)!}
      </td>
      <td>
        ${(student.state.grade?html)!}
      </td>
      <td>
        ${(student.stdType.name?html)!}
      </td>
      <td>
        ${(student.level.name?html)!}
      </td>
      <td>
        ${(student.state.department.name?html)!}
      </td>
      <td>
        ${(student.state.major.name?html)!}
      </td>
      <td>
        ${(student.state.direction.name?html)!("--")}
      </td>
      [#if studentProgramMap.get(student)?? && studentProgramMap.get(student).size()>1]
        [@b.select items=studentProgramMap.get(student) name="student.program.id${student.id}" empty="..."/]
      [#elseif studentProgramMap.get(student)?? && studentProgramMap.get(student).size()==1]
        <td id="std${student.id}ProgramTd">
          ${(studentProgramMap.get(student).get(0).name)!("未绑定")}
        </td>
        <input type="hidden" id="student.program.id${student.id}" name="student.program.id${student.id}" value="${(studentProgramMap.get(student).get(0).id)!}"/>
      [#else]
        <td id="std${student.id}ProgramTd">
          未找到匹配计划
        </td>
      [/#if]
    </tr>
    [/#list]
  </tbody>
</table>
[/@]

[#ftl]
[@b.head/]
<link rel="stylesheet" type="text/css" href="static/css/ext-like-table.css" />
<script language="JavaScript" type="text/JavaScript" src='${base}/dwr/interface/projectMajorDwr.js'></script>
<script language="JavaScript" type="text/JavaScript" src='${base}/dwr/engine.js'></script>
[@b.toolbar title="${squad.name} 学生方向修改"]
  bar.addItem("预览","bg.form.submit(document.batchBindDirectionForm)");
  bar.addBack();
[/@]
[@b.form name="batchBindDirectionForm" target="contentDiv" title="班级学生方向修改" action="!preBindProgram" theme="html"]
  <input type="hidden" name="params" value="${Parameters['params']!}"/>
  <table width="100%" class="extTable">
    <caption class="normal">
      批量设置
    </caption>
    <thead>
      <tr>
        <th colSpan="9">
          学生信息
        </th>
        <th>
          [@b.select id ="total_direction" name="total_direction" items=directions empty="批量设置..."/]
        </th>
      </tr>
      <tr>
        <th>
          学号
        </th>
        <th>
          姓名
        </th>
        <th>
          性别
        </th>
        <th>
          年级
        </th>
        <th>
          学生类别
        </th>
        <th>
          培养层次
        </th>
        <th>
          管理院系
        </th>
        <th>
          专业
        </th>
        <th>
          方向(现)
        </th>
        <th>
          方向(新)
        </th>
      </tr>
    </thead>
    <tbody>
      [#list squad.students?sort_by("code") as student]
        <tr>
          <td><input type="hidden" value="${student.id}" name="student.id"/>${student.user.code}</td>
          <td>${student.user.name}</td>
          <td>${student.person.gender.name}</td>
          <td>${student.state.grade}</td>
          <td>${student.stdType.name}</td>
          <td>${student.level.name}</td>
          <td>${student.state.department.name}</td>
          <td>${student.state.major.name}</td>
          <td>${(student.state.direction.name)!('--')}</td>
          <td>
            <select style="width:90%" name="student.state.direction.id${student.id}" class="new_directions">
              <option value="">...</option>
              [#list student.state.major.directions?sort_by("name") as direction]
                <option value="${direction.id}" [#if (student.state.direction)?? && student.state.direction=direction]selected[/#if]>${direction.name}</option>
              [/#list]
            </select>
          </td>
        </tr>
      [/#list]
    </tbody>
  </table>
[/@]
<script language="JavaScript">
  jQuery(document).ready(function(){
    jQuery("#total_direction").change(function(){
      jQuery(".new_directions").val(jQuery(this).val());
    })
  })
</script>
[@b.foot/]

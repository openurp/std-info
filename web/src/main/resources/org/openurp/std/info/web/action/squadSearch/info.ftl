[#ftl/]
[@b.head/]
[@b.toolbar title="班级信息"]bar.addBack();[/@]
<table class="formTable" width="60%" align="center">
  <tr><td align="center" colspan="4" class="index_view"><b>班级基本信息</b></td></tr>
  <tr>
    <td class="title" width="20%">班级名称:</td>
    <td class="brightStyle" width="30%">${(squad.name)!}</td>
    <td class="title" width="20%">班级代码:</td>
    <td class="brightStyle" width="30%">${(squad.code)!}</td>
  </tr>
  <tr>
    <td class="title">院系:</td>
    <td>${(squad.department.name)!}</td>
    <td class="title">学生类别:</td>
    <td>${(squad.stdType.name)!}</td>
  </tr>
  <tr>
    <td class="title">专业:</td>
    <td>${(squad.major.name)!}</td>
    <td class="title">方向:</td>
    <td>${(squad.direction.name)!}</td>
  </tr>
  <tr>
    <td class="title">计划人数:</td>
    <td>${(squad.planCount)!}</td>
    <td class="title">实际人数:</td>
    <td>${(squad.stdCount)!}</td>
  </tr>
  [#assign inSchoolCount = 0 /]
  [#assign inRegisterCount = 0 /]
  [#list students! as student]
    [#if (student.state.inschool)?default(false)]
      [#assign inSchoolCount = inSchoolCount + 1 /]
    [/#if]
    [#if (student.state)?? && student.registed]
      [#assign inRegisterCount = inRegisterCount + 1 /]
    [/#if]
  [/#list]
  <tr>
    <td class="title">在校人数:</td>
    <td>${inSchoolCount}</td>
    <td class="title">在籍人数:</td>
    <td>${inRegisterCount}</td>
  </tr>
  <tr>
    <td class="title">生效日期:</td>
    <td>${squad.beginOn?string('yyyy-MM-dd')}</td>
    <td class="title">失效日期:</td>
    <td>${(squad.endOn?string('yyyy-MM-dd'))!}</td>
  </tr>
  <tr>
    <td class="title">维护日期:</td>
    <td>${(squad.updatedAt?string('yyyy-MM-dd'))!}</td>
    <td class="title"></td>
    <td></td>
  </tr>
</table>
<div style="width:60%;margin-left:auto;margin-right:auto;background-color:#E1ECFF;text-align:center">
  <b>班级学生列表</b>
</div>
[#--]
<div style="width:60%;margin-left:auto;margin-right:auto">
  [@b.grid items=students var="student" sortable="true"]
        [@b.row]
      [@b.col property="name" title="姓名" width="15%"]
            ${(student.name)!}
          [/@]
      [@b.col property="code" title="学号" ]
        <a href="studentSearch!info.action?studentId=${(student.id)!}" target="_blank" title="查看学生详细信息">${(student.user.code)!}</a>
      [/@]
      [@b.col property="gender.name" title="性别" ]
        ${(student.gender.name)!}
      [/@]
      [@b.col property="department.name" title="院系" ]
        ${(student.department.name)!}
      [/@]
      [@b.col property="type.name" title="学生类别" ]
        ${(student.type.name)!}
      [/@]
      [@b.col property="registed" title="是否有学籍" ]
        ${((student.registed)?string("是","否"))!}
      [/@]
      [/@]
  [/@]
</div>
[--]
  <div style="width:60%;margin-left:auto;margin-right:auto">
    [#list (students?sort_by("code"))?if_exists as student]
      [#if student_index % 3 == 0]
    <table align="center" width="100%" style="border:1px solid #A6C9E2;">
      <tr>
      [/#if]
        <td style="background-color:#e8eefa;"[#if (student_index % 3) lt 2] width="${ 100 / 3 }%"[/#if]>
          <table width="100%">
              <tr>
                <td rowspan="3" width="80px">[@eams.avatar user= student.user width="40px" height="55px"/]</td>
                <td><a href="#" onClick="infoStd(${(student.id)!})"  title="查看学生详细信息">${(student.user.code)!}</a></td>
              </tr>
              <tr>
                 <td>${(student.name)!}<span style="padding-right: 5px"></span>${(student.gender.name)!}<br>${(student.state.inschool)?default(false)?string("在校", "<font color=\"red\">" + student.state.status.name + "</font>")}</td>
              </tr>
          </table>
        </td>
      [#if student_index % 3 == 2 || !student_has_next]
        [#if !student_has_next && (student_index % 3) lt 2]
          [#list (student_index % 3) .. 1 as i]
          <td style="background-color:#e8eefa;" width="${ 100 / 3 }%">
            <table width="100%">
              <tr>
                <td></td>
                <td></td>
              </tr>
              <tr>
                <td></td>
                <td></td>
              </tr>
            </table>
          </td>
          [/#list]
        [/#if]
      </tr>
    </table>
      [/#if]
    [/#list]
    [#if (students?size)?default(0) == 0]
    <div align="center" style="color:#666666;background:#E1ECFF;"><b>该班级没有学生!</b></div>
    [/#if]
  </div>
<script>
  function infoStd(stdId){
    bg.Go("${base}/studentInfo!info.action?studentId="+stdId,"_blank");
  }
</script>
[@b.foot /]

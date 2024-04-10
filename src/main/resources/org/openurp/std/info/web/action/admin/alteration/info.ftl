[#ftl]
[@b.head/]
  [@b.toolbar title="查看学籍异动明细"]
    bar.addBack();
  [/@]
<div class="card card-info card-outline">
  <div class="card-header">
    <h3 class="card-title">学籍异动详细信息</h3>
  </div>
  <table class="infoTable" width="100%">
    <tr>
      <td style="width:120px" class="title">学号：</td>
      <td>[@b.a href="student!info?id="+stdAlteration.std.id target="_blank"]${stdAlteration.std.code}[/@]</td>
      <td style="width:120px" class="title">年级：</td>
      <td>${(stdAlteration.std.state.grade.code)?if_exists}</td>
      <td class="title">培养层次：</td>
      <td>${stdAlteration.std.level.name}</td>
    </tr>
    <tr>
      <td class="title">姓名：</td>
      <td>${(stdAlteration.std.name)?if_exists}</td>
      <td class="title">学年学期：</td>
      <td>${(stdAlteration.semester.schoolYear)!}学年度${(stdAlteration.semester.name)!}学期</td>
      <td class="title">变动日期：</td>
      <td>${(stdAlteration.alterOn)?string("yyyy-MM-dd")?if_exists}</td>
    </tr>
    <tr>
      <td class="title">院系：</td>
      <td>${(stdAlteration.std.state.department.name)?if_exists}</td>
      <td class="title">专业和方向：</td>
      <td>${(stdAlteration.std.state.major.name)?if_exists} ${(stdAlteration.std.state.direction.name)?if_exists}</td>
      <td class="title">班级：</td>
      <td>${(stdAlteration.std.state.squad.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">异动类型：</td>
      <td>${(stdAlteration.alterType.name)?if_exists}</td>
      <td class="title">异动原因：</td>
      <td>${(stdAlteration.reason.name)?if_exists}</td>
      <td class="title">操作时间：</td>
      <td>${(stdAlteration.updatedAt?string("yyyy-MM-dd HH:mm"))!}</td>
    </tr>
    <tr>
      <td class="title" >变动内容：</td>
      <td colspan="3">
        <ul style="padding-left: 15px;">
          [#list stdAlteration.items as item]
          <li>${item.meta}:&nbsp;&nbsp;${item.oldtext!'--'} --> ${item.newtext!'--'}</li>
          [/#list]
        </ul>
      </td>
      <td class="title">备注：</td>
      <td>${(stdAlteration.remark)?if_exists?html}</td>
    </tr>
  </table>
</div>

[@b.foot/]

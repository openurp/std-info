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
    </tr>
    <tr>
      <td class="title">姓名：</td>
      <td>${(stdAlteration.std.name)?if_exists}</td>
      <td class="title">院系：</td>
      <td>${(stdAlteration.std.state.department.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">学年学期：</td>
      <td>${(stdAlteration.semester.schoolYear)!}学年度${(stdAlteration.semester.name)!}学期</td>
      <td class="title">专业和方向：</td>
      <td>${(stdAlteration.std.state.major.name)?if_exists} ${(stdAlteration.std.state.direction.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">生效日期：</td>
      <td>${(stdAlteration.beginOn)?string("yyyy-MM-dd")?if_exists}</td>
      <td class="title">截止日期：</td>
      <td>${(stdAlteration.endOn?string("yyyy-MM-dd"))?if_exists}</td>
    </tr>
    <tr>
      <td class="title">异动类型：</td>
      <td>${(stdAlteration.alterType.name)?if_exists}</td>
      <td class="title">异动原因：</td>
      <td>${(stdAlteration.reason.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title" style="vertical-align:top">备注：</td>
      <td>${(stdAlteration.remark)?if_exists?html}</td>
      <td class="title">操作时间：</td>
      <td>${(stdAlteration.updatedAt?string("yyyy-MM-dd HH:mm"))!}</td>
    </tr>
  </table>
  <table class="infoTable" width="100%">
    <tr>
      <th colspan="3">学籍异动项详细信息</th>
    </tr>
    <tr>
      <td class="title" width="20%" style="font-weight: bold">变更项</td>
      <td width="40%" style="text-align:center; font-weight: bold">变更前</td>
      <td width="40%" style="text-align:center; font-weight: bold">变更后</td>
    </tr>

    [#assign Names={'Grade':'年级','Department':'院系','Major':'专业','Direction':'方向','Squad':'班级','Inschool':'是否在校','Status':'学籍状态','Campus':'校区','GraduateOn':'预计毕业日期'}/]
    [#list stdAlteration.items as item]
    <tr>
      <td class="title">${Names[item.meta?string]}：</td>
      <td align="center">[#if item.oldtext??]${item.oldtext}[/#if]</td>
      <td align="center">[#if item.newtext??]${item.newtext}[/#if]</td>
    </tr>
    [/#list]
  </table>

</div>

[@b.foot/]

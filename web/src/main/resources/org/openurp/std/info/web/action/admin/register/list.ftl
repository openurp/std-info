[#ftl]
[@b.head/]
  [@b.grid items=registers var="register"]
    [@b.gridbar]
      function exportData(){
        var form = document.searchForm;
        bg.form.addInput(form, "keys", "std.code,std.name,std.gender.name,std.state.grade.code,std.state.department.name,std.state.major.name,std.state.status.name,registerAt");
        bg.form.addInput(form, "titles", "学号,姓名,性别,年级,院系,专业,状态,注册时间");
        bg.form.addInput(form, "fileName", "学生学期注册名单");
        bg.form.submit(form, "${b.url('!exportData')}","_self");
      }
    [/@]
    [@b.row]
      [@b.boxcol/]
      [@b.col title="学号" property="std.code" width="15%"/]
      [@b.col title="姓名" property="std.name" width="10%"]
        ${register.std.name}
      [/@]
      [@b.col title="年级" property="std.state.grade" width="10%"/]
      [@b.col title="院系" property="std.state.department.name"]
        ${(register.std.state.department.shortName)!register.std.state.department.name}
      [/@]
      [@b.col title="专业(方向)" property="std.state.major.name"]
      <span style="font-size:0.8em">${(register.std.state.major.name)!} ${(register.std.state.direction.name)!}</span>
      [/@]
      [@b.col title="学籍状态" property="std.state.status.name" width="10%"/]
      [@b.col title="注册状态" width="15%"]
        [#if !(register.registered!false)]
          [#if register.unregisteredReason??]
            ${register.unregisteredReason.name}
          [#else]
            [#if !(register.checkin!false)]未报到[#if register.uncheckinReason??](${register.uncheckinReason.name})[/#if]&nbsp;[/#if]
            [#if !(register.tuitionPaid!false)]欠费[/#if]
          [/#if]
        [#else]
           已注册
        [/#if]
      [/@]
      [@b.col title="注册日期" width="10%" property="registerAt"]
        ${(register.registerAt?string("yyyy-MM-dd"))!}
      [/@]
    [/@]
  [/@]
[@b.foot/]

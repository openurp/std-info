[#ftl]
[@b.head/]
[#include "../student/nav.ftl" /]
[@b.toolbar title="学籍日志"]
  //bar.addHelp("${b.text("action.help")}");
[/@]
<div class="search-container">
  <div class="search-panel">
      [@b.form name="stdLogIndexForm" action="!search" title="ui.searchForm" target="contentDiv" theme="search"]
             [#--@b.textfields style="width:130px" names="stdLog.student.user.code;${b.text('attr.stdNo')},stdLog.user.name;操作用户"/--]
             [@b.textfields style="width:126px" names="stdLog.user.name;操作人,stdLog.student.user.code;被操作学生学号,stdLog.student.user.name;被操作学生姓名"/]
             [@b.datepicker label="生成时间从" id="startTime" name="startTime" value="" style="width:130px"  format="yyyy-MM-dd HH:mm" maxDate="#F{$dp.$D(\\'endTime\\')}" readOnly="readOnly"/]
        [@b.datepicker label="至" id="endTime" name="endTime" value="" style="width:130px" format="yyyy-MM-dd HH:mm" minDate="#F{$dp.$D(\\'startTime\\')}" readOnly="readOnly"/]
      [/@]
  </div>
  <div class="search-list">
        [@b.div id="contentDiv" href="!search" /]
  </div>
</div>
[@b.foot/]

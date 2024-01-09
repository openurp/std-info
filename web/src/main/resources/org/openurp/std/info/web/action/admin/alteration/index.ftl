[#ftl]
[@b.head/]
[@b.toolbar title="学籍异动维护"]
  bar.addItem("异动配置","openConfig()");
  function openConfig(){
     window.open("${b.url('alter-config')}");
  }
[/@]

<div class="search-container">
  <div class="search-panel">
    [@b.form name="stdAlterIndexForm" action="!search" title="ui.searchForm" target="contentDiv" theme="search"]
       [@base.semester label="学年学期" name="stdAlteration.semester.id" value=currentSemester empty="..." required="false"/]
       [@b.textfields names="stdAlteration.std.code;学号,stdAlteration.std.name;姓名,stdAlteration.std.state.grade.code;年级" maxlength="25"/]
       [@b.select name="stdAlteration.std.level.id" label="培养层次" items=levels empty="..."/]
       [@b.select name="stdAlteration.std.state.department.id" label="院系" items=departments empty="..."/]
       [@b.select name="stdAlteration.std.state.major.id" label="专业" items=majors empty="..."/]
       [@b.select label="异动类型" name="stdAlteration.alterType.id" items=modes empty="..." /]
       [@b.select label="异动原因" name="stdAlteration.reason.id" items=reasons empty="..." /]
       [@b.date label="变动从" id="alterFromDate" name="alterFromDate" value=""  format="yyyy-MM-dd" maxDate="#F{$dp.$D(\\'alterToDate\\')}" readOnly="readOnly"/]
       [@b.date label="至" id="alterToDate" name="alterToDate" value="" format="yyyy-MM-dd" minDate="#F{$dp.$D(\\'alterFromDate\\')}" readOnly="readOnly"/]
       [@b.select label="变动项目" name="meta.id" items=metas value="" empty="..." /]
    [/@]
  </div>
  <div class="search-list">
    [@b.div id="contentDiv" href="!search?stdAlteration.semester.id=${currentSemester.id}" /]
  </div>
</div>
[@b.foot/]

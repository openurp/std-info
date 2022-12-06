[#ftl]
[@b.head/]
<div class="search-container">
  <div class="search-panel">
    [@b.form name="stdAlterIndexForm" action="!search" title="ui.searchForm" target="contentDiv" theme="search"]
       [@urp_base.semester label="学年学期"name="stdAlteration.semester.id" value=currentSemester empty="..."/]
       [@b.textfields names="stdAlteration.std.code;学号,stdAlteration.std.name;姓名,stdAlteration.std.state.grade.code;年级" maxlength="25"/]
       [@b.select label="异动类型" name="stdAlteration.alterType.id" items=modes empty="..." /]
       [@b.select label="异动原因" name="stdAlteration.reason.id" items=reasons empty="..." /]
       [@b.datepicker label="生效从" id="alterFromDate" name="alterFromDate" value=""  format="yyyy-MM-dd" maxDate="#F{$dp.$D(\\'alterToDate\\')}" readOnly="readOnly"/]
       [@b.datepicker label="至" id="alterToDate" name="alterToDate" value="" format="yyyy-MM-dd" minDate="#F{$dp.$D(\\'alterFromDate\\')}" readOnly="readOnly"/]
       [@b.datepicker label="入学从" id="enrollFrom" name="enrollFrom" value=""  format="yyyy-MM-dd" maxDate="#F{$dp.$D(\\'enrollTo\\')}" readOnly="readOnly"/]
       [@b.datepicker label="至" id="enrollTo" name="enrollTo" value="" format="yyyy-MM-dd" minDate="#F{$dp.$D(\\'enrollFrom\\')}" readOnly="readOnly"/]
    [/@]
  </div>
  <div class="search-list">
    [@b.div id="contentDiv" href="!search?stdAlteration.semester.id=${currentSemester.id}" /]
  </div>
</div>
[@b.foot/]

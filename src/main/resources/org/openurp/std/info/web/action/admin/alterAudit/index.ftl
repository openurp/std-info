[#ftl]
[@b.head/]
[#include "../alterApply/alter-nav.ftl"/]

<div class="search-container">
  <div class="search-panel">
    [@b.form name="stdAlterIndexForm" action="!search" title="ui.searchForm" target="contentDiv" theme="search"]
       [@b.textfields names="stdAlterApply.std.code;学号,stdAlterApply.std.name;姓名,stdAlterApply.std.state.grade.code;年级" maxlength="25"/]
       [@b.select name="stdAlterApply.std.level.id" label="培养层次" items=levels empty="..."/]
       [@b.select name="stdAlterApply.std.state.department.id" label="院系" items=departments empty="..."/]
       [@b.select name="stdAlterApply.std.state.major.id" label="专业" items=majors empty="..."/]
       [@b.select label="异动类型" name="stdAlterApply.alterType.id" items=modes empty="..." /]
       <input type="hidden" name="orderBy" value="stdAlterApply.applyAt desc" />
    [/@]
  </div>
  <div class="search-list">
    [@b.div id="contentDiv" href="!search?orderBy=stdAlterApply.applyAt desc" /]
  </div>
</div>
[@b.foot/]

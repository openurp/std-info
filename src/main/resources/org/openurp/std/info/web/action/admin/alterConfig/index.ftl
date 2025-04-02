[#ftl]
[@b.head/]
<div class="search-container">
  <div class="search-panel">
    [@b.form name="stdAlterTypeForm" action="!search" title="ui.searchForm" target="contentDiv" theme="search"]
       [@b.textfields names="alterConfig.alterType.name;名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称" maxlength="25"/]
       [@b.select label="是否在校" name="alterConfig.inschool" items={'1':'是','0':'否'} empty="...." /]
       [@b.select label="学籍状态" name="alterConfig.status.id" items=statuses empty="...." /]
    [/@]
  </div>
  <div class="search-list">
    [@b.div id="contentDiv" href="!search" /]
  </div>
</div>
[@b.foot/]

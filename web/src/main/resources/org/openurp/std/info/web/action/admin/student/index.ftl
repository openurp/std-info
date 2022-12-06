[@b.head/]
[@b.toolbar title='学籍管理维护' id='studentBar']
  bar.addItem("新学籍导入", function() {
    bg.Go("${b.url('!importForm')}", "_blank");
  });
[/@]
<div class="search-container">
    <div class="search-panel">
      [@b.form name="studentSearchForm" id="studentSearchForm" action="!search" title="ui.searchForm" target="studentList"]
        [#include "searchForm.ftl"/]
      [/@]
    </div>
    <div class="search-list">[@b.div id="studentList"/]</div>
</div>
  <script language="javascript">
    function selectExport() {
      jQuery.colorbox({transition:'none', title:"选择字段导出", overlayClose:false, width:"820px", height:"550px", inline:true, "href":"#selectColumnExport"});
    }
  </script>
[@b.foot/]

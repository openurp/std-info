[@b.head/]
[@b.toolbar title='预计毕业信息' ]
  bar.addItem("信息核对结果","checklist()")
  function checklist(){
    bg.form.submit(document.checkListform);
  }
[/@]
[@b.form name="checkListform" action="person-check"/]
<div class="search-container">
    <div class="search-panel">
      [@b.form name="studentSearchForm" id="studentSearchForm" action="!search" title="ui.searchForm" target="studentList"]
        [#include "searchForm.ftl"/]
      [/@]
    </div>
    <div class="search-list">[@b.div id="studentList"/]</div>
</div>
[@b.foot/]

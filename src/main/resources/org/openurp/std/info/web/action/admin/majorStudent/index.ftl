[#ftl]
[@b.head/]
[@b.toolbar title="主修信息维护"/]
<div class="search-container">
    <div class="search-panel">
        [@b.form name="majorStudentSearchForm" action="!search" target="majorStudentlist" title="ui.searchForm" theme="search"]
            [@b.textfields names="majorStudent.std.code;学号"/]
            [@b.textfields names="majorStudent.std.name;姓名"/]
            [@b.select style="width:100px" name="majorStudent.school.id" label="主修学校" items=schools option="id,name" empty="..." /]
            <input type="hidden" name="orderBy" value="majorStudent.std.code"/>
        [/@]
    </div>
    <div class="search-list">[@b.div id="majorStudentlist" href="!search?orderBy=majorStudent.std.code asc"/]
  </div>
</div>
[@b.foot/]

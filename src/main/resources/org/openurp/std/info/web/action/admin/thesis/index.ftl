[@b.head/]
[@b.toolbar title='学生论文信息']
[/@]
<div class="search-container">
    <div class="search-panel">
      [@b.form name="searchForm" action="!search" title="ui.searchForm" target="checkList" theme="search"]
        [@b.select name="season.id" label="毕业界别" items=seasons required="true"/]
        [@b.textfield name="thesis.std.code" label="学号"/]
        [@b.textfield name="thesis.std.name" label="姓名"/]
        [@b.textfield name="thesis.advisor" label="教师姓名"/]
        [@b.select name="thesis.std.state.department.id" label="院系" items=departs/]
        [@b.textfield name="thesis.std.state.squad.name" label="班级"/]
        [@b.textfield name="thesis.title" label="论文题目"/]
        [@b.textfield name="thesis.language.name" label="撰写语言"/]
        [@b.textfield name="thesis.keywords" label="关键词"/]
        [@b.textfield name="thesis.researchField" label="研究领域"/]
      [/@]
      <script>
        $(document).ready(function() {
          bg.form.submit("searchForm");
        });
      </script>
    </div>
    <div class="search-list">[@b.div id="checkList"/]</div>
</div>
[@b.foot/]

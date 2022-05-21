[#ftl/]
[@b.head/]
[@b.toolbar title="班级查询"/]
<div class="search-container">
  <div class="search-panel">
        [@b.form theme="search" action="squadSearch!search" title="ui.searchForm" target="squadListFrame" name="squadSearchForm"]
            [@b.textfield name="squad.code" label="班级代码" style="width:100px"  maxlength="10"/]
            [@b.textfield name="squad.name" label="班级名称" style="width:100px" maxlength="20"/]
            [#include "/template/major3Select.ftl"/]
      [@majorSelect id="s1" projectId="squad.project.id" levelId="squad.level.id" departId="squad.department.id" majorId="squad.major.id" directionId="squad.direction.id" stdTypeId="squad.stdType.id"/]
    [/@]
  </div>
  <div class="search-list">
      [@b.div id="squadListFrame" /]
  </div>
</div>

<script type="text/javascript">
  jQuery(function() {
    bg.form.submit(document.squadSearchForm);
  });
</script>
[@b.foot/]

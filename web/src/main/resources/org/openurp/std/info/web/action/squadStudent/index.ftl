[#ftl/]
[@b.head/]
<script src="${base}/static/scripts/common.js?v=2"></script>
[@b.toolbar title="班级学生维护"][/@]
<div class="search-container">
  <div class="search-panel">
        [@b.form theme="search" action="squadStudent!search" title="ui.searchForm" target="squadStudentDiv" name="squadStudentSearchForm"]
            [@b.textfield name="squad.code" label="班级代码" style="width:100px"  maxlength="10"/]
            [@b.textfield name="squad.name" label="班级名称" style="width:100px" maxlength="20"/]
            [#include "/template/major3Select.ftl"/]
      [@majorSelect id="s1" projectId="squad.project.id" levelId="squad.level.id" departId="squad.department.id" majorId="squad.major.id" directionId="squad.direction.id" stdTypeId="squad.stdType.id"/]
    [/@]
  </div>
  <div class="search-list">
            [@b.div id="squadStudentDiv" /]
  </div>
</div>

<script type="text/javascript">
  jQuery(function() {
    bg.form.submit(document.squadStudentSearchForm);
  });
</script>
[@b.foot/]

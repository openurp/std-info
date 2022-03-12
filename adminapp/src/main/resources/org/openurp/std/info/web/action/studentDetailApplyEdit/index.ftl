[#ftl]
[@b.head/]
[@b.toolbar title="学生修改资料申请列表"/]
<div class="search-container">
  <div class="search-panel">
      [@b.form name="studentDetailApplyEditForm" action="!search" title="ui.searchForm" target="contentDiv" theme="search"]
        <input type="hidden" name="projectId" value="${projectContext.project.id}" />
             [@b.select label="状态" name="auditType" items={'0':'待审核','1':'已通过','2':'已打回'} value=auditType?if_exists/]
      [/@]
  </div>
  <div class="search-list">
        [@b.div id="contentDiv"/]
  </div>
</div>
<script>
  jQuery(function(){
    bg.form.submit(document.studentDetailApplyEditForm);
  });
</script>
[@b.foot/]

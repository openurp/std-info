[#ftl]
[@b.head/]
[#include "/template/major3Select.ftl"/]
<script language="JavaScript" type="text/JavaScript" src='${base}/dwr/interface/projectMajorDwr.js'></script>
<script language="JavaScript" type="text/JavaScript" src='${base}/dwr/engine.js'></script>
<div class="search-container">
  <div class="search-panel">
    [@b.form name="studentBindDirection" action="!search" title="ui.searchForm" target="contentDiv" theme="search"]
           [@b.textfield name="squad.grade" label="年级" style="width:100px"  maxlength="10"/]
            [@b.textfield name="squad.code" label="班级代码" style="width:100px"  maxlength="10"/]
            [@b.textfield name="squad.name" label="班级名称" style="width:100px" maxlength="20"/]
            [@b.textfield name="teacherName" id="teacherName" label="班导师名称" style="width:100px" maxlength="20"/]
      [@majorSelect id="s1" projectId="squad.project.id" levelId="squad.level.id" departId="squad.department.id" majorId="squad.major.id" directionId="squad.direction.id" /]
      [@b.select name="fake.squad.valid" label='是否有效' items={'1' : '有效', '0' : '无效'} /]
    [/@]
  </div>
  <div class="search-list">
      [@b.div id="contentDiv" href="!search" /]
  </div>
</div>
[@b.foot/]

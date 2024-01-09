[#ftl]
[@b.head/]
[@b.form name="indexForm" action="" /]
[@b.toolbar title="招生信息"]
  bar.addItem("统计", "stat()");

  function stat() {
    bg.form.submit(document.indexForm,  "${b.url("enrollStat")}", "_blank");
  }
[/@]
<div class="search-container">
  <div class="search-panel">
      [@b.form theme="search" name="searchForm" action="!search" title="查询条件" target="contentDiv" ]
        [@b.textfield name="admission.std.code" label="attr.stdNo" /]
        [@b.textfield name="admission.std.name" label="attr.personName" /]
        [@b.textfield name="admission.std.state.grade" label="std.state.grade" /]
        [@b.date label="录取年月" name="admission.enrollOn" value="" format="yyyy-MM-dd" readOnly="readOnly"/]
        [@b.select label="录取专业" name="admission.major.id" items=majors id="majorId" empty="..."/]
        [@b.select label="录取院系" name="admission.department.id" items=departments id="departmentId" empty="..."/]
        [@b.textfield name="admission.letterNo" label="通知书号" /]
        [@b.select label="入学方式" name="admission.enrollMode.id" items=enrollModes id="enrollModeId" empty="..."/]
        [@b.select label="培养方式" name="admission.educationMode.id" items=educationModes id="educationModeId" empty="..."/]
      <input type="hidden" name="orderBy" value="std.state.grade desc"/>
      [/@]
  </div>
  <div class="search-list">
        [@b.div id="contentDiv" href="!search?orderBy=std.state.grade desc" /]
  </div>
</div>
[@b.foot/]

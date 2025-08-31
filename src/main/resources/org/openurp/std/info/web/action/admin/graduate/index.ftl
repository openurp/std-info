[#ftl]
[@b.head/]
[@b.form name="indexForm" action="" /]
[@b.toolbar title="毕业信息"]
  bar.addItem("毕业统计", "graduateStat()");
  function graduateStat() {
    bg.form.submit(document.indexForm,  "${b.url("/stat/graduate")}", "_blank");
  }
[/@]
<div class="search-container">
  <div class="search-panel">
      [@b.form theme="search" name="searchForm" action="!search" title="查询条件" target="contentDiv"]
        [@b.select name="graduate.season.id" items=graduateSeasons?sort_by("code")?reverse empty="..." label="毕业界别"/]
        [@b.textfield name="graduate.std.code" label="学号" /]
        [@b.textfield name="graduate.std.name" label="姓名" /]
        [@b.textfield name="graduate.std.state.grade" label="年级" /]
        [@b.select name="graduate.std.level.id" label="学历层次" items=levels empty="..."/]
        [@b.select name="graduate.std.stdType.id" label="学生类别" items=stdTypes empty="..."/]
        [@b.select name="graduate.std.state.department.id" label="院系" items=departments empty="..."/]
        [@b.select name="graduate.std.state.major.id" label="专业" items=majors empty="..."/]
        [@b.select name="graduate.std.state.direction.id" label="方向" items=directions empty="..."/]
        [@b.textfield name="graduate.code" label="毕业证书" /]
        [@b.date label="毕业日期" name="graduate.graduateOn" value="" format="yyyy-MM-dd" readOnly="readOnly"/]
        [@b.textfield name="graduate.degree.name" label="学位" /]
        [@b.date label="学位授予" name="graduate.degreeAwardOn" value="" format="yyyy-MM-dd" readOnly="readOnly"/]
        [@b.textfield name="graduate.diplomaNo" label="学位证书" /]
        [#if tutorSupported][@b.textfield name="tutor.name" label="导师姓名" /][/#if]
        [@b.select label="有学位" name="degree" items={}]
          <option value="2">...</option>
          <option value="1">有</option>
          <option value="0">无</option>
        [/@]
      <input type="hidden" name="orderBy" value="std.code"/>
      [/@]
  </div>
  <div class="search-list">
        [@b.div id="contentDiv" href="!search?orderBy=std.code desc" /]
  </div>
</div>
[@b.foot/]

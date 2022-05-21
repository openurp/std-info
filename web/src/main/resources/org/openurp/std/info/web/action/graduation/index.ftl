[#ftl]
[@b.head/]
[@b.form name="indexForm" action="" /]
[@b.toolbar title="毕业信息"]
      bar.addItem("毕业统计", "graduationStat()");
      bar.addItem("学位统计", "degreeStat()");

      function graduationStat() {
        bg.form.submit(document.indexForm,  "${b.url("graduation-stat")}", "_blank");
      }
      function degreeStat() {
        bg.form.submit(document.indexForm,  "${b.url("degree-stat")}", "_blank");
      }
[/@]
<div class="search-container">
  <div class="search-panel">
      [@b.form theme="search" name="searchForm" action="!search" title="查询条件" target="contentDiv" ]
        [@b.textfield name="graduation.std.user.code" label="学号" /]
        [@b.textfield name="graduation.std.user.name" label="姓名" /]
        [@b.textfield name="graduation.std.state.grade" label="年级" /]
        [@b.select name="graduation.std.level.id" label="学历层次" items=levels empty="..."/]
        [@b.select name="graduation.std.stdType.id" label="学生类别" items=stdTypes empty="..."/]
        [@b.select name="graduation.std.state.department.id" label="院系" items=departments empty="..."/]
        [@b.select name="graduation.std.state.major.id" label="专业" items=majors empty="..."/]
        [@b.select name="graduation.std.state.direction.id" label="方向" items=directions empty="..."/]
        [@b.textfield name="graduation.code" label="毕业证书" /]
        [@b.datepicker label="毕业日期" name="graduation.graduateOn" value="" format="yyyy-MM-dd" readOnly="readOnly"/]
        [@b.textfield name="graduation.degree.name" label="学位" /]
        [@b.datepicker label="学位授予" name="graduation.degreeAwardOn" value="" format="yyyy-MM-dd" readOnly="readOnly"/]
        [@b.textfield name="graduation.diplomaNo" label="学位证书" /]
        [@b.select label="有学位" name="degree" items={}]
          <option value="2">...</option>
          <option value="1">有</option>
          <option value="0">无</option>
        [/@]
      <input type="hidden" name="orderBy" value="std.state.grade desc"/>
      [/@]
  </div>
  <div class="search-list">
        [@b.div id="contentDiv" href="!search?orderBy=std.state.grade desc" /]
  </div>
</div>
[@b.foot/]

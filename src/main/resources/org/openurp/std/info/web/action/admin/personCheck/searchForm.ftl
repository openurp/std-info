[@b.form name="checkSearchForm" action="!search" title="ui.searchForm" target="listFrame" theme="search"]
  [@b.select name="season.id" items=graduateSeasons?sort_by("code")?reverse label="毕业界别" required="true"/]
  [@b.textfield name="check.std.code" label="学号" maxlength="2000"/]
  [@b.textfield name="check.std.name" label="姓名"/]
  [@b.textfield name="check.std.state.grade.code" label="年级"/]
  [@base.code type="std-types" name="check.std.stdType.id" label="学生类别"  empty="..."/]
  [@base.code type="education-levels" name="check.std.level.id" label="培养层次"  empty="..."/]
  [@b.select name="check.std.state.department.id" label="院系" items=departments empty="..."/]
  [@b.select name="check.std.state.major.id" label="专业" items=majors empty="..."/]
  [@b.textfield name="check.std.state.direction.name" label="专业方向"/]
  [@b.textfield name="check.std.state.squad.name" label="班级"/]
  [@b.select label="是否确认" name="check.confirmed" items={'1':'是','0':'否'} empty="...."/]
[/@]
<script>
  $(document).ready(function() {
    bg.form.submit("checkSearchForm");
  });
</script>

[#ftl]
[@b.head/]
[@b.toolbar title="学籍异动结果"]
  bar.addBack()
[/@]
[@b.form target="main" action="!index" name="goBackForm"/]
  <p>成功:${successes?size}</p>
  [@b.grid items=successes?sort_by(["std","code"]) var="stdAlteration" sortable="false"]
    [@b.row]
      [@b.col property="std.code" title="学号"/]
      [@b.col property="std.name" title="姓名"/]
      [@b.col property="std.state.department.name" title="院系"/]
      [@b.col property="std.state.major.name" title="专业"/]
      [@b.col property="alterType.name" title="变动类型"/]
      [@b.col property="reason.name" title="异动原因"/]
      [@b.col property="alterOn" title="变动日期"]${((stdAlteration.alterOn)?string("yyyy-MM-dd"))?default("")}[/@]
      [@b.col property="updatedAt" title="记录时间"]${(stdAlteration.updatedAt)?string("yyyy-MM-dd HH:mm:ss")?default("")}[/@]
    [/@]
  [/@]
  <p>失败:${errors?size}</p>
  <div>
    [#list errors?keys as std]
      ${std.code} ${std.name} ${errors.get(std)!}<br>
    [/#list]
  </div>
[@b.foot/]

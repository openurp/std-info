[#ftl]
[@b.head/]
[@b.toolbar title='学生信息查看']
  bar.addBackOrClose();
[/@]
[@b.messages slash="7"/]
<div class="container text-sm">
[#macro panel title]
<div class="card card-info card-outline">
  <div class="card-header">
    <h3 class="card-title">${title}</h3>
  </div>
  [#nested/]
</div>
[/#macro]

<div class="card card-info card-outline">
  <div class="card-header">
    <h3 class="card-title">学籍信息</h3>
  </div>
  [#include "/org/openurp/std/info/web/components//student_info.ftl"/]
</div>

[@panel title="基本信息"]
  [#include "/org/openurp/std/info/web/components//person_info.ftl"/]
[/@]

[#if (graduation.id)??]
[@panel title="毕业信息"]
  [#include "/org/openurp/std/info/web/components//graduation_info.ftl"/]
[/@]
[/#if]

[#if home??]
[@panel title="家庭信息"]
  [#include "/org/openurp/std/info/web/components//home_info.ftl"/]
[/@]
[/#if]

[#if examinee??]
[@panel title="考生信息"]
  [#include "/org/openurp/std/info/web/components//examinee_info.ftl"/]
[/@]
[/#if]

[#if graduate??]
[@panel title="毕业信息"]
  [#include "/org/openurp/std/info/web/components//graduate_info.ftl"/]
[/@]
[/#if]

</div>
[@b.foot/]

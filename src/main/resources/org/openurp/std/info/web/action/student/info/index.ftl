[#ftl]
[@b.head/]
[#include "/org/openurp/starter/web/components/multi-std-nav.ftl"/]
<div class="container text-sm">
  [@b.toolbar title="我的学籍"]
    bar.addBack("${b.text("action.back")}");
  [/@]
  [#macro panel title]
  <div class="card card-primary card-outline">
    <div class="card-header">
      <h3 class="card-title">${title}</h3>
    </div>
    [#nested/]
  </div>
  [/#macro]

  [@panel title="学籍信息"]
    [#include "/org/openurp/std/info/web/components/student_info.ftl"/]
  [/@]

  <div class="card card-primary card-outline">
    <div class="card-header">
      <h3 class="card-title">基本信息</h3>
      [@b.card_tools]
        [@b.a href="!edit"]<i class="fas fa-edit"></i>修改[/@]
      [/@]
    </div>
    [#include "/org/openurp/std/info/web/components/person_info.ftl"/]
  </div>

  [#if (home.id)??]
  [@panel title="家庭信息"]
    [#include "/org/openurp/std/info/web/components/home_info.ftl"/]
  [/@]
  [/#if]

  [#if (examinee.id)??]
  [@panel title="考生信息"]
    [#include "/org/openurp/std/info/web/components/examinee_info.ftl"/]
  [/@]
  [/#if]

  [#if (graduation.id)??]
  [@panel title="毕业信息"]
    [#include "/org/openurp/std/info/web/components/graduation_info.ftl"/]
  [/@]
  [/#if]
</div>
[@b.foot/]

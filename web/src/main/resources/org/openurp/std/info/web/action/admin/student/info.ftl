[#ftl]
[@b.head/]
[@b.toolbar title='学生信息查看']
  bar.addBackOrClose();
[/@]
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
    [@b.card_tools]
       [@b.a href="certificate?lang=zh&student.id="+student.id target="_blank"]<i class="fa-solid fa-stamp"></i>中文在读证明[/@]&nbsp;
       [@b.a href="certificate?lang=en&student.id="+student.id target="_blank"]<i class="fa-solid fa-stamp"></i>Certification[/@]
    [/@]
  </div>
  [#include "/org/openurp/std/info/web/components/student_info.ftl"/]
</div>

[@panel title="基本信息"]
  [#include "/org/openurp/std/info/web/components/person_info.ftl"/]
[/@]

[#if (graduation.id)??]
[@panel title="毕业信息"]
  [#include "/org/openurp/std/info/web/components/graduation_info.ftl"/]
[/@]
[/#if]

[@panel title="联系信息"]
  [#include "/org/openurp/std/info/web/components/contact_info.ftl"/]
[/@]

[#if home??]
[@panel title="家庭信息"]
  [#include "/org/openurp/std/info/web/components/home_info.ftl"/]
[/@]
[/#if]

[#if examinee??]
[@panel title="考生信息"]
  [#include "/org/openurp/std/info/web/components/examinee_info.ftl"/]
[/@]
[/#if]

[#if graduate??]
<div class="card card-info card-outline">
  <div class="card-header">
    <h3 class="card-title">毕业信息</h3>
    [#if graduate.certificateNo??]
    [@b.card_tools]
       [#if .get_optional_template("/org/openurp/std/info/web/components/${student.project.id}/cert_graduate_en.ftl",{'parse': false}).exists]
       [@b.a href="graduate!certEn?cert=graduate&graduate.id="+graduate.id target="_blank"]<i class="fa-solid fa-stamp"></i>毕业证书翻译件[/@]&nbsp;
       [/#if]
       [#if graduate.degree?? && .get_optional_template("/org/openurp/std/info/web/components/${student.project.id}/cert_degree_en.ftl",{'parse': false}).exists]
       [@b.a href="graduate!certEn?cert=degree&graduate.id="+graduate.id target="_blank"]<i class="fa-solid fa-stamp"></i>学位证书翻译件[/@]
       [/#if]
    [/@]
    [/#if]
  </div>
  [#include "/org/openurp/std/info/web/components/graduate_info.ftl"/]
</div>
[/#if]

</div>
[@b.foot/]

[#ftl]
[@b.head]
<link rel="stylesheet" type="text/css" href="${base}/static/scripts/commons/css/common.css?v=1">
[/@]
[@b.toolbar title='学生信息查看']
  bar.addBackOrClose();
[/@]
<div class="container">
[#macro panel title]
<div class="card card-info card-outline">
  <div class="card-header">
    <h3 class="card-title">${title}</h3>
  </div>
  [#nested/]
</div>
[/#macro]

[@panel title="学籍信息"]
  [#include "include/student_info.ftl"/]
[/@]

[@panel title="基本信息"]
  [#include "include/person_info.ftl"/]
[/@]

[#if (graduation.id)??]
[@panel title="毕业信息"]
  [#include "include/graduation_info.ftl"/]
[/@]
[/#if]

[@panel title="联系信息"]
  [#include "include/contact_info.ftl"/]
[/@]

[#if (home.id)??]
[@panel title="家庭信息"]
  [#include "include/home_info.ftl"/]
[/@]
[/#if]

[@panel title="考生信息"]
  [#include "include/examinee_info.ftl"/]
[/@]
</div>
[@b.foot/]

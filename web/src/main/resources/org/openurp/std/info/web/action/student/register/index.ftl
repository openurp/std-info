[#ftl]
[@b.head/]

<div class="container" style="width:95%">

<nav class="navbar navbar-default" role="navigation">
  <div class="container-fluid">
    <div class="navbar-header">
        <a class="navbar-brand" href="#"><span class="glyphicon glyphicon-book"></span>报到注册</a>
    </div>
  </div>
</nav>

  [#if sessions?size>0]
  <div class="jumbotron">
    <div class="container">
        <h2>报到注册</h2>
        [#assign registedSemesters=[]/]
        [#list registers as register]
            [#assign registedSemesters=registedSemesters +[register.semester]/]
        [/#list]
        [#list sessions as session]
        <p>欢迎进入${session.semester.schoolYear}学年${session.semester.name} 新学期，请确认你的学籍信息。</p>

        [#if registedSemesters?seq_contains(session.semester)]
            <a role="button" href="#" class="btn btn-lg btn-success disabled"><span class="">注册完成</span></a>
        [#else]
          [#if debts?size=0]
          <p>
           [@b.a class="btn btn-lg btn-info" role="button" href="!editNew?session.id="+session.id]
            <span class='glyphicon glyphicon-plus'>开始注册</span><small>(${session.semester.schoolYear}学年${session.semester.name}学期)</small>[/@]
          </p>
          [#else]
             <a class="btn btn-lg btn-info disabled" role="button" href="#"><span class='glyphicon glyphicon-plus'>尚未完成学费缴纳,暂时不能注册</span><small>(${session.semester.schoolYear}学年${session.semester.name}学期)</small></a>
          [/#if]

        [/#if]

        [/#list]
     </div>
  </div>
  [#else]
    [@panel "注册未开放"]
       当前下学期，注册未开放或已经关闭。
    [/@]
  [/#if]

[#macro panel title]
<div class="card card-info card-primary card-outline">
  <div class="card-header">
    <h3 class="card-title">${title}</h3>
  </div>
  [#nested/]
</div>
[/#macro]

  [#list registers as register]
  [#assign title]
     <span class="glyphicon glyphicon-bookmark"></span>完成${register.semester.schoolYear}学年${register.semester.name}学期注册 <span style="font-size:0.8em">(${register.registerAt?string("yyyy-MM-dd")})</span>
  [/#assign]
  [@panel title=title]
    [@b.div id="session_info"][#include "info.ftl"/][/@]
  [/@]
  [/#list]

</div>
[@b.foot/]

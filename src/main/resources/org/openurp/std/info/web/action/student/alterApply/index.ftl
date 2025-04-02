[#ftl]
[@b.head/]
<div class="container" style="width:95%">
  <nav class="navbar navbar-default" role="navigation">
    <div class="container-fluid">
      <div class="navbar-header">
        <a class="navbar-brand" href="#"><i class="fas fa-graduation-cap"></i>学生学籍异动申请</a>
      </div>
    </div>
  </nav>
  [@b.messages slash="4"/]

  [#if flows?size==0]
    <div style="background-color: #e9ecef;border-radius: .3rem;padding: 2rem 2rem;margin-bottom: 2rem;">
      <h4>学生提交学籍异动申请</h4>
      <pre style="border-bottom: 1px solid rgba(0,0,0,.125);white-space: pre-wrap;color:red">申请业务还未开放</pre>
    </div>
  [#else]
    <div style="background-color: #e9ecef;border-radius: .3rem;padding: 2rem 2rem;margin-bottom: 2rem;">
      <h4>学生提交学籍异动申请</h4>
      <pre style="border-bottom: 1px solid rgba(0,0,0,.125);white-space: pre-wrap;">${notice!}</pre>
      <div>请选择以下类型，进行申请。</div>
      <p>
        [#list flows?sort_by("code") as flow]
          [@b.a href="!applyForm?flow="+flow.code class="btn btn-sm btn-primary"]${flow.name}[/@]
        [/#list]
      </p>
    </div>
  [/#if]

[#include "/org/openurp/std/info/web/components/alter_step.ftl"/]
[#if applyInfoes?size>0]
  [#list applyInfoes as applyInfo]
  [#assign apply = applyInfo.alterApply/]
  [#assign title]
     <i class="fas fa-school"></i> &nbsp;${apply.alterType.name}<span style="font-size:0.8em">(${apply.applyAt?string("yyyy-MM-dd HH:mm")})</span>
     ${apply.status}
  [/#assign]
  [@b.card class="card-info card-outline"]
     [@b.card_header]
      ${title}
      <div class="card-tools">[#if !apply.passed!false][@b.a href="!cancel?apply.id="+apply.id+"&projectId="+student.project.id onclick="return removeApply(this);" class="btn btn-sm btn-warning"]<i class="fas fa-times"></i>取消申请[/@][/#if]</div>
     [/@]
     [#include "applyInfo.ftl"/]
  [/@]
  [/#list]
[/#if]

</div> [#--container--]
<script>
   function removeApply(elem){
       if(confirm("确定取消该申请?")){
         return bg.Go(elem,null)
       }else{
         return false;
       }
   }
</script>
[@b.foot/]

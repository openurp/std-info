[#ftl]
[@b.head/]
  <div class="container-fluid">
    [@b.toolbar title="异动申请"]
      bar.addBack();
    [/@]
    <div class="card card-info card-outline">
      <div class="card-header">
        <h3 class="card-title">${std.project.school.name} ${alterType.name}申请异动</h3>
      </div>
      <div class="card-body" style="padding-top: 0px;">
        [#include "/org/openurp/std/info/web/components/alter_step.ftl"/]
        [#assign stepNames = getStepNames(flow)/]
        [@displayStep  stepNames stepNames?first/]
        [@b.form action="!submit" theme="list"]
          [@b.field label="学生"]${std.code} ${std.name} ${std.department.name}[/@]
          [@b.field label="培养层次"]${(std.level.name)!}[/@]
          [@b.field label="专业、方向"]${(std.major.name)!} ${(std.direction.name)!} 导师[#list std.majorTutors as t]${t.name}[#sep],[/#list][/@]
          [@b.field label="异动类型"]${(alterType.name)!}[/@]
          [#if needEndOn]
          [@b.startend label="开始~结束日期" name="apply.alterFrom,apply.alterTo" required="true"/]
          [#else]
          [@b.date label="变动日期" name="apply.alterFrom" required="true"/]
          [/#if]
          [#if tutors??]
          [@b.select label="更换后的导师" name="alter.tutor.id" required="true" items=tutors?sort_by('name') empty="..."/]
          [/#if]
          [@b.textarea label="异动原因" name="apply.reason" rows="5" cols="80" maxlength="300" required="true" style="width: 600px;"/]
          [@b.file label="附件1" name="attachment" required="false"/]
          [@b.file label="附件2" name="attachment" required="false"/]
          [@b.file label="附件3" name="attachment" required="false" comment="更多附件可以上传一个压缩包"/]

          [@b.field label="承诺"]我提出${alterType.name}的申请，也同意承担相应的义务和责任，信守学院的有关规定。[/@]
          [@b.esign label="学生签名" id="stdSign" name="stdSign" required="true" width="600" height="200"/]
          [@b.formfoot]
            <input type="hidden" name="apply.alterType.id" value="${alterType.id}">
            <input type="hidden" name="flow" value="${flow.code}">
            [@b.submit /]
          [/@]
        [/@]
      </div>
    </div>
  </div>
[@b.foot/]

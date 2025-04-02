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
          [@b.field label="专业、方向"]${(std.major.name)!} ${(std.direction.name)!} 导师${(tutor.name)!}[/@]
          [@b.field label="异动类型"]${(alterType.name)!}[/@]

          [#if alterType.name?contains("复学")]
            [@b.date label="复学日期" name="apply.alterFrom" required="true"/]
          [#elseif alterType.name?contains("休学")]
            [@b.startend label="休学开始~结束" name="apply.alterFrom,apply.alterTo" required="true" comment=""/]
          [#elseif alterType.name?contains("提前毕业")]
            [#assign graduateOn]${std.graduateOn?string('yyyy')?number-1}${std.graduateOn?string('-MM-dd')}[/#assign]
            [@b.field label="毕业日期"]<span style="color:red"><strong>${graduateOn}</strong></span><input type="hidden" name="apply.alterFrom" value="${graduateOn}"/>[/@]
            [@b.field label="申请条件"]
              <div style="display: inline-block;">[#t/]
              申请人据实自行填写，研究生部核实。<br>[#t/]
              1.各门必修课成绩均在90分及以上；<br>[#t/]
              2.各门选修课成绩均在85分及以上；<br>[#t/]
              3.已完成培养计划所规定的课程学分要求（专业主课学分达到申请时的实际学期要求即可）；<br>[#t/]
              4.有学位音乐会要求的，申请时已完成并通过1场（硕士）或2场（博士）学位音乐会<br>[#t/]
              5.综合测评符合学校规定要求。[#t/]
              </div>
            [/@]
          [#elseif alterType.name?contains("导师")]
            [@b.select label="新导师" name="alter.tutor.id" required="true" items=tutors?sort_by('name') empty="..."/]
          [/#if]

          [@b.textarea label="异动原因" name="apply.reason" rows="5" cols="80" maxlength="300" required="true" class="textarea-inherit"/]
          [#if alterType.name?contains("提前毕业")]
            [@b.file label="成绩单" name="attachment" required="true"/]
            [@b.file label="培养计划完成" name="attachment" required="true"/]
            [@b.file label="学位音乐会" name="attachment" required="true"/]
            [@b.file label="其他附件" name="attachment" required="false" comment="更多附件可以上传一个压缩包"/]
          [#else]
            [@b.file label="附件1" name="attachment" required="false"/]
            [@b.file label="附件2" name="attachment" required="false"/]
            [@b.file label="附件3" name="attachment" required="false" comment="更多附件可以上传一个压缩包"/]
          [/#if]

          [@b.field label="承诺"]<div style="display: inline-block;">我提出${alterType.name}的申请，也同意承担相应的义务和责任，信守学院的有关规定。</div>[/@]
          [@b.esign label="学生签名" id="stdSign" name="stdSign" required="true" width="600" height="200" enableLocalFile="false" remoteHref=signature_url/]
          [#if alterType.name?contains("退学")]
          [@b.esign label="家长签名" id="parentSign" name="parentSign" required="true" width="600" height="200" enableLocalFile="false"/]
          [/#if]
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

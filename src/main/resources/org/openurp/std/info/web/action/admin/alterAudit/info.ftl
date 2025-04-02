[#ftl]
[@b.head/]
[@b.toolbar title="学籍异动申请详情"]
  bar.addBackOrClose();
[/@]
<div class="container">
[#include "/org/openurp/std/info/web/components/alter_step.ftl"/]
[#assign std = apply.std/]
[@b.messages/]

  [#if applyInfo.process??]
    [#assign process = applyInfo.process/]
    [#assign activeTasks = process.activeTasks/]
    [#if activeTasks?size>0]
      [#assign stepNames=getStepNames(applyInfo.flow)/]
      [@displayStep stepNames activeTasks?first.name/]
    [/#if]
  [/#if]

  <table class="table table-sm" style="table-layout:fixed;width:100%;">
    [#assign std= apply.std/]
    <tr>
      <td class="title width15">学号：</td>
      <td>${std.code} </td>
      <td class="title width15">姓名：</td>
      <td>${std.name}</td>
    </tr>
    <tr>
      <td class="title">培养层次：</td>
      <td>${(std.level.name)!}</td>
      <td class="title">[#if std.tutor??]导师：[#else]辅导员：[/#if]</td>
      <td>[#if std.tutor??]${std.tutor.name}[#else]${(std.squad.mentor.name)!}[/#if]</td>
    </tr>
    <tr>
      <td class="title">院系：</td>
      <td>${std.department.name}</td>
      <td class="title">填写时间：</td>
      <td>${(apply.applyAt?string("MM-dd HH:mm"))!}</td>
    </tr>
    <tr>
      <td class="title">专业/方向：</td>
      <td colspan="3">${(std.major.name)!} ${(std.direction.name)!} ${(std.squad.name)!}</td>
    </tr>
    <tr>
      <td class="title">异动类型：</td>
      <td>${apply.alterType.name}</td>
      <td class="title">生效日期：</td>
      <td>[#if apply.alterFrom??]${apply.alterFrom?string("yyyy-MM-dd")}[#else]申请通过时[/#if][#if apply.alterTo??] ~ ${(apply.alterTo?string("yyyy-MM-dd"))!}[/#if]</td>
    </tr>
    <tr>
      <td class="title">异动原因：</td>
      <td colspan="3">${apply.reason}</td>
    </tr>
    [#if alter?size!=0]
    <tr>
      <td class="title">变更内容：</td>
      <td colspan="3">
      [#list alter as k,ai]
        ${ai.meta}: ${ai.oldtext!} -> ${ai.newtext!}[#sep]<br>
      [/#list]
      </td>
    </tr>
    [/#if]
    <tr>
      <td class="title">申请材料：</td>
      <td colspan="3">
        [#if applyInfo.process?? && applyInfo.process.tasks??]
        [#list applyInfo.process.tasks?first.attachments as f]
          <li> <a href="${applyInfo.files.get(f.filePath)}" target="_blank">${f.name}</a></li>
        [/#list]
        [/#if]
      </td>
    </tr>
    <tr>
      <td colspan="4" class="timeline-container">
        <div class="timeline-container">
          <div class="timeline">
            [#assign groupSteps = applyInfo.groupSteps/]
            [#list groupSteps?keys?sort?reverse as date]
            <div class="time-label">
              <span>${date}</span>
            </div>
            [#list groupSteps[date] as step]
            <div>
              [#if step.passed??]
                [#if step.passed]<i class="fas fa-check bg-green"></i>[#else]<i class="fas fa-xmark bg-red"></i>[/#if]
              [#else]
              <i class="fas fa-user"></i>
              [/#if]
              <div class="timeline-item">
                <span class="time"><i class="fas fa-clock"></i> [#if step.auditAt??]${step.auditAt?string("HH:mm:ss")}[#else]--[/#if]</span>
                <h3 class="timeline-header">${step.name}</h3>
                <div class="timeline-body">
                [#if step.passed??]
                  ${step.assignee.name} ${step.comments!}
                  [#list applyInfo.getSigns(step.name) as sign_url]
                    <img src="${sign_url}" style="height: 50px;margin:0px;">
                  [/#list]
                [#else]
                  <span class="text-muted">未审核</span>
                  [#if auditable]
                    [@b.a href="!auditForm?stdAlterApply.id=${apply.id}" class="btn btn-sm btn-primary"]开始审核...[/@]
                  [/#if]
                [/#if]
                </div>
              </div>
            </div>
            [/#list]
            [/#list]
            <div>
              <i class="fas fa-clock bg-gray"></i>
            </div>
          </div>
        </div>
      </td>
    </tr>
    <tr>
      <td class="title">审核状态：</td>
      <td colspan="3"><span class="[#if apply.passed?? && apply.passed]text-success[#else]text-danger[/#if]">${apply.status}</span></td>
    </tr>
  </table>
</div>
[@b.foot/]

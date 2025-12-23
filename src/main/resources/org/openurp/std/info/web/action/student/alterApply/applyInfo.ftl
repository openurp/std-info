[#ftl]
[#assign std = apply.std/]
  [#if applyInfo.process??]
    [#assign process = applyInfo.process/]
    [#assign activeTasks = process.activeTasks/]
    [#if activeTasks?size>0]
      [#assign stepNames = getStepNames(applyInfo.flow)/]
      [@displayStep stepNames activeTasks?first.name/]
    [/#if]
  [/#if]
<table class="table table-sm">
    <tr>
      <td class="title">异动类型：</td>
      <td>${apply.alterType.name}</td>
      <td class="title">生效日期：</td>
      <td>${(apply.alterFrom?string("yyyy-MM-dd"))!} ~ ${(apply.alterTo?string("yyyy-MM-dd"))!}</td>
      <td class="title">填写时间：</td>
      <td>${(apply.applyAt?string("yyyy-MM-dd HH:mm"))!}</td>
    </tr>
    <tr>
      <td class="title">异动原因：</td>
      <td colspan="5">${apply.reason}</td>
    </tr>
    <tr>
      <td class="title">申请材料：</td>
      <td colspan="5">
        [#if applyInfo.process?? && applyInfo.process.tasks??]
        [#list applyInfo.process.tasks?first.attachments as f]
          <li> <a href="${applyInfo.files.get(f.filePath)}" target="_blank">${f.name}</a></li>
        [/#list]
        [/#if]
      </td>
    </tr>
    <tr>
      <td colspan="6">
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
      <td colspan="5"><span class="[#if apply.passed?? && apply.passed]text-success[#else]text-danger[/#if]">${apply.status}</span></td>
    </tr>
  </table>

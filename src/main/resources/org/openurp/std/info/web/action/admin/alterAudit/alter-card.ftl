[@b.card class="card-primary card-outline"]
  [#assign std= apply.std/]
  [@b.card_header]
     <i class="fas fa-user"></i>&nbsp;[@b.a href="!info?id="+apply.id target="_blank"]${apply.std.name}<span style="font-size:0.8em">(${std.code})</span> ${apply.alterType.name} 申请[/@]
     [@b.card_tools]
       [#if auditable!false]
         [@b.a href="!info?id="+apply.id target="_blank" class="btn btn-sm btn-outline-primary"]审核[/@]
       [#else]
         [#if apply.status=='已办结']<i class="fa fa-check"></i>[#else]<i class="fas fa-clock bg-gray"></i>[/#if] ${apply.status}
       [/#if]
     [/@]
  [/@]
  [@b.card_body style="padding-top: 0px;"]
  <table class="table table-sm" style="table-layout:fixed;">
    <tr>
      <td class="title width15">年级：</td>
      <td>${std.grade.name} ${(std.level.name)!}</td>
      <td class="title width15">[#if std.majorTutors?size>0]导师：[#else]辅导员：[/#if]</td>
      <td>[#if std.majorTutors?size>0][#list std.majorTutors as t]${t.name}[#sep],[/#list][#else]${(std.squad.mentor.name)!}[/#if]</td>
    </tr>
    <tr>
      <td class="title">院系：</td>
      <td>${std.department.name}</td>
      <td class="title">生效日期：</td>
      <td>[#if apply.alterFrom??]${apply.alterFrom?string("yyyy-MM-dd")}[#else]申请通过时[/#if][#if apply.alterTo??] ~ ${(apply.alterTo?string("yyyy-MM-dd"))!}[/#if]</td>
    </tr>
    <tr>
      <td class="title">专业/方向：</td>
      <td colspan="3">${(std.major.name)!} ${(std.direction.name)!} ${(std.squad.name)!}</td>
    </tr>
    <tr>
      <td class="title">异动原因：</td>
      <td colspan="3">${apply.reason}</td>
    </tr>
  </table>
  [/@]
  <div class="card-footer" style="padding-top:0.5rem;padding-bottom:0.5rem;">
    <div style="float: right;margin-right: -.625rem;">
      <span class="text-muted" title="申请时间">申请于<i class="fas fa-clock"></i>${(apply.applyAt?string("MM-dd HH:mm"))!}</span>
    </div>
  </div>
[/@]

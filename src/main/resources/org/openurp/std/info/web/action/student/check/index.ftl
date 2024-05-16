[#ftl]
[@b.head/]
<div class="container">
  [@b.toolbar title="基本信息核对"]
    bar.addClose();
  [/@]
  [@b.messages slash="3"/]
  <div class="card card-info card-outline">
    <div class="card-header">
      <h3 class="card-title">个人基本信息</h3>
      <div class="card-tools">
        [#if check??]
          [#if check.confirmed!false]
            <a href="javascript:void" class="btn btn-sm btn-outline-success">已经确认</a>
          [#else]
            [@b.a href="!checkForm" class="btn btn-sm btn-outline-primary"]修改核对[/@]
          [/#if]
          <span class="text-muted">${check.updatedAt?string('yyyy-MM-dd HH:mm')}</span>
        [#else]
          [@b.a href="!checkForm" class="btn btn-sm btn-outline-primary"]开始核对[/@]
        [/#if]
      </div>
    </div>
    <div class="card-body">
      [#assign person = student.person/]
      <table class="table table-sm">
        <tr>
          <td class="title" width="100px">学号:</td>
          <td>${(student.code?html)!}</td>
          <td class="title" width="100px">姓名:</td>
          <td>
          ${student.name?html}
          [#if check?? && check.hasChange("name")]=> <span style="color:red">${check.getNewValue("name")}</span>[/#if]
          </td>
          <td class="title" width="100px">姓名拼音:</td>
          <td>${(student.person.phoneticName?html)!}</td>
        </tr>
        <tr>
          <td class="title">国家地区:</td>
          <td>
          ${(student.person.country.name)!}
          </td>
          <td class="title">性别:</td>
          <td>
            ${(student.person.gender.name)!}
            [#if check?? && check.hasChange("gender")]=> <span style="color:red">${check.getNewValue("gender")}</span>[/#if]
          </td>
          <td class="title">出生年月:</td>
          <td>
            ${((student.person.birthday)?string("yyyy-MM-dd"))!}
            [#if check?? && check.hasChange("birthday")]=> <span style="color:red">${check.getNewValue("birthday")}</span>[/#if]
          </td>
        </tr>
        <tr>
          <td class="title">民族:</td>
          <td>
            ${(student.person.nation.name)!}
            [#if check?? && check.hasChange("nation")]=> <span style="color:red">${check.getNewValue("nation")}</span>[/#if]
          </td>
          <td class="title">证件类型:</td>
          <td>
            ${(student.person.idType.name)!}
            [#if check?? && check.hasChange("idType")]=> <span style="color:red">${check.getNewValue("idType")}</span>[/#if]
          </td>
          <td class="title">证件号码:</td>
          <td>
            ${(student.person.code)!"<br>"}
            [#if check?? && check.hasChange("code")]=> <span style="color:red">${check.getNewValue("code")}</span>[/#if]
          </td>
        </tr>
        <tr>
          <td class="title">籍贯:</td>
          <td>${((student.person.homeTown?html))!}</td>
          <td class="title">政治面貌:</td>
          <td>${(student.person.politicalStatus.name)!}</td>
          <td class="title">附件:</td>
          <td></td>
        </tr>
        [#if check?? && check.auditOpinion??]
        <tr>
          <td class="title">审核意见:</td>
          <td colspan="5">${(check.auditOpinion?html)!}</td>
        </tr>
        [/#if]
      </table>
    </div>
  </div>
</div>
[@b.foot/]

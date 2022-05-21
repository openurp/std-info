[#ftl]
[@b.head]
<link rel="stylesheet" type="text/css" href="${base}/static/scripts/commons/css/common.css">
<script src="${base}/static/scripts/common.js?v=2"></script>
[/@]

[@b.toolbar title='个人基本信息维护']
     bar.addBackOrClose();
[/@]
[@b.messages slash = "7"/]

[#if !((student.person.id)??)]
<div style="color: red">请先配置<span style="font-weight: bold">学生基本信息</span>！</div>
[/#if]
<div class="container">
    <input type="hidden" name="contact.id" value="${(contact.id)!}"/>
    <input type="hidden" name="home.id" value="${(home.id)!}"/>
    <input type="hidden" name="examinee.id" value="${(examinee.id)!}"/>
    <input type="hidden" name="student.id" value="${(student.id)!}"/>

    [#if restriction??]
      [#assign hasContact=false/]
      [#assign hasHome=false/]
      [#assign hasExaminee=false]

      [#list restriction.metas as meta]
        [#if !hasContact][#assign hasContact = (meta.name == contactMeta)/][/#if]
        [#if !hasHome][#assign hasHome = (meta.name == homeMeta)/][/#if]
        [#if !hasExaminee][#assign hasExaminee = (meta.name == examineeMeta)/][/#if]
      [/#list]
    [/#if]

<div class="card card-primary card-outline ajax_container">
  <div class="card-header">
    <h3 class="card-title">学生联系信息</h3>
  </div>
  <div class="card-body" >
    <table class="infoTable">
      <tr>
        <td class="title" width="10%">电子邮箱：</td>
        <td width="23%">${(contact.mail?html)!}</td>
      </tr>
      <tr>
        <td class="title" width="10%">电话：</td>
        <td width="23%">${(contact.phone?html)!}</td>
      </tr>
      <tr>
        <td class="title" width="10%">移动电话：</td>
        <td>${(contact.mobile?html)!}</td>
      </tr>
      <tr>
        <td class="title">联系地址：</td>
        <td>${(contact.address?html)!}</td>
      </tr>
    </table>
    <div style="text-align: center" >
      [#if hasContact?? && hasContact]
        [@b.a class="btn btn-default" href="!editContact" role="button"]修改[/@]
      [#else]
      <h6 style="color:red ">没有修改权限,请先配置数据权限</h6>
      [/#if]
    </div>
  </div>
</div>

  <div class="card card-primary card-outline ajax_container">
    <div class="card-header">
      <h3 class="card-title">学生家庭信息</h3>
    </div>
    <div class="card-body" >
      <table class="infoTable">
        <tr>
          <td class="title" width="10%">家庭电话：</td>
          <td width="23%">${(home.phone?html)!}</td>
        </tr>
        <tr>
          <td class="title">家庭地址：</td>
          <td >${(home.address?html)!}</td>
        </tr>
        <tr>
          <td class="title" width="10%">家庭地址邮编：</td>
          <td width="23%">${(home.postcode?html)!}</td>
        </tr>
        <tr>
          <td class="title" width="10%">户籍：</td>
          <td>${(home.formerAddr?html)!}</td>
        </tr>
        <tr>
          <td class="title">派出所：</td>
          <td >${(home.police?html)!}</td>
        </tr>
        <tr>
          <td class="title">派出所电话：</td>
          <td>${(home.policePhone?html)!}</td>
        </tr>
        <tr>
          <td class="title">火车站：</td>
          <td>${(home.railwayStation.name)?if_exists}</td>
        </tr>
        <tr>
      </table>
      <div style="text-align: center" >
        [#if hasHome?? && hasHome]
          [@b.a class="btn btn-default" href="!editHome" role="button"]修改[/@]
        [#else]
          <h6 style="color:red ">没有修改权限,请先配置数据权限</h6>
        [/#if]
      </div>
    </div>
  </div>

[#--<div class="card card-primary card-outline">--]
[#--  <div class="card-header">--]
[#--    <h3 class="card-title">考生信息</h3>--]
[#--  </div>--]
[#--  <div class="card-body">--]
[#--      [@b.fieldset theme="list"]--]
[#--      [#if hasExaminee?? && hasExaminee]--]
[#--        [@b.textfield label="考生号" name="examinee.code" value=(examinee.code)! maxlength="100" style="width: 200px" /]--]
[#--        [@b.textfield label="准考证号" name="examinee.examNo" value=(examinee.examNo)! maxlength="100" style="width: 200px"/]--]
[#--        [@b.select label="生源地" name="examinee.originDivision.id" items=originDivisions empty="..." value=(examinee.originDivision.id)! style="width: 200px"/]--]
[#--        [@b.textfield label="毕业学校编号" name="examinee.schoolNo" value=(examinee.schoolNo)! maxlength="6" style="width: 200px"/]--]
[#--        [@b.textfield label="毕业学校名称" name="examinee.schoolName" value=(examinee.schoolName)! maxlength="100" style="width: 200px"/]--]
[#--        [@b.datepicker label="毕业日期" id="examinee.graduateOn" name="examinee.graduateOn"--]
[#--        value="${(examinee.graduateOn?string('yyyy-MM-dd'))?default('')}" style="width:200px"  format="yyyy-MM-dd" /]--]
[#--        [@b.textfield label="招生录取总分" name="examinee.score" value=(examinee.score)! maxlength="100" style="width: 200px"/]--]
[#--      [#else]--]
[#--    <h6 style="color:red ">没有修改权限,请先配置数据权限</h6>--]
[#--        [@b.textfield label="考生号" name="examinee.code" value=(examinee.code)! maxlength="100" style="width: 200px" disabled = "disabled" /]--]
[#--        [@b.textfield label="准考证号" name="examinee.examNo" value=(examinee.examNo)! maxlength="100" style="width: 200px" disabled = "disabled"/]--]
[#--        [@b.select label="生源地" name="examinee.originDivision.id" items=originDivisions empty="..." value=(examinee.originDivision.id)! style="width: 200px" disabled = "disabled"/]--]
[#--        [@b.textfield label="毕业学校编号" name="examinee.schoolNo" value=(examinee.schoolNo)! maxlength="6" style="width: 200px" disabled = "disabled"/]--]
[#--        [@b.textfield label="毕业学校名称" name="examinee.schoolName" value=(examinee.schoolName)! maxlength="100" style="width: 200px" disabled = "disabled"/]--]
[#--        [@b.datepicker label="毕业日期" id="examinee.graduateOn" name="examinee.graduateOn"--]
[#--        value="${(examinee.graduateOn?string('yyyy-MM-dd'))?default('')}" style="width:200px"  format="yyyy-MM-dd"  disabled = "disabled"/]--]
[#--        [@b.textfield label="招生录取总分" name="examinee.score" value=(examinee.score)! maxlength="100" style="width: 200px" disabled = "disabled"/]--]
[#--      [/#if]--]
[#--      [/@]--]
[#--  </div>--]
[#--</div>--]

</div> <!--end container-->
[@b.foot/]

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
  [@b.form name="studentForm" action="!saveStudentInfo" target="_self"]
    <input type="hidden" name="graduation.id" value="${(graduation.id)!}"/>
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

<div class="card card-primary card-outline">
  <div class="card-header">
    <h3 class="card-title">学生联系信息</h3>
  </div>
  <div class="card-body">
      [@b.fieldset theme="list"]
      [#if hasContact?? && hasContact]
        [@b.textfield label="电子邮箱" name="contact.mail" value=(contact.mail)! maxlength="100" style="width: 200px" /]
        [@b.textfield label="电话" name="contact.phone" value=(contact.phone)! maxlength="100" style="width: 200px"/]
        [@b.textfield label="移动电话" name="contact.mobile" value=(contact.mobile)! maxlength="100" style="width: 200px"/]
        [@b.textarea label="地址（入校后联系地址）" name="contact.address" value=(contact.address)! maxlength="100" style="width: 200px" /]
      [#else]
      <h6 style="color:red ">没有修改权限,请先配置数据权限</h6>
        [@b.textfield label="电子邮箱" name="contact.mail" value=(contact.mail)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="电话" name="contact.phone" value=(contact.phone)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="移动电话" name="contact.mobile" value=(contact.mobile)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textarea label="地址（入校后联系地址）" name="contact.address" value=(contact.address)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
      [/#if]
      [/@]
  </div>
</div>

<div class="card card-primary card-outline">
  <div class="card-header">
    <h3 class="card-title">学生家庭信息</h3>
  </div>
  <div class="card-body">
      [@b.fieldset theme="list"]
      [#if hasHome?? && hasHome]
        [@b.textfield label="家庭电话" name="home.phone" value=(home.phone)! maxlength="100" style="width: 200px" /]
        [@b.textarea label="家庭地址" name="home.address" value=(home.address)! maxlength="100" style="width: 200px"/]
        [@b.textfield label="家庭地址邮编" name="home.postcode" value=(home.postcode)! maxlength="6" style="width: 200px"/]
        [@b.textfield label="户籍" name="home.formerAddr" value=(home.formerAddr)! maxlength="100" style="width: 200px"/]
        [@b.textfield label="派出所" name="home.police" value=(home.police)! maxlength="100" style="width: 200px"/]
        [@b.textfield label="派出所电话" name="home.policePhone" value=(home.policePhone)! maxlength="100" style="width: 200px"/]
        [@b.select label="火车站" name="home.railwayStation.id" items=railwayStations empty="..." value=(home.railwayStation.id)! style="width: 200px"/]
      [#else]
    <h6 style="color:red ">没有修改权限,请先配置数据权限</h6>
        [@b.textfield label="家庭电话" name="home.phone" value=(home.phone)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textarea label="家庭地址" name="home.address" value=(home.address)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="家庭地址邮编" name="home.postcode" value=(home.postcode)! maxlength="6" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="户籍" name="home.formerAddr" value=(home.formerAddr)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="派出所" name="home.police" value=(home.police)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="派出所电话" name="home.policePhone" value=(home.policePhone)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.select label="火车站" name="home.railwayStation.id" items=railwayStations empty="..." value=(home.railwayStation.id)! style="width: 200px" disabled = "diaabled"/]
      [/#if]
      [/@]
  </div>
</div>

<div class="card card-primary card-outline">
  <div class="card-header">
    <h3 class="card-title">考生信息</h3>
  </div>
  <div class="card-body">
      [@b.fieldset theme="list"]
      [#if hasExaminee?? && hasExaminee]
        [@b.textfield label="考生号" name="examinee.code" value=(examinee.code)! maxlength="100" style="width: 200px" /]
        [@b.textfield label="准考证号" name="examinee.examNo" value=(examinee.examNo)! maxlength="100" style="width: 200px"/]
        [@b.select label="生源地" name="examinee.originDivision.id" items=originDivisions empty="..." value=(examinee.originDivision.id)! style="width: 200px"/]
        [@b.textfield label="毕业学校编号" name="examinee.schoolNo" value=(examinee.schoolNo)! maxlength="6" style="width: 200px"/]
        [@b.textfield label="毕业学校名称" name="examinee.schoolName" value=(examinee.schoolName)! maxlength="100" style="width: 200px"/]
        [@b.datepicker label="毕业日期" id="examinee.graduateOn" name="examinee.graduateOn"
        value="${(examinee.graduateOn?string('yyyy-MM-dd'))?default('')}" style="width:200px"  format="yyyy-MM-dd" /]
        [@b.textfield label="招生录取总分" name="examinee.score" value=(examinee.score)! maxlength="100" style="width: 200px"/]
      [#else]
    <h6 style="color:red ">没有修改权限,请先配置数据权限</h6>
        [@b.textfield label="考生号" name="examinee.code" value=(examinee.code)! maxlength="100" style="width: 200px" disabled = "diaabled" /]
        [@b.textfield label="准考证号" name="examinee.examNo" value=(examinee.examNo)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.select label="生源地" name="examinee.originDivision.id" items=originDivisions empty="..." value=(examinee.originDivision.id)! style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="毕业学校编号" name="examinee.schoolNo" value=(examinee.schoolNo)! maxlength="6" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="毕业学校名称" name="examinee.schoolName" value=(examinee.schoolName)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.datepicker label="毕业日期" id="examinee.graduateOn" name="examinee.graduateOn"
        value="${(examinee.graduateOn?string('yyyy-MM-dd'))?default('')}" style="width:200px"  format="yyyy-MM-dd"  disabled = "diaabled"/]
        [@b.textfield label="招生录取总分" name="examinee.score" value=(examinee.score)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
      [/#if]
      [/@]
  </div>
</div>

    [@b.formfoot theme="list"]
      [@b.submit value="保存"/]
    [/@]
  [/@]
</div> <!--end container-->
[@b.foot/]

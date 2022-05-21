[#ftl]
[@b.head]
<link rel="stylesheet" type="text/css" href="${base}/static/scripts/commons/css/common.css">
<script src="${base}/static/scripts/common.js?v=2"></script>
[/@]

[@b.toolbar title='学生联系信息维护']
     bar.addBackOrClose();
[/@]
[@b.messages slash = "7"/]

[#if !((student.person.id)??)]
<div style="color: red">请先配置<span style="font-weight: bold">学生基本信息</span>！</div>
[/#if]
<div class="container">
  [@b.form name="studentForm" action="!saveContact" target="_self"]
    <input type="hidden" name="contact.id" value="${(contact.id)!}"/>
    <input type="hidden" name="student.id" value="${(student.id)!}"/>

    [#if restriction??]
      [#assign hasContact=false/]

      [#list restriction.metas as meta]
        [#if !hasContact][#assign hasContact = (meta.name == contactMeta)/][/#if]
      [/#list]
    [/#if]

<div class="card card-primary card-outline">
[#--  <div class="card-header">--]
[#--    <h3 class="card-title">学生联系信息</h3>--]
[#--  </div>--]
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
    [@b.formfoot theme="list"]
      [@b.submit value="保存"/]
    [/@]
  [/@]
</div> <!--end container-->
[@b.foot/]

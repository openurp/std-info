[#ftl]
[@b.head/]
[@b.div id="indexDiv"]
[@b.toolbar title='学籍信息' ]
  bar.addBlankItem();
[/@]
[#assign titleTdHTML] style="width:18%"[/#assign]
[#assign ContentTdHTML1] style="width:20%"[/#assign]
[#assign ContentTdHTML2] style="width:34%"[/#assign]
[@b.messages slash='7'/]
  [@b.tabs id="tabPane1"]
    [@b.tab label="学籍信息" target="tabPage1"/]
    [@b.tab label="资料申请修改" target="tabPage2"/]
    [#if basicInfo?exists][@b.tab label="学生基本信息" target="tabPage3"/][/#if]
    [#if enrollInfo?exists][@b.tab label="入学信息" target="tabPage4"/][/#if]
    [#if bachelorInfo?exists][@b.tab label="学位信息" target="tabPage5"/][/#if]
    [#if abroadStudent?exists][@b.tab label="留学生信息" target="tabPage6"/][/#if]
    [#if contactInfo?exists][@b.tab label="联系方式信息" target="tabPage7"/][/#if]
    [@b.div id="tabPage1"][#include "../studentSearch/info/info_student.ftl" /][/@]
    [@b.div id="tabPage2"]
      [#if isApply == false]
        [@b.form name="applyEditForm" action="!applyEdit" title="资料申请修改" theme="list" target="indexDiv"]
          [@b.textfield id="mail" label="电子邮箱" check="match('email').maxLength(20)" required="true" name="contact.mail" value="${(contactInfo.mail)!}" /]
          [@b.textfield id="phone" label="联系电话" check="maxLength(20)" required="true" name="contact.phone" value="${(contactInfo.phone)!}" /]
          [@b.textfield id="mobile" label="移动电话" check="maxLength(20)" required="true" name="contact.mobile" value="${(contactInfo.mobile)!}" /]
          [@b.textarea  id="address" label="通讯地址" check="maxLength(100)" required="true" name="contact.address" value="${(contactInfo.address)!}" style="width:400px;height:30px;" /]
          [@b.formfoot]
            <input value="提交" onclick="bg.form.submit('applyEditForm',null,null,validateData);return false;" type="submit">&nbsp;
            <input type="reset"  name="reset1" value="${b.text("action.reset")}" class="buttonStyle" />
          [/@]
        [/@]
      [#else]
        <center><b>资料正在审核中...<br/>资料修改申请成功,请带上相关证件（身份证、学生证）去学籍管理部门进行核实!</b></center>
      [/#if]
    [/@]
    [#if basicInfo?exists][@b.div id="tabPage3"][#include "../studentSearch/info/info_basic.ftl" /][/@][/#if]
    [#if enrollInfo?exists][@b.div id="tabPage4"][#include "../studentSearch/info/info_enroll.ftl" /][/@][/#if]
    [#if bachelorInfo?exists][@b.div id="tabPage5"][#include "../studentSearch/info/info_bachelor.ftl" /][/@][/#if]
    [#if abroadStudent?exists][@b.div id="tabPage6"][#include "../studentSearch/info/info_abroad.ftl" /][/@][/#if]
    [#if contactInfo?exists][@b.div id="tabPage7"][#include "../studentSearch/info/info_contact.ftl" /][/@][/#if]
  [/@]
[/@]
<script>
  function validateData() {
    var mail = jQuery("#mail").val();
    var phone = jQuery("#phone").val();
    var mobile = jQuery("#mobile").val();
    var address = jQuery("#address").val();
    if (mail=="${(contactInfo.mail)!}" && phone=="${(contactInfo.phone)!}"
      && mobile=="${(contactInfo.mobile)!}" && address=="${(contactInfo.address)!}") {
        alert("请修改资料后再进行提交!");
        return false;
    }
    return true;
  }
</script>
[@b.foot/]

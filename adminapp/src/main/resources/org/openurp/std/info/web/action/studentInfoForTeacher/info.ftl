[#ftl]
[@b.head /]
[@b.toolbar title='学籍详细信息' id='studentInfoBar']
      bar.addBackOrClose("${b.text('action.back')}", "${b.text('action.close')}");
[/@]
[#assign titleTdHTML] style="width:18%"[/#assign]
[#assign ContentTdHTML1] style="width:20%"[/#assign]
[#assign ContentTdHTML2] style="width:34%"[/#assign]
[@b.tabs]
  [@b.tab label="学籍信息"][#include "info/info_student.ftl" /][/@]
  [#if person?exists][@b.tab label="学生基本信息"][#include "info/info_person.ftl" /][/@][/#if]
  [#if examinee?exists][@b.tab label="考生信息" ][#include "info/info_examinee.ftl" /][/@][/#if]
  [#if admission?exists][@b.tab label="录取信息" ][#include "info/info_admission.ftl" /][/@][/#if]
  [#if contact?exists][@b.tab label="联系信息"][#include "info/info_contact.ftl" /][/@][/#if]
  [#if home?exists][@b.tab label="家庭信息"][#include "info/info_home.ftl" /][/@][/#if]
  [#if abroad?exists][@b.tab label="留学生信息"][#include "info/info_abroad.ftl" /][/@][/#if]
  [#if graduation?exists][@b.tab label="毕业信息"][#include "info/info_graduation.ftl" /][/@][/#if]
[/@]
[@b.foot /]

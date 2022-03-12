[#ftl]
[@b.head/]
[@b.toolbar title="学生资料修改申请对比"]
  bar.addClose();
[/@]
[#assign changed=0]
  <table width="95%" class="infoTable">
    <tr>
      <td colspan="3" height="25"><B>学生资料修改申请对比</B></td>
    </tr>
    <tr>
      <td width="12%"></td>
      <td width="30%" align="right">原始信息</td>
      <td width="58%">申请变动信息</td>
    </tr>
    [#if !(applyEditBean.before.mail)?? || applyEditBean.before.mail !=(applyEditBean.now.mail)?if_exists]
      [#assign changed=changed+1]
    <tr>
      <td>邮件：</td>
      <td align="right">${(applyEditBean.before.mail)!}</td>
      <td>${(applyEditBean.now.mail)!}</td>
    </tr>
    [/#if]
    [#if !(applyEditBean.before.phone)?? || applyEditBean.before.phone !=(applyEditBean.now.phone)?if_exists]
      [#assign changed=changed+1]
    <tr>
      <td>电话：</td>
      <td align="right">${(applyEditBean.before.phone)!}</td>
      <td>${(applyEditBean.now.phone)!}</td>
    </tr>
    [/#if]
    [#if !(applyEditBean.before.mobile)?? || applyEditBean.before.mobile !=(applyEditBean.now.mobile)!]
    [#assign changed=changed+1]
    <tr>
      <td>移动电话：</td>
      <td align="right">${(applyEditBean.before.mobile)!}</td>
      <td>${(applyEditBean.now.mobile)!}</td>
    </tr>
    [/#if]
    [#if !(applyEditBean.before.address)?? || applyEditBean.before.address !=(applyEditBean.now.address)!]
    [#assign changed=changed+1]
    <tr>
      <td>地址：</td>
      <td align="right">${(applyEditBean.before.address)!}</td>
      <td>${(applyEditBean.now.address)!}</td>
    </tr>
    [/#if]
    [#if changed==0]
      <tr>
      <td colspan="3">无修改项</td>
    </tr>
    [/#if]
  </table>
[@b.foot/]

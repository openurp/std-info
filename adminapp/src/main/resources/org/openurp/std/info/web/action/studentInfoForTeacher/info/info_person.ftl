<#if person?exists>
<table style="width:95%" align="center" class="infoTable">
    <tr>
        <td colspan="4" style="font-weight:bold;text-align:center" class="darkColumn">学生基本信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>曾用名：</td>
      <td ${ContentTdHTML1}>${(person.oldname)!}</td>
      <td class="title"${titleTdHTML}>民族：</td>
        <td ${ContentTdHTML2}>${(person.nation.name)!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>政治面貌：</td>
        <td>${(person.politicVisage.name)!}</td>
        <td class="title" ${titleTdHTML}>出生年月：</td>
        <td>${(person.birthday?string("yyyy-MM-dd"))!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>证件类型：</td>
        <td>${(person.idType.name)!}</td>
        <td class="title"${titleTdHTML}>证件号码：</td>
        <td>${(person.code)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>籍贯：</td>
        <td>${(person.ancestralAddr.name)!}</td>
       <td class="title"${titleTdHTML}>国家地区：</td>
        <td>${(person.country.name)!}</td>
    </tr>
    <tr>
      <td class="title" ${titleTdHTML}>婚姻状况：</td>
        <td>${(person.maritalStatus.name)!}</td>
      <td class="title" ${titleTdHTML}>入团(党)时间：</td>
      <td>${(person.joinOn?string("yyyy-MM-dd"))!}</td>
    </tr>
    <tr>
      <td class="title" ${titleTdHTML}>开户银行：</td>
      <td>${(person.bankAccount.bank)!}</td>
      <td class="title" ${titleTdHTML}>银行账号：</td>
        <td>${(person.bankAccount.account)!}</td>
    </tr>
</table>
</#if>

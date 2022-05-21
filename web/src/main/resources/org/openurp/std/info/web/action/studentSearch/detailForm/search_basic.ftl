<table class="infoTable">
  <tr>
    <td align="right">证件类型：</td>
    <td><@htm.i18nSelect datas=idTypes selected=(student.person.idType.id?string)?default("") name="student.person.idType.id" style="width:120px"><option value="">...</option></@></td>
    <td align="right">证件号码：</td>
    <td><input type="text" name="student.person.code" style="width:118px"/></td>
    <td align="right">出生年月：</td>
    <td><@b.datepicker id="birthday" style="width:118px" name="student.person.birthday" label="" format='yyyy-MM-dd' value="" readOnly="readOnly"/>
    </td>
    <td align="right">国家：</td>
    <td><@htm.i18nSelect datas=countries selected=(student.person.country.id?string)?default("") name="student.person.country.id" style="width:120px"><option value="">...</option></@></td>
  </tr>
  <tr>
    <td align="right">政治面貌：</td>
    <td><@htm.i18nSelect datas=politicVisages selected=(student.person.politicVisage.id?string)?default("") name="student.person.politicVisage.id" style="width:120px"><option value="">...</option></@></td>
    <td align="right">籍贯：</td>
    <td><input type="text" name="student.person.ancestralAddr" style="width:118px"/></td>
    <td align="right">婚姻状况：</td>
    <td><@htm.i18nSelect datas=maritalStatuses selected=(student.person.maritalStatus.id?string)?default("") name="student.person.maritalStatus.id" style="width:120px"><option value="">...</option></@></td>
    <td width="10%" align="right">民族：</td>
    <td><@htm.i18nSelect datas=nations selected=(student.person.nation.id?string)?default("") name="student.person.nation.id" style="width:120px" ><option value="">...</option></@></td>
  </tr>
  <tr>
    <td align="right">曾用名：</td>
    <td><input type="text" name="student.person.oldname" style="width:118px"/></td>
    <td align="right">入团(党)时间：</td>
    <td><@b.datepicker id="joinOn" style="width:118px" name="student.person.joinOn" label="" format='yyyy-MM-dd' value="" readOnly="readOnly"/>
    </td>
    <td align="right">银行账户：</td>
    <td><input type="text" name="student.person.bankAccount.account" style="width:110px"/></td>
    <td align="right">开户行：</td>
    <td><input type="text" name="student.person.bankAccount.bank" style="width:110px"/></td>
  </tr>
</table>

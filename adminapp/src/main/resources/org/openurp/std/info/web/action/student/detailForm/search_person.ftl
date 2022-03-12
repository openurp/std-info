[#ftl]
<table class="infoTable">
  <tr>
    <td align="right">英文名：</td>
    <td><input type="text" name="student.person.phoneticName" value="" maxlength="100" style="width: 120px"/></td>
    <td align="right">曾用名：</td>
    <td><input type="text" name="student.person.formerName" value="" maxlength="100" style="width: 120px"/></td>
    <td align="right">性别：</td>
    <td>[@b.select name="student.user.gender.id"  items=genders?sort_by("code") label=""  style="width:120px" empty="..." theme="html"/]</td>
    <td align="right">出生年月：</td>
    <td>[@b.datepicker style="width:120px" name="student.person.birthday" label="" format='yyyy-MM-dd' value=Parameters["student.person.birthday"]! readOnly="readOnly"/]</td>
  </tr>
  <tr>
    <td align="right">证件类型：</td>
    <td>[@b.select name="student.person.idType.id"  items=idTypes?sort_by("code") label=""  style="width:120px" empty="..." theme="html"/]</td>
    <td align="right">证件号码：</td>
    <td><input type="text" name="student.person.code" value="" maxlength="100" style="width: 120px"/></td>
    <td align="right">国家地区：</td>
    <td>[@b.select name="student.person.country.id"  items=countries?sort_by("code") label=""  style="width:120px" empty="..." theme="html"/]</td>
    <td align="right">民族：</td>
    <td>[@b.select name="student.person.nation.id"  items=nations?sort_by("code") label=""  style="width:120px" empty="..." theme="html"/]</td>
  </tr>
  <tr>
    <td align="right">籍贯：</td>
    <td><input type="text" name="student.person.homeTown" value="" maxlength="100" style="width: 120px"/></td>
    <td align="right"></td>
    <td></td>
    <td align="right"></td>
    <td></td>
    <td align="right"></td>
    <td></td>
  </tr>
</table>

[#ftl]
<table class="infoTable">
  <tr>
    <td align="right">毕结业情况：</td>
    <td>[@b.select name="graduation.educationResult.id"  items=educationResults?sort_by("code") label=""  style="width:120px" empty="..." theme="html"/]</td>
    <td align="right">毕业证书编号：</td>
    <td><input type="text" name="graduation.certificateNo" value="" maxlength="100" style="width: 120px"/></td>
    <td align="right">学位：</td>
    <td>[@b.select name="graduation.degree.id"  items=degrees?sort_by("code") label=""  style="width:120px" empty="..." theme="html"/]</td>
    <td align="right">学位授予日期：</td>
    <td>[@b.datepicker style="width:120px" name="graduation.degreeAwardOn" label="" format='yyyy-MM-dd' value=Parameters["graduation.degreeAwardOn"]! readOnly="readOnly"/]</td>
  </tr>
  <tr>
    <td align="right">学位证书号：</td>
    <td><input type="text" name="graduation.diplomaNo" value="" maxlength="100" style="width: 120px"/></td>
    <td align="right"></td>
    <td></td>
    <td align="right"></td>
    <td></td>
    <td align="right"></td>
    <td></td>
  </tr>
</table>

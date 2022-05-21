<table class="infoTable">
  <tr>
    <td align="right">英文名:</td>
    <td ><input type="text" style="width:118px" name="student.enName"/></td>
    <td align="right">性别:</td>
    <td><@htm.i18nSelect datas=genders selected=(student.person.gender.id?string)?default("") name="student.person.gender.id" style="width:120px"><option value="">...</option></@></td>
    <td  align="right">管理院系:</td>
    <td><@htm.i18nSelect datas=departments selected=(student.state.department.id?string)?default("") name="student.state.department.id" style="width:120px"><option value="">...</option></@></td>
    <td align="right">入校时间:</td>
    <td>
    <input id="beginOn" class="Wdate" type="text" style="width:122px" readonly="readOnly" value="" name="student.beginOn" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'endOn\')}'})"/>
    </td>
  </tr>
  <tr>
    <td align="right">学籍失效日期:</td>
    <td>
    <input id="endOn" class="Wdate" type="text" style="width:118px" readonly="readOnly" value="" name="student.endOn" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'beginOn\')}'})" />
    </td>
    <td align="right">学习形式:</td>
    <td><@htm.i18nSelect datas=studyTypes selected=(student.studyType.id?string)?default("") style="width:120px" name="student.studyType.id"><option value="">...</option></@></td>
  </tr>
</table>

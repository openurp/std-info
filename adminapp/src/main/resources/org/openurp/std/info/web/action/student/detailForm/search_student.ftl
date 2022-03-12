[#ftl]
<table class="infoTable">
  <tr>
    <td align="right">学习形式:</td>
    <td>[@b.select name="student.studyType.id"  items=studyTypes?sort_by("code") label=""  style="width:120px" empty="..." theme="html"/]</td>
    <td align="right">校区:</td>
    <td>[@b.select name="student.state.campus.id"  items=campuses?sort_by("code") label=""  style="width:120px" empty="..." theme="html"/]</td>
    <td align="right">学籍开始:</td>
    <td>[@b.datepicker id="state_beginOn_in_search" label="" name="student.state.beginOn" maxDate="#F{$dp.$D(\\'state_endOn_in_search\\')}" format="yyyy-MM-dd" readonly="readonly" value=Parameters["student.state.beginOn"]! style="width: 120px"/]</td>
    <td align="right">学籍结束:</td>
    <td>[@b.datepicker id="state_endOn_in_search" label="" name="student.state.endOn" minDate="#F{$dp.$D(\\'state_beginOn_in_search\\')}" format="yyyy-MM-dd" readonly="readonly" value=Parameters["student.state.endOn"]! style="width: 120px"/]</td>
  </tr>
  <tr>
    <td align="right">入学报到日期:</td>
    <td>[@b.datepicker style="width:120px" name="student.studyOn" label="" format='yyyy-MM-dd' value=Parameters["student.studyOn"]! readOnly="readOnly"/]</td>
    <td align="right">应毕业时间:</td>
    <td>[@b.datepicker style="width:120px" name="student.graduateOn" label="" format='yyyy-MM-dd' value=Parameters["student.graduateOn"]! readOnly="readOnly"/]</td>
    <td align="right">学生分类标签:</td>
    <td>
      <select name="stdLabelId" style="width: 120px">
        <option value="">...</option>
      [#if stdLabels?exists]
        [#list stdLabels as stdLabel]
        <option value="${stdLabel.id}">${stdLabel.labelType.name}-${stdLabel.name}</option>
        [/#list]
      [/#if]
      </select>
    </td>
    <td align="right"></td>
    <td></td>
  </tr>
</table>

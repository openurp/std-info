<table class="infoTable">
  <tr>
    <td width="10%" align="right">CSC编号：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdAbroad.cscno"/></td>
    <td width="10%" align="right">HSK等级：</td>
    <td width="15%">
    <@htm.i18nSelect datas=hskLevels selected=(stdAbroad.HskLevel.id?string)?default("") name="stdAbroad.HskLevel.id" style="width:122px"><option value="">...</option></@>
    </td>
    <td width="10%" align="right">护照编号：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdAbroad.passportNo"/></td>
    <td width="10%" align="right">护照到期时间：</td>
    <td width="15%"><input id="passportExpiredOn" class="Wdate" type="text" style="width:118px" readonly="readOnly" value="" name="stdAbroad.passportExpiredOn" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></td>
  </tr>
  <tr>
    <td align="right">护照类别：</td>
    <td >
      <@htm.i18nSelect datas=passportTypes selected=(stdAbroad.passportType.id?string)?default("") name="stdAbroad.passportType.id" style="width:120px"><option value="">...</option></@>
    </td>
    <td align="right">签证编号：</td>
    <td><input type="text" style="width:118px" name="stdAbroad.visaNo"/></td>
    <td align="right">签证到期时间：</td>
    <td><input id="visaExpiredOn" class="Wdate" type="text" style="width:118px" readonly="readOnly" value="" name="stdAbroad.visaExpiredOn" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"/></td>
    <td align="right">签证类别：</td>
    <td>
    <@htm.i18nSelect datas=visaTypes selected=(stdAbroad.visaType.id?string)?default("") name="stdAbroad.visaType.id" style="width:120px"><option value="">...</option></@>
    </td>
  </tr>
  <tr>
    <td align="right">居住证编号：</td>
    <td><input type="text" style="width:118px" name="stdAbroad.resideCaedNo"/></td>
    <td align="right">居住证到期时间：</td>
    <td><input id="resideCaedExpiredOn" class="Wdate" type="text" style="width:118px" readonly="readOnly" value="" name="stdAbroad.resideCaedExpiredOn" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})"/>
    </td>
  </tr>
</table>

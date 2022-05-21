<table class="infoTable">
  <tr>
    <td width="10%" align="right">通讯地址：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdContact.address"/></td>
    <td width="10%" align="right">联系电话：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdContact.phone"/></td>
    <td width="10%" align="right">移动电话：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdContact.mobile"/></td>
    <td width="10%" align="right">电子邮件：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdContact.mail"/></td>
  </tr>
  <tr>
    <td width="8%" align="right">家庭电话：</td>
    <td width="15%"><input type="text" style="width:118px" name="home.phone"/></td>
    <td width="8%" align="right">家庭地址：</td>
    <td width="15%"><input type="text" style="width:118px" name="home.address"/></td>
    <td width="8%" align="right">家庭地址邮编：</td>
    <td width="15%"><input type="text" style="width:118px" name="home.postcode"/></td>
    <td width="8%" align="right">家庭成员：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdMember.name"/></td>
  </tr>
  <tr>
    <td width="8%" align="right">工作单位名称：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdMember.workPlace"/></td>
    <td width="8%" align="right">工作单位地址：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdMember.address"/></td>
    <td width="8%" align="right">工作地址邮编：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdMember.postCode"/></td>
    <td width="8%" align="right">工作单位电话：</td>
    <td width="15%"><input type="text" style="width:118px" name="stdMember.phone"/></td>
  </tr>
  <tr>
    <td width="8%" align="right">火车站：</td>
    <td width="15%">
      <@htm.i18nSelect datas=railwayStations! selected=(home.railwayStation.id?string)?default("") name="home.railwayStation.id" style="width:120px"><option value="">...</option></@>
    </td>
  </tr>
</table>

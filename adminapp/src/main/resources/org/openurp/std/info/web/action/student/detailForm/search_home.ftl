[#ftl]
<table class="infoTable">
  <tr>
    <td align="right">家庭电话：</td>
    <td><input type="text" name="home.phone" value="" maxlength="100" style="width: 120px"/></td>
    <td align="right">家庭地址：</td>
    <td><input type="text" name="home.address" value="" maxlength="100" style="width: 120px"/></td>
    <td align="right">家庭地址邮编：</td>
    <td><input type="text" name="home.postcode" value="" maxlength="6" style="width: 120px"/></td>
    <td align="right">户籍：</td>
    <td><input type="text" name="home.formerAddr" value="" maxlength="100" style="width: 120px"/></td>
  </tr>
  <tr>
    <td align="right">派出所：</td>
    <td><input type="text" name="home.police" value="" maxlength="100" style="width: 120px"/></td>
    <td align="right">派出所电话：</td>
    <td><input type="text" name="home.policePhone" value="" maxlength="100" style="width: 120px"/></td>
    <td align="right">火车站：</td>
    <td>[@b.select name="home.railwayStation.id"  items=railwayStations?sort_by("code") label=""  style="width:120px" empty="..." theme="html"/]</td>
  </tr>
</table>

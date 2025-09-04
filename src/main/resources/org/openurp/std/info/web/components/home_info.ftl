[#ftl]
  <table class="table table-sm table-detail">
    <colgroup>
      <col width="13%">
      <col width="20%">
      <col width="13%">
      <col width="20%">
      <col width="14%">
      <col width="20%">
    </colgroup>
    <tr>
      <td class="title">家庭电话:</td>
      <td>${(home.phone?html)!}</td>
      <td class="title">家庭邮编:</td>
      <td>${(home.postcode?html)!}</td>
      <td class="title">户籍:</td>
      <td>${(home.formerAddr?html)!}</td>
    </tr>
    <tr>
      <td class="title">家庭地址:</td>
      <td colspan="5">${(home.address?html)!}</td>
    </tr>
    <tr>
      <td class="title">派出所:</td>
      <td>${(home.police?html)!}</td>
      <td class="title">派出所电话:</td>
      <td>${(home.policePhone?html)!}</td>
      <td class="title">火车站:</td>
      <td>${(home.railwayStation.name)?if_exists}</td>
    </tr>
  </table>

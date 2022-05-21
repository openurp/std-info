[#ftl]
[#if !((student.person.id)??)]
<div style="color: red">请先配置<span style="font-weight: bold">学生基本信息</span>！</div>
[#elseif !((home.id)??)]
<div style="color: red">当前学生家庭信息还未配置！</div>
[/#if]

  <table class="infoTable">
    <tr>
      <td class="title" width="10%">家庭电话：</td>
      <td width="23%">${(home.phone?html)!}</td>
      <td class="title" width="10%">家庭地址邮编：</td>
      <td width="23%">${(home.postcode?html)!}</td>
      <td class="title" width="10%">户籍：</td>
      <td>${(home.formerAddr?html)!}</td>
    </tr>
    <tr>
      <td class="title">家庭地址：</td>
      <td colspan="5">${(home.address?html)!}</td>
    </tr>
    <tr>
      <td class="title">派出所：</td>
      <td colspan="3">${(home.police?html)!}</td>
      <td class="title">派出所电话：</td>
      <td>${(home.policePhone?html)!}</td>
    </tr>
    <tr>
      <td class="title">火车站：</td>
      <td>${(home.railwayStation.name)?if_exists}</td>
      <td class="title">家庭经济状况：</td>
      <td>${(home.economicState.name)?if_exists}</td>
      [#if (home.id)??]
      <td class="title">最近维护时间：</td>
      <td>${(home.updatedAt?string("yyyy-MM-dd"))!}</td>
      [#else]
      <td class="title"></td>
      <td></td>
      [/#if]
    </tr>
  </table>

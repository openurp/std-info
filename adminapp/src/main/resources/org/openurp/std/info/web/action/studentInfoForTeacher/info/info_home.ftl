<#if home?exists>
<table style="width:95%" align="center" class="infoTable">
     <tr class="darkColumn">
      <td colspan="4" style="font-weight:bold;text-align:center" class="darkColumn">家庭联系方式</td>
     </tr>
     <tr>
      <td class="title"${titleTdHTML}>家庭电话：</td>
         <td ${ContentTdHTML1}>${(home.phone)?if_exists}</td>
        <td class="title"${titleTdHTML}>家庭地址：</td>
        <td ${ContentTdHTML2}>${(home.address)?if_exists}</td>
    </tr>
     <tr>
      <td class="title"${titleTdHTML}>家庭地址邮编：</td>
        <td ${ContentTdHTML1}>${(home.postcode)?if_exists}</td>
        <td class="title">火车站：</td>
        <td ${ContentTdHTML2}>${(home.railwayStation.name)?if_exists}</td>
    </tr>
</table>
<table style="width:95%" align="center" class="infoContactTable">
      <tr>
        <td class="title">家庭成员姓名</td>
        <td class="title">与本人关系</td>
        <td class="title">联系电话</td>
        <td class="title">工作单位名称</td>
        <td class="title">工作单位邮编</td>
        <td class="title">工作单位地址</td>
      </tr>
      <#list (home.members)?if_exists as member>
      <tr>
        <td align="center">${(member.name)?if_exists}</td>
        <td align="center">${member.relation.name}</td>
        <td align="center">${(member.phone)?if_exists}</td>
        <td align="center">${(member.workplace)?if_exists}</td>
        <td align="center">${(member.postcode)?if_exists}</td>
        <td align="center">${(member.address)?if_exists}</td>
      </tr>
      </#list>
</table>
</#if>

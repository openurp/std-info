<#if contactInfo?exists>
<style>
table.infoContactTable {
  vertical-align: middle;
  width:100%;
  border-collapse: collapse;
  background-color: #EEEEEE;
}

table.infoContactTable td {
  border: 1px solid #FFFFFF;
}
table.infoContactTable th {
  background-color: #E1ECFF;
  height: 22px;
}

.infoContactTable .title{
  height: 22px;
  width: 12%;
  background-color:#F5EDDB;
  padding-left: 2px;
  padding-right: 2px;
  text-align:center;
}
.infoContactTable .content{
  padding-left: 1px;
  padding-right: 1px;
}

</style>
<table style="width:95%" align="center" class="infoTable">
    <tr>
        <td colspan="4" style="font-weight:bold;text-align:center" class="darkColumn">联系信息</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>电子邮箱：</td>
        <td ${ContentTdHTML1}>${(contactInfo.mail)?if_exists}</td>
       <td class="title"${titleTdHTML}>联系电话：</td>
        <td ${ContentTdHTML2}>${(contactInfo.phone)?if_exists}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>移动电话：</td>
        <td ${ContentTdHTML1}>${(contactInfo.mobile)?if_exists}</td>
       <td class="title"${titleTdHTML}>通讯地址：</td>
        <td ${ContentTdHTML2}>${(contactInfo.address)?if_exists}</td>
    </tr>
    <tr  class="darkColumn">
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

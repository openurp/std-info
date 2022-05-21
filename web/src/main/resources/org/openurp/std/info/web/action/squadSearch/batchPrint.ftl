<@b.head/>
<#macro i18nName(entity)><#if locale.language?index_of("en")!=-1><#if entity.engName!?trim=="">${entity.name!}<#else>${entity.engName!}</#if><#else><#if entity.name!?trim!="">${entity.name!}<#else>${entity.engName!}</#if></#if></#macro>
<style>
.printTableStyle {
  border-collapse: collapse;
    border:solid;
  border-width:2px;
    border-color:#006CB2;
    vertical-align: middle;
    font-style: normal;
  font-size: 10pt;
}
table.printTableStyle td {
    -moz-border-bottom-colors: none;
    -moz-border-image: none;
    -moz-border-left-colors: none;
    -moz-border-right-colors: none;
    -moz-border-top-colors: none;
    border-color: #006CB2;
    border-style: solid;
    border-width: 0 2px 2px 0;
    height: 26px;
}
.darkColumn {
    background-color: #C7DBFF;
    color: #000000;
    letter-spacing: 0;
    text-decoration: none;
}
.brightStyle {
    background-color: white;
    color: #000000;
    letter-spacing: 0;
    text-decoration: none;
}
</style>
<#macro stdinfo std>
 ${std.name!}
<#if status[std.user.code]?? && !status[std.user.code].inschool><font color="red">(${status[std.user.code].status.name})</font></#if>
</#macro>
<#assign pagePrintRow = 30/>
<@b.toolbar title="班级学生名单打印">
    bar.addPrint();
    bar.addBackOrClose();
</@>
   <#list adminClasses as adminClass >
   <#assign boycount=0/>
   <#assign girlcount=0/>
    <#assign stds=(stdMap[adminClass.id?string])?if_exists>
    <br>
     <table width="100%" align="center"  >
     <tr>
      <td align="center" colspan="10" style="font-size:17pt">
       <B>班级学生名单</B>
      </td>
     </tr>
     <tr><td>&nbsp;</td></tr>
     <tr>
       <td colSpan="10" style="font-size:12pt" id="class${adminClass.id}">班级：<@i18nName adminClass?if_exists/></td>
     </tr>
   </table>
   <#assign pageIndexs=(stds?size/(pagePrintRow*2))?int/>
   <#if ((stds?size)>(pageIndexs*(pagePrintRow*2)))>
   <#assign pageIndexs=pageIndexs+1/>
   </#if>
   <#if (pageIndexs<1)>
     <#assign pageIndexs=1/>
   </#if>
   <#list 0..pageIndexs-1 as pageIndex>
   <#assign passNo=pageIndex*pagePrintRow*2/>

   <table class="printTableStyle"  width="100%"  >
     <tr class="darkColumn" align="center">
       <td width="6%">序号</td>
       <td width="10%">${b.text('attr.stdNo')}</td>
       <td width="15%">${b.text('attr.personName')}</td>
       <td width="6%">${b.text('entity.gender')}</td>
       <td width="10%">备注</td>
       <td width="6%">序号</td>
       <td width="10%">${b.text('attr.stdNo')}</td>
       <td width="15%">${b.text('attr.personName')}</td>
       <td width="6%">${b.text('entity.gender')}</td>
       <td width="10%">备注</td>
     </tr>
     <#assign stdCount = 0/>
     <#list 0..pagePrintRow-1 as i>
     <tr class="brightStyle">
         <#if stds[i+passNo]?exists>
       <td>${i+1+passNo}</td>
       <td>${stds[i+passNo].code}</td>
       <td><@stdinfo stds[i+passNo]/></td>
       <td><@i18nName stds[i+passNo].gender/><#if stds[i+passNo].gender.id=1><#assign boycount=boycount+1/><#elseif stds[i+passNo].gender.id=2><#assign girlcount=girlcount+1/></#if></td>
         <#else><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
         </#if>
       <td></td>
             <#if stds[i+pagePrintRow+passNo]?exists>
       <td>${i+pagePrintRow+1+passNo}</td>
       <td>${(stds[i+pagePrintRow+passNo].code)!}</td>
       <td><@stdinfo stds[i+pagePrintRow+passNo]?if_exists/></td>
       <td><@i18nName (stds[i+pagePrintRow+passNo].gender)?if_exists/>
             <#if (stds[i+pagePrintRow+passNo].gender.id)?if_exists?string='1'>
                   <#assign boycount=boycount+1/>
             <#elseif (stds[i+pagePrintRow+passNo].gender.id)?if_exists?string='2'>
                   <#assign girlcount=girlcount+1/>
             </#if>
             </td>
             <#else><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>
             </#if>
       <td></td>
     </tr>
     </#list>
     </table>
     <#if pageIndex_has_next><div style='PAGE-BREAK-AFTER: always'></div><br></#if>
     </#list>
     <script>
         var titletd=document.getElementById("class${adminClass.id}");
         titletd.innerHTML=titletd.innerHTML+"&nbsp;&nbsp;人数：${stds?size}&nbsp;&nbsp;男:${boycount}&nbsp;&nbsp;女:${girlcount}";
   </script>
   </#list>
  <form method="post" action="" name="actionForm"></form>
  <script>
    var form = document.actionForm;
  </script>
<@b.foot/>

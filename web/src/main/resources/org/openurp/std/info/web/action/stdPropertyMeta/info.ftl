[#ftl]
[@b.head/]
[@b.toolbar title=""]
  bar.addItem("${b.text('action.back')}","goBack2()");
[/@]
  <table style="width:95%" align="center" class="infoTable">
        <tr>
            <td colspan="13" style="font-weight:bold;text-align:center" class="darkColumn">属性元详细信息</td>
        </tr>
        [#assign titleTdHTML] style="width:25%"[/#assign]
        <tr>
            <td class="title"${titleTdHTML}>所属实体元名称：</td>
            <td width="25%">${(propertyMeta.meta.name?html)!}</td>
            <td class="title"${titleTdHTML}>所属实体元说明：</td>
            <td width="25%">${(propertyMeta.meta.comments?html)!}</td>
        </tr>
        <tr>
            <td class="title"${titleTdHTML}>属性元名称：</td>
            <td>${(propertyMeta.name?html)!}</td>
            <td class="title"${titleTdHTML}>属性元说明：</td>
            <td>${(propertyMeta.comments?html)!}</td>
        </tr>
        <tr>
            <td class="title"${titleTdHTML}>属性元类型：</td>
            <td>${(propertyMeta.type?html)!}</td>
            <td class="title"${titleTdHTML}>备注：</td>
            <td>${(propertyMeta.remark?html)!}</td>
        </tr>
    </table>
    [@b.form name="goBackForm2" action="!search"/]
  <script language="JavaScript">
    function goBack2(){
      bg.form.submit("goBackForm2");
    }
  </script>
[@b.foot/]

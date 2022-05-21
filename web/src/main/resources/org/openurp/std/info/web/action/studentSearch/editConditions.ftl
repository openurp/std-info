<#include "/template/head.ftl"/>
<BODY>
  <table width="50%" align="center" class="formTable" style="margin-top:100px">
    <form action="studentSearch.action?method=saveConditions" name="baseCodeForm" method="post">
    <@searchParams/>
    <tr class="darkColumn">
      <td align="left" colspan="4"><B>查询条件名称</B></td>
    </tr>
    <tr>
      <td width="15%" id="f_code" class="title"><font color="red">*</font>查询条件名称:</td>
      <td width="35%" >
      <input id="codeValue" type="text" name="t.conditionName" value="" style="width:300px;"/>
      <input type="hidden" name="t.conditions" value="${conditions}"/>
      </td>
    </tr>
    <tr  class="darkColumn" align="center">
      <td colspan="6">
          <input type="submit" onClick='submit1(this.form)' value="<@text name="system.button.submit"/>" class="buttonStyle"/>
      </td>
    </tr>
  </form>
</body>
</html>

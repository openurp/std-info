<form method="post" action="" name="actionFormAbroad" >
  <table style="width:100%" align="center" class="infoTable">

        <#if student??>
            <#assign pageCaption = "修改"/>
            <input type="hidden" name="student.id" value="${(student.id)!}"/>
            <input type="hidden" name="studentId" value="${(student.id)!}"/>
            <input type="hidden" name="abroadStudent.id" value="${(abroadStudent.id)!}"/>
        </#if>
        <@b.messages slash="7"/>
         <tr>
          <td class="title"  width="15%">CSC 编号:</td>
            <td width="35%">
              <#if abroadResitrict?seq_contains("cscno")>
          <input type="text" id="cscno" title="CSC编号" maxLength="20" name="abroadStudent.cscno" value="${(abroadStudent.cscno)?if_exists}" style="width:150px"/>
        <#else>
          ${(abroadStudent.cscno)?if_exists}
        </#if>
            </td>
            <td class="title" width="15%">HSK等级:</td>
            <td width="35%">
              <#if abroadResitrict?seq_contains("HskLevel")>
          <@htm.i18nSelect datas=hskLevels?sort_by("code") selected=(abroadStudent.HskLevel.id?string)!
            name="abroadStudent.HskLevel.id" id="hskLevel" style="width:156px"><option value="">...</option></@>
        <#else>
          <@i18nName (abroadStudent.HskLevel)!/>
        </#if>
            </td>
        </tr>
         <tr>
           <td class="title">护照编号:</td>
            <td>
              <#if abroadResitrict?seq_contains("passportNo")>
          <input type="text" id="passportNo" title="护照编号" maxLength="20" name="abroadStudent.passportNo" value="${(abroadStudent.passportNo)?if_exists}" style="width:150px"/>
        <#else>
          ${(abroadStudent.passportNo)?if_exists}
        </#if>
            </td>
          <td class="title">护照类别:</td>
            <td>
              <#if abroadResitrict?seq_contains("passportType")>
          <@htm.i18nSelect datas=passportTypes?sort_by("code") selected=(abroadStudent.passportType.id?string)!
            name="abroadStudent.passportType.id" id="hskLevel" style="width:156px"><option value="">...</option></@>
        <#else>
          <@i18nName (abroadStudent.passportType)!/>
        </#if>
            </td>
        </tr>
         <tr>
           <td class="title">护照到期时间:</td>
            <td>
              <#if abroadResitrict?seq_contains("passportExpiredOn")>
          <input type="text" name="abroadStudent.passportExpiredOn" class="Wdate" value="${(abroadStudent.passportExpiredOn)?if_exists}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})" style="width:154px"/>
        <#else>
          ${(abroadStudent.passportExpiredOn?string("yyyy-MM-dd"))?if_exists}
        </#if>
            </td>
          <td class="title">签证编号:</td>
            <td>
              <#if abroadResitrict?seq_contains("visaNo")>
          <input type="text" id="visaNo" title="签证编号" maxLength="20" name="abroadStudent.visaNo" value="${(abroadStudent.visaNo)?if_exists}" style="width:150px"/>
        <#else>
          ${(abroadStudent.visaNo)?if_exists}
        </#if>
            </td>
        </tr>
         <tr>
           <td class="title">签证类别:</td>
            <td>
              <#if abroadResitrict?seq_contains("visaType")>
          <@htm.i18nSelect datas=visaTypes?sort_by("code") selected=(abroadStudent.visaType.id?string)!
            name="abroadStudent.visaType.id" id="visaType" style="width:156px"><option value="">...</option></@>
        <#else>
          <@i18nName (abroadStudent.visaType)!/>
        </#if>
            </td>
          <td class="title">签证到期时间:</td>
            <td>
              <#if abroadResitrict?seq_contains("visaExpiredOn")>
          <input type="text" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})" name="abroadStudent.visaExpiredOn" value="${((abroadStudent.visaExpiredOn)?string("yyyy-MM-dd"))!}"  style="width:154px"/>
        <#else>
          ${(abroadStudent.visaExpiredOn?string("yyyy-MM-dd"))!}
        </#if>
            </td>
        </tr>
         <tr>
          <td class="title"> 居住许可证编号:</td>
            <td>
              <#if abroadResitrict?seq_contains("resideCaedNo")>
          <input type="text" id="resideCaedNo" title="居住许可证编号" maxLength="20" name="abroadStudent.resideCaedNo" value="${(abroadStudent.resideCaedNo)?if_exists}" style="width:150px"/>
        <#else>
          ${(abroadStudent.resideCaedNo)!}
        </#if>
            </td>
          <td class="title">居住许可证到期时间:</td>
            <td>
              <#if abroadResitrict?seq_contains("resideCaedExpiredOn")>
          <input type="text" class="Wdate" name="abroadStudent.resideCaedExpiredOn" value="${((abroadStudent.resideCaedExpiredOn)?string("yyyy-MM-dd"))!}" style="width:154px" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',readOnly:true})"/>
        <#else>
          ${(abroadStudent.resideCaedExpiredOn?string("yyyy-MM-dd"))?if_exists}
        </#if>
            </td>
        </tr>
        <#if abroadResitrict?size!=0>
         <tr>
            <td colspan="4" align="center">
            <input type="button" onclick="saveAbroad()" value="  保存   "/>
            </td>
        </tr>
        </#if>
            <input type="hidden" name="params" value="<#list Parameters?keys as key><#if key?string != "method" && key?string != "studentId" && key?string != "params">&${key}=${Parameters[key?string]}</#if></#list>">
    </table>
</form>
<script>
  beangle.load(["jquery-validity"]);
  function saveAbroad() {
    var res = null;
    jQuery.validity.start();
    var form = document.actionFormAbroad;
    <#if abroadResitrict?seq_contains("cscno")>
    jQuery("#cscno").match(/^[A-Za-z0-9]+$/g,'只允许输入数字和字母');//CSC编号
    </#if>
    <#if abroadResitrict?seq_contains("passportNo")>
    jQuery("#passportNo").match(/^[A-Za-z0-9]+$/g,'只允许输入数字和字母');//护照编号
    </#if>
    <#if abroadResitrict?seq_contains("visaNo")>
    jQuery("#visaNo").match(/^[A-Za-z0-9]+$/g,'只允许输入数字和字母');//签证编号
    </#if>
    <#if abroadResitrict?seq_contains("resideCaedNo")>
    jQuery("#resideCaedNo").match(/^[A-Za-z0-9]+$/g,'只允许输入数字和字母');//居住许可证编号
    </#if>
    res = jQuery.validity.end().valid;
    if(false == res) {
        return false;
    }
    form.action = "studentInfo.action?method=saveAbroad";
    form.submit();
  }
</script>

<#assign studentKeys = ["std.user.code", "std.user.name" ,"std.person.phoneticName", "std.person.gender.name", "std.state.grade","std.duration",
  "std.project.name","std.level.name","std.stdType.name","std.state.department.name","std.state.major.name","std.state.direction.name",
  "std.beginOn", "std.endOn","std.studyType.name","active",
  "inschool","std.state.squad.name","std.state.campus.name", "std.remark"] />

<#assign personKeys = ["std.person.formerName", "std.person.nation.name", "std.person.politicVisage.name", "std.person.birthday","std.person.idType.name","std.person.code",
  "std.person.ancestralAddr.name", "std.person.country.name","std.person.maritalStatus.name", "std.person.joinOn","std.person.charactor","std.person.bankAccount.account","std.person.bankAccount.bank"] />

<#assign admissionKeys = ["stdAdmission.letterNo","stdAdmission.admissionIndex","stdAdmission.admissionType.name","stdAdmission.department.name","stdAdmission.major.name", "stdAdmission.feeOrigin.name"] />

<#assign admissionMajorKeys = ["stdAdmissionMajor.majorCode", "stdAdmissionMajor.majorName", "stdAdmissionMajor.disciplineCategory.name", "stdAdmissionMajor.degree.name",
   "stdAdmissionMajor.degreeAwardOn","stdAdmissionMajor.degreeAwardBy","stdAdmissionMajor.recommendBy","stdAdmissionMajor.certificateNo"] />

<#assign examineeKeys = ["stdExaminee.level.name", "stdExaminee.originDivision.name", "stdExaminee.examNumber", "stdExaminee.examineeCode",
   "stdExaminee.schoolNo", "stdExaminee.schoolName", "stdExaminee.graduateOn","stdExaminee.enrollMode.name","stdExaminee.educationMode.name",
   "stdExaminee.examineeType.name","stdExaminee.score"] />

<#assign graduateKeys = ["stdGraduation.graduateState.name", "stdGraduation.certificateNo", "stdGraduation.degree.name", "stdGraduation.degreeAwardOn",
   "stdGraduation.diplomaNo"] />

<#assign homeKeys = ["stdHome.phone", "stdHome.address", "stdHome.postcode", "stdHome.formerAddr",
   "stdHome.police", "stdHome.policePhone", "stdHome.railwayStation.name", "stdHome.members", "stdHome.economicState.name"] />

<#assign contactKeys = ["stdContact.mail", "stdContact.phone", "stdContact.mobile", "stdContact.address"] />

<#assign abroadKeys = ["stdAbroad.cscno", "stdAbroad.HskLevel", "stdAbroad.passportNo", "stdAbroad.passportType.name", "stdAbroad.passportExpiredOn",
  "stdAbroad.visaNo", "stdAbroad.visaType.name", "stdAbroad.visaExpiredOn", "stdAbroad.resideCaedNo", "stdAbroad.resideCaedExpiredOn"] />

<#assign allKeyMap = {
  'studentKeys' : studentKeys,
  'personKeys' : personKeys,
  'admissionKeys' : admissionKeys,
  'admissionMajorKeys' : admissionMajorKeys,
  'examineeKeys' : examineeKeys,
  'graduateKeys' : graduateKeys,
  'homeKeys':homeKeys,
  'contactKeys':contactKeys,
  'abroadKeys':abroadKeys
  } />

<div style="display:none">
<div id="selectColumnExport">
    <table width="650px" align="center" id="exportTb">
      <tr>
        <input id="checkAll" type="checkbox" class="allCheck" onclick="selectedAll(this)"><font color="red">学生信息全选/全不选</font>
      </tr>

      <#list allKeyMap?keys as allKey>
      <#assign exportKeys = allKeyMap[allKey] />
      <#assign f_count = 6 - (exportKeys?size % 6) />
      <tr class="grayStyle">
        <td colspan="6" height="25"><B>${b.text("i18n_student_" + allKey)}</B>&nbsp;&nbsp;
          <input name="chk_submenu"  type="checkbox" onclick="selected('chk_${allKey}',this)"/>全选/全不选</td>
      </tr>
      <#list exportKeys as key>
        <#if (key_index + 1) % 6 == 1>
        <tr class="grayStyle">
        </#if>
          <td width="16%">
            <input type="checkbox" name="chk_${allKey}" value="${key};${b.text("i18n_student_" + key)}" <#if key=="std.user.code">class="stdCodeClass" onChange="this.checked='true';"</#if> />${b.text("i18n_student_" + key)}
          </td>
        <#if (key_index + 1) % 6 == 0>
        </tr>
        </#if>
      </#list>
        <#if f_count != 0 && f_count != 6>
          <#list 1..f_count as i>
            <td>&nbsp;</td>
          </#list>
          </tr>
        </#if>
      </#list>

      <tr class="grayStyle">
        <td align="center" colspan="6" height="25"><input type="button" id="btn_export" value="导  出" onclick="toExport()" /></td>
      </tr>
    </table>
</div>
</div>

<script>
  initSelected();
  function initSelected(){
    var allCheckBoxs = jQuery("#exportTb input[type=checkbox]");
    for(var i=0;i<allCheckBoxs.length;i++){
      allCheckBoxs[i].checked=false;
    }
    jQuery(".stdCodeClass")[0].checked=true;
  }
  function selected(chName,obj) {
    var allIds = document.getElementsByName(chName);
    for(var i=0;i<allIds.length;i++) {
         allIds[i].checked=obj.checked;
      }
      if(obj.id=="checkAll"){
        var chkSubmenu = document.getElementsByName("chk_submenu");
        for(var i=0;i<chkSubmenu.length;i++) {
           chkSubmenu[i].checked=obj.checked;
        }
      }
      jQuery(".stdCodeClass")[0].checked=true;
  }

  function selectedAll(obj) {
    <#list allKeyMap?keys as allKey>
      selected("chk_${allKey}",obj);
    </#list>
  }

  function toExport() {
    var keys = "";
    var titles = "";
    <#list allKeyMap?keys as allKey>
      keys += getKeys("chk_${allKey}");
    </#list>
    <#list allKeyMap?keys as allKey>
      titles += getTitles("chk_${allKey}");
    </#list>
    var allCheckBox = jQuery("#exportTb input[type=checkbox]");
    if(!jQuery(".stdCodeClass")[0].checked){
      alert("学号必须选择!");
      return;
    }
    var queryAdmission = false;
    var queryAdmissionMajor = false;
    var queryExaminee = false;
    var queryGraduation = false;
    var queryActive = false;
    var queryInschool = false;
    var queryHome = false;
    var queryContact = false;
    var queryAbroad = false;
    var queryMember = false;
    for(var i=0;i<allCheckBox.length;i++){
      if(allCheckBox[i].checked){
        if(allCheckBox[i].value.indexOf("stdAdmission.")!=-1){
          queryAdmission=true;
        }
        if(allCheckBox[i].value.indexOf("stdExaminee.")!=-1){
          queryExaminee=true;
        }
        if(allCheckBox[i].value.indexOf("stdAdmissionMajor.")!=-1){
          queryAdmissionMajor=true;
        }
        if(allCheckBox[i].value.indexOf("stdGraduation.")!=-1){
          queryGraduation=true;
        }
        if(allCheckBox[i].value.indexOf("stdHome.")!=-1){
          queryHome=true;
        }
        if(allCheckBox[i].value.indexOf("stdContact.")!=-1){
          queryContact=true;
        }
        if(allCheckBox[i].value.indexOf("stdAbroad.")!=-1){
          queryAbroad=true;
        }
        if(allCheckBox[i].value.indexOf(".members")!=-1){
          queryMember=true;
        }
        if(allCheckBox[i].value.indexOf("active")!=-1){
          queryActive = true;
        }
        if(allCheckBox[i].value.indexOf("inschool")!=-1){
          queryInschool = true;
        }
      }
    }
    var form = document.studentSearchForm;
    var totalNumber = document.getElementById("totalNumber").value;
    bg.form.addInput(form,"keys",keys.substring(0,keys.length-1));
    bg.form.addInput(form,"titles",titles.substring(0,titles.length-1));
    bg.form.addInput(form,"queryAdmission",queryAdmission);
    bg.form.addInput(form,"queryExaminee",queryExaminee);
    bg.form.addInput(form,"queryAdmissionMajor",queryAdmissionMajor);
    bg.form.addInput(form,"queryGraduation",queryGraduation);
    bg.form.addInput(form,"queryHome",queryHome);
    bg.form.addInput(form,"queryContact",queryContact);
    bg.form.addInput(form,"queryAbroad",queryAbroad);
    bg.form.addInput(form,"queryMember",queryMember);
    bg.form.addInput(form,"queryActive",queryActive);
    bg.form.addInput(form,"queryInschool",queryInschool);
    if (keys == "") {
      alert("请选择字段导出!");
      return;
    }
    if(bg.input.getCheckBoxValues("student.id")!="") {
      bg.form.addInput(form,"studentIds",bg.input.getCheckBoxValues("student.id"));
    }else{
      if (totalNumber > 500) {
        if(!confirm("您确认要导出所有学生的数据?数据量较大,请耐心等待")) {
          jQuery.colorbox.close();
          return;
        }
      }
    }
    var tempAction = form.action;
    var tempTarget = form.target;
    bg.form.submit("studentSearchForm",form.action.substring(0,form.action.indexOf('!'))+"!export.action","_self",null,false);
    jQuery.colorbox.close();

    form.action=tempAction;
    form.target =tempTarget;
    jQuery("input:hidden[name=studentIds]").val("");
    //jQuery.nmTop().close();
  }

  function getKeys(chkName) {
    var keys = "";
    var obj = document.getElementsByName(chkName);
    for (i=0; i<obj.length; i++) {
      if (obj[i].checked == true) {
        if (keys != "") {
          keys += ",";
        }
        var temp = obj[i].value.indexOf(";");
        keys += obj[i].value.substring(0,temp);
      }
    }
    if(keys!=""){
      keys+=",";
    }
    return keys;
  }

  function getTitles(chkName) {
    var titles = "";
    var obj = document.getElementsByName(chkName);
    for (i=0; i<obj.length; i++) {
      if (obj[i].checked == true) {
        if (titles != "") {
          titles += ",";
        }
        var temp = obj[i].value.indexOf(";");
        titles += obj[i].value.substring(temp+1);
      }
    }
    if(titles!=""){
      titles+=",";
    }
    return titles;
  }

  /*function addInputToForm(form) {
    var iframe = document.getElementById("contentFrame");
    var tableParams = iframe.contentWindow.pages["id"].params;
      for (var skey in tableParams){
        svalue=tableParams[skey];
        if(skey!="method"&& svalue!=null && svalue!=""){
          addInput(form,""+skey,""+svalue);
        }
      }
  }*/
</script>

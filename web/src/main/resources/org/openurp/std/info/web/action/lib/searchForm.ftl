<#include "../lib/major3Select.ftl"/>
<#assign id="s">
<@b.form name="studentSearchForm" id="studentSearchForm" action="!search" title="ui.searchForm" target="studentList">
<table width="100%">
  <tr>
    <td align="right">${b.text("attr.stdNo")}：</td>
    <td><input type="text" name="student.user.code" title="${b.text("attr.stdNo")}" style="width:118px;" maxlength="32" value="${Parameters['student.user.code']?if_exists}"/></td>
    <td align="right">${b.text("attr.personName")}：</td>
    <td><input type="text" name="student.user.name"  title="${b.text("attr.personName")}" style="width:118px;" maxlength="20" value="${Parameters['student.user.name']?if_exists}"/></td>
    <td align="right">年级：</td>
    <td><input type="text" name="student.state.grade" title="年级" id='std.state.grade' style="width:118px;" maxlength="20" ></td>
    <td align="right">学制：</td>
    <td><input type='text' name="student.duration" title="学制" id="std.duration" maxlength="5" style="width:118px;" onKeyup="validateData(this);"/></td>
   </tr>
  <@majorSelect id="${id}" projectId="student.project.id" departId="student.state.department.id" levelId="student.level.id" stdTypeId="student.stdType.id" majorId="student.state.major.id"/>
   <tr>
    <#--td width="10%" align="right">学籍状态:</td>
    <td width="10%"><@htm.i18nSelect datas=states selected=(student.state.id?string)?default("") name="student.state.id" id="studentState" onchange="disableOther(this)" title="学籍状态"  style="width:120px"><option value="">...</option></@></td-->
    <td align="right">是否在籍：</td>
    <td>
      <select style="width:120px" name="active" id="active" title="是否在籍">
        <option value="">...</option>
        <option value="1">是</option>
        <option value="0">否</option>
      </select>
    </td>
    <td align="right">是否在校：</td>
    <td>
      <select style="width:120px" name="inSchool" id="inSchool" title="是否在校">
        <option value="">...</option>
        <option value="1" selected="selected">是</option>
        <option value="0">否</option>
      </select>
    </td>
    <td align="right">学籍状态</td>
    <td><@b.select name="stdStatusId" id="stdStatusId" items=states?sort_by("name") label="学籍状态"  style="width:120px" empty="..." theme="html"/></td>
    <td align="right">行政班级：</td>
    <td><@b.select name="student.state.squad.id" id="squadId" items={} label="行政班级"  style="width:120px" empty="..." theme="html"/></td>
  </tr>
</table>
<table id="advanceSearchDiv" style="width:100%;display:none">
  <tr><td>
  <div class="stdInfoTab">
    <ul class="stdInfoMenu" id="menutitle">
      <li id="tab_1" class="aaa" onclick="tabs('1');">学籍信息</li>
      <li id="tab_2" onclick="tabs('2');">基本信息</li>
      <li id="tab_3" onclick="tabs('3');">考生信息</li>
      <li id="tab_4" onclick="tabs('4');">录取信息</li>
      <li id="tab_5" onclick="tabs('5');">联系方式信息</li>
      <li id="tab_6" onclick="tabs('6');">留学生信息</li>
      <li id="tab_7"></li>
    </ul>
    <div class="stdInfoTab_b" id="tab_a1" style="display:block;"><#include "../studentSearch/detailForm/search_student.ftl"></div>
    <div class="stdInfoTab_b" id="tab_a2" style="display:none;"><#include "../studentSearch/detailForm/search_person.ftl"></div>
    <div class="stdInfoTab_b" id="tab_a3" style="display:none;"><#include "../studentSearch/detailForm/search_examinee.ftl"></div>
    <div class="tab_b" id="tab_a4" style="display:none;"><#include "../studentSearch/detailForm/search_admission.ftl"></div>
    <div class="stdInfoTab_b" id="tab_a5" style="display:none;"><#include "../studentSearch/detailForm/search_contact.ftl"></div>
    <div class="stdInfoTab_b" id="tab_a6" style="display:none;"><#include "../studentSearch/detailForm/search_abroad.ftl"></div>
  </div></td></tr>
</table>
</@>
<table class="searchTable" width="100%">
  <tr align="center">
    <td >
      <@b.submit  formId="studentSearchForm" value="查  询"/>
      <input id="openButton" name="openButton" type="button" value="开启高级查询" onclick="openAdvanceSearch()" class="buttonStyle"/>
      <input id="saveButton" name="saveButton" type="button" value="保存查询条件" onclick="saveSearchCondition()" class="buttonStyle"/>

      <select id="useCondition" style="width:120px">
        <option value="">使用查询条件</option>
        <#list conditions as condition>
        <option value="${(condition.conditions)?if_exists}">${(condition.conditionName)?if_exists}</option>
        </#list>
      </select>
      <input name="delButton" type="button" value="删除自定义查询条件" onclick="delSearchCondition()" title="删除自定义查询条件" class="buttonStyle"/>
    </td>
  </tr>
</table>

<script>
  <#if (projectList?size==1)>
    <#list projectList as project>
        <#assign projectId = "${project.id}"/>
    </#list>
    function setMajor3Select(projectId) {
      jQuery("#${id}"+"project").val(projectId).change();
    }

    setMajor3Select(${projectId});
  </#if>

  function validateData(obj) {
    var numObj = Number(obj.value);
    if (isNaN(numObj)) {
      obj.value = '';
    }
  }

  // 控制tab 控件
  function tabs(n) {
    var len = 6;
    for (var i = 1; i <= len; i++) {
      document.getElementById('tab_a' + i).style.display = (i == n) ? 'block' : 'none';
      document.getElementById('tab_' + i).className = (i == n) ? 'aaa' : 'none';
    }
  }

  function openAdvanceSearch() {
    var advanceSearchDiv = document.getElementById('advanceSearchDiv');
    var openButton = document.getElementById('openButton');
    if (advanceSearchDiv.style.display == "none") {
      advanceSearchDiv.style.display = "block";
      openButton.value = "  关闭高级查询  ";
    } else if(advanceSearchDiv.style.display == "block") {
      advanceSearchDiv.style.display = "none";
      openButton.value = "  开启高级查询  ";
    }
  }
  function disableOther(state) {
    var flag = (state.value!="");
    var inSchool = document.getElementById("inSchool");
    var active =  document.getElementById("active");
    inSchool.disabled=flag;
    active.disabled=flag;
  }
  function disableState(other) {
    var Ovalue = other.value;
    var flag = (Ovalue!="");
    var studentState = document.getElementById("studentState");
    studentState.disabled=flag;
  }

  // 查询条件的显示
  jQuery(function() {
    jQuery(":input").bind("change",function(){
      updateCondition();
      updateConditionText();
    });
    jQuery(".toggleCondtion").click( function(){jQuery(".toggleCondtion,#saveCondition").toggle();})

    jQuery("#slevel").change(function(){
      jQuery("#squadId").empty().append("<option value=''>...</option>");
    })

    jQuery("#sdepartment").change(function(){
      jQuery("#squadId").empty().append("<option value=''>...</option>");
    })

    jQuery("#smajor").change(function(){
      jQuery("#squadId").empty().append("<option value=''>...</option>");
      var res = jQuery.post("${base}/student!getSquadByMajor.action",{majorId:jQuery(this).val()},function(){
        if(res.status==200){
          if(res.responseText!=""){
            jQuery("#squadId").append(res.responseText);
          }
        }
      },"text");
    })
  } );

  function saveSearchCondition() {
    jQuery.colorbox({transition:'none', title:"保存查询条件", overlayClose:false, width:"450px", height:"280px", inline:true, href:"#searchConditionDiv"});
  }
  //删除查询条件
  var condition;
  function delSearchCondition(){
    condition=document.getElementById('useCondition');
    var conditionName=condition.options[condition.selectedIndex].text;
    if(conditionName=="使用查询条件"){
      alert('没有可删除的查询条件!');
    }else{
      conditionServiceDwr.delSearchCondition(conditionName,delSearchConditionCallBack);
    }
  }

  function delSearchConditionCallBack(datas){
    condition.options.remove(condition.selectedIndex);
    alert('删除成功!');
  }

  function updateCondition() {
    var condition="";
    var dealWith = jQuery("#searchTb select:not(#useCondition):not(.pgbar-selbox)");
    var dealWith2 = jQuery("#searchTb input[type='text']:not(.pgbar-input):not(#codeValue)");
    jQuery.each(dealWith,function(){ if(this.value!="")condition+= this.name+"="+this.value+"&";});
    jQuery.each(dealWith2,function(){ if(this.value!="")condition+= this.name+"="+this.value+"&";});
    jQuery("#formCondition").val(condition);
  }

  function updateConditionText() {
    var conditionText="";
    jQuery.each(jQuery("#searchTb select:not(#useCondition):not(.pgbar-selbox) option:selected"),function(){ if(this.value!="" && jQuery(this).text())
        conditionText+="["+jQuery(this).text()+"],";
      } );
    jQuery.each(jQuery("#searchTb input[type='text']:not(.pgbar-input):not(#codeValue)"),function(){ if(this.value!="")
        conditionText+="["+this.value+"],";
      } );
    jQuery("#conditions").text(conditionText);
  }

  function RechangeItem(itemName,itemValue){
    this.itemName = itemName;
    this.itemValue = itemValue;
  };

  var shouldReChange= new Array(6);
  jQuery(function(){
    jQuery("#useCondition").change(function() {
      document.studentSearchForm.reset();
      shouldReChange= new Array(6);
      var conditions = jQuery(this).val().split("&");
      relatedCondition = { project:0,span:0,type:0,department:0,major:0};
      for(var i=0;i<conditions.length;i++) {
        if(conditions[i]=="")continue;
        var attrName= conditions[i].split("=")[0];
        var attrValue = conditions[i].split("=")[1];
        if(genRechangeItem(attrName,attrValue,relatedCondition)) continue;
        jQuery("#studentSearchForm :input[name='"+attrName+"']").val(attrValue);
      }

      if(relatedCondition.project!=0) {
        jQuery("#${id}"+"project").val(relatedCondition.project).change();
      }
      if(jQuery(this).val()!=""){
        changeEducationValue();
        changeDepartmentValue();
        changeStdTypValue();
      }
    });
  });

  var relatedCondition = { project:0,span:0,type:0,department:0,major:0};

  function genRechangeItem(attrName,attrValue,relatedCondition){
    if(attrName==("student.project.id")){
      shouldReChange[0]=new RechangeItem(attrName,attrValue);
      relatedCondition.project= attrValue;
      return true;
    }
    if(attrName==("student.level.id")) {
      shouldReChange[1]=new RechangeItem(attrName,attrValue);
      relatedCondition.level=attrValue;
      return true;
    }
    if(attrName==("student.stdType.id")) {
      shouldReChange[2]=new RechangeItem(attrName,attrValue);
      relatedCondition.type=attrValue;
      return true;
    }
    if(attrName==("student.state.department.id")) {
      shouldReChange[3]=new RechangeItem(attrName,attrValue);
      relatedCondition.department = attrValue;
      return true;
    }
    if(attrName==("student.state.major.id")) {
      shouldReChange[4]=new RechangeItem(attrName,attrValue);
      relatedCondition.major =attrValue;
      return true;
    }
    return false;
  }

  function changeEducationValue(){
    if(relatedCondition.level!=0){
      jQuery("#${id}"+"level").val(relatedCondition.level).change();
    }
  }
  function changeDepartmentValue(){
    if(relatedCondition.department!=0){
      jQuery("#${id}"+"department").val(relatedCondition.department).change();
    }
  }
  function changeStdTypValue(){
    if(relatedCondition.type!=0){
      jQuery("#${id}"+"stdType").val(relatedCondition.type).change();
    }
  }
  function changeMajorValue(){
    if(relatedCondition.major!=0){
      jQuery("#${id}"+"major").val(relatedCondition.major).change();
    }
  }
  </script>
  <div style="display:none">
    <div id="searchConditionDiv">
      <table class="formTable" style="margin-top:20px" width="100%">
        <tr>
          <td id="f_code" class="title"><font color="red">*</font>查询条件名称:</td>
          <td>
            <input id="codeValue" type="text" name="studentCondition.conditionName" value="" style="width:300px;" maxLength="30"/>
            <input type="hidden" name="studentCondition.conditions" id="formCondition" value=""/>
          </td>
        </tr>
        <tr  class="darkColumn" align="center">
          <td colspan="2">
            <input type="button" value="提交" onclick="toSaveCondition()" />
          </td>
        </tr>
      </table>
  </div>
  </div>
  <script language="javascript">
    var conditionName;
    function toSaveCondition(){
      conditionName= jQuery("#codeValue").val();
      if(conditionName == "" || conditionName == null){
        alert("请输入条件名称");
        return;
      }else{
        conditionServiceDwr.getConditionByName(conditionName,isHasConditionCallBack);
      }
    }
    function isHasConditionCallBack(datas){
      if(datas){
        var form = document.studentSearchForm;
        var tempAction = form.action;
        var tempTarget = form.target;
        var conditionStr = jQuery("#formCondition").val();
        bg.form.addInput(form,"studentCondition.conditionName",conditionName);
        bg.form.addInput(form,"studentCondition.conditions",conditionStr.substring(0,conditionStr.length-1));
        bg.form.submit("studentSearchForm",form.action.substring(0,form.action.indexOf('!'))+"!saveConditions.action","conditionTarget");
        form.action=tempAction;
        form.target =tempTarget;
        jQuery.colorbox.close();
        //jQuery.nmTop().close();
      }else{
        alert('该名称已存在!');
      }
    }
  </script>
<style>
  .stdInfoTab{  margin:0px; overflow:hidden; border:1px #AACCEE solid; width:100%;}
  .stdInfoTab_b{ overflow:hidden; margin:5px; }
  .stdInfoMenu  {overflow:hidden; list-style-type:none; font-size:12px; text-decoration:none; margin:0; padding:0;}
  .stdInfoMenu li{ display:block; float:left; display: list-item; text-align:center; width:145px; background-color:#EDF4FC;line-height:16px; border-bottom:1px #AACCEE solid;border-right:1px #AACCEE solid; }
  .stdInfoMenu li a{ display:block;}
  .menu_d{border-bottom:1px #FFFFFF solid;background-color:#FFFFFF; }
  .stdInfoTab ul li.aaa{background: #FFFFFF; border-bottom:0px #FFFFFF solid;}
  .tableStyle{ border:0.5; border-style:solid; border-color:#F0F0F0}
</style>

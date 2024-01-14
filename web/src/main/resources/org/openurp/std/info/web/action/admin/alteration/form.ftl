[#ftl]
[@b.head/]
<link rel="stylesheet" type="text/css" href="${b.base}/static/css/ext-like-table.css" />

[@b.toolbar title="<font color='red'>第二步:</font>设置异动信息"]
  bar.addBack();
[/@]

[@b.form name="alterationForm" title="异动信息" action="!save" theme="html" onsubmit="validParams"]
<input name="alterConfigId" type="hidden" value="${alterConfig.id}"/>
  <table width="100%" class="grid-table">
    <caption class="normal">异动设置</caption>
    <colgroup>
      <col width="10%"/><col width="50%"/>
      <col width="10%"/><col width="50%"/>
    </colgroup>
    <thead>
      <tr>
        <th colSpan="2" style="text-align:center">异动信息</th>
        <th colSpan="2" style="text-align:center">异动项信息</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td style="text-align:right;">
          <font color='red'>*</font>生效日期:
        </td>
        <td>
          [@b.date label="" id="beginOn" name="stdAlteration.alterOn" format="yyyy-MM-dd"  value="" minDate='${(minBeginOn!.now)?string("yyyy-MM-dd")}' readOnly="readOnly"/]
          ${minBeginOn?string('yyyy-MM-dd')}之后
        </td>
        <td style="text-align:right;"><font color='red'>*</font>年级:</td>
        <td >[#if gradeConfig??][@b.select style="width:160px"  id="gradeId" name="status.grade.id" label="" items=grades empty="..."/][#else]不做变动[/#if]</td>
      </tr>
      <tr>
        <td style="text-align:right;">异动后状态:</td>
        <td>
          ${alterConfig.status.name}
        </td>
        <td  style="text-align:right;">
           <font color='red'>*</font>院系:
        </td>
        <td style="overflow:auto;">
          [#if departmentConfig??]
          [@b.select style="width:160px" title="院系" id="departmentId"  label="" name="status.department.id" items=departments empty="..."/]
          [#else]不做变动[/#if]
        </td>
      </tr>
      <tr>
        <td style="text-align:right;">
          <font color='red'>*</font>异动类型:
        </td>
        <td>
          [@b.select style="width:160px" id="alterationType" items=modes  value=alterConfig.alterType.id name="stdAlteration.alterType.id" theme="html"/]
        </td>
         <td style="text-align:right;">
           <font color='red'>*</font>专业和方向:
         </td>
         <td style="overflow:auto;">
            [#if majorConfig??]
            [@b.select style="width:160px" id="majorId" name="status.major.id"  label=""  items=majors empty="..." /]
            [@b.select style="width:160px" id="directionId" name="status.direction.id"  label="" items=directions empty="..." /]
            [#else]不做变动
            [/#if]
         </td>
      </tr>
      <tr>
        <td style="text-align:right;">异动原因:</td>
        <td>
          [@b.select style="width:160px" items=reasons empty="..." name="stdAlteration.reason.id" theme="html"/]
        </td>
        <td style="text-align:right;">班级:</td>
        <td style="overflow:auto;">
          [#if squadConfig??][@b.select style="width:250px" id="squadId" name="status.squad.id" items=squads empty="请输入内容查询" theme="html"/][#else]不做变动[/#if]
        </td>
      </tr>
      <tr>
        <td style="text-align:right;">备注:</td>
        <td>
          <span id="remarkSpan"><a href="#" onClick="jQuery('#stdAlterationRemark').show().height('90%').width('95%');jQuery('#remarkSpan').hide();">填写备注</a></span>
          <input id="stdAlterationRemark" title="备注" style="display:none" maxLength="200" style="width:95%;" name="stdAlteration.remark" title="备注"></textarea>
        </td>
        <td style="text-align:right;">预计毕业:</td>
        <td style="overflow:auto;">
          [#if graduateOnConfig]
            [@b.date  label="" name="graduateOn" format="yyyy-MM-dd"  value= maxGraduateOn/]
          [#else]
            不做变动
          [/#if]
        </td>
      </tr>
      <tr>
        <td colspan="4" style="text-align:center">[@b.submit value="提交异动结果" class="btn btn-primary btm-sm" /]</td>
      </tr>
    </tbody>
  </table>
  [@b.div]
    [#assign studentIds][#list studentStates as state][#if state_index>0],[/#if]${state.std.id}[/#list][/#assign]
    <table width="100%" class="grid-table">
      <thead class="grid-head">
        <tr>
          <th width="4%">序号</th>
          <th width="12%">学号</th>
          <th width="10%">姓名</th>
          <th width="8%">年级</th>
          <th width="13%">所属院系</th>
          <th>专业和方向</th>
          <th width="18%">班级</th>
          <th width="9%">预计毕业时间</th>
          <th width="9%">学籍状态</th>
        </tr>
      </thead>
      <tbody class="grid-body">
        [#list studentStates?sort_by(["std","code"]) as state]
        <tr>
          <td>${state_index+1}</td>
          <td>${(state.std.code)!}</td>
          <td>${(state.std.name)!}</td>
          <td>${(state.grade.code?html)!}</td>
          <td>${(state.department.name?html)!}</td>
          <td>${(state.major.name?html)!} ${(state.direction.name?html)!}</td>
          <td>${(state.squad.name?html)!}</td>
          <td>${(state.std.endOn?string('yyyy-MM-dd'))!}</td>
          <td>${(state.status.name)!}</td>
        </tr>
        [/#list]
      </tbody>
    </table>
  [/@]
[/@]
<script>
  beangle.load(["jquery-validity"]);
  function validParams(form){
    jQuery.validity.start();
    jQuery("#departmentId", form).require("请填写院系");
    jQuery("#majorId", form).require("请填写专业");
    jQuery("#grade", form).require();
    jQuery("#beginOn", form).require();
    jQuery("#alterationType", form).require("请填写异动类型");
    jQuery("#stdAlterationRemark", form).maxLength("500");
    return jQuery.validity.end().valid;
    if(!res) {
      $(".error").css("background", "url(static/themes/default/images/arrow.gif)");
    }
  }
  bg.load(["chosen","bui-ajaxchosen"],function(){
    var form =document.alterationForm;
    [#if departmentConfig??]
    jQuery("#departmentId").chosen();
    bg.form.addInput(form,"departmentConfig","1");
    [/#if]
    [#if squadConfig??]
    jQuery("#squadId").chosen();
    bg.form.addInput(form,"squadConfig","1");
    [/#if]

    [#if majorConfig??]
      bg.form.addInput(form,"majorConfig","1");
    [/#if]
    [#if gradeConfig??]
      bg.form.addInput(form,"gradeConfig","1");
    [/#if]
    bg.form.addInput(form,"studentIds","${studentIds}");

    var i=0;
    jQuery("#showStudent").click(function() {
      jQuery("#stdTable").toggle();
      jQuery(this).html(i++%2==0?"查看学生列表":"隐藏学生列表");
    });
    [#if majorConfig??]
    if (jQuery("#departmentId").length) {
      jQuery("#departmentId").change(function(){
        projectMajorDwr.majors("${project.id}", null, jQuery("#departmentId").val(), setMajorOptions);
      });
    } else {
      projectMajorDwr.majors("${project.id}", null, jQuery("#departmentId").val(), setMajorOptions);
    }
    jQuery("#majorId").change(function(){
      projectMajorDwr.directions(jQuery("#majorId").val(), setDirectionOptions);
    });
    [/#if]
  });

  [#if majorConfig??]
  function setMajorOptions(data){
     document.getElementById("majorId").options.length=0;
     document.getElementById("directionId").options.length=0;
     jQuery("#directionId").append("<option value=''>...</option>");
     jQuery("#majorId").append("<option value=''>...</option>");
     for(var i=0;i<data.length;i++){
       jQuery("#majorId").append("<option value='"+data[i][0]+"'>"+data[i][1]+" "+data[i][2]+"</option>");
     }
  }

  function setDirectionOptions(data){
      document.getElementById("directionId").options.length=0;
      jQuery("#directionId").append("<option value=''>...</option>");
      for(var i=0;i<data.length;i++){
       jQuery("#directionId").append("<option value='"+data[i][0]+"'>"+data[i][1]+" "+data[i][2]+"</option>");
      }
  }
  [/#if]
</script>
[@b.foot/]

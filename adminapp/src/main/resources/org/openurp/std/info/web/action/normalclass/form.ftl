[#ftl/]
[#import "/template/message.ftl" as msg/]
<script src='${base}/dwr/engine.js'></script>
<script src='${base}/static/scripts/dwr/util.js'></script>
<script src='${base}/dwr/interface/projectMajorDwr.js'></script>
<script src='${base}/static/scripts/common/majorSelect.js?v=201811'></script>
[@b.head/]
    [@b.form action="!save" theme="list" title="教学班基本信息" name="squadForm" onsubmit="return checkCodeAndName();"]
        [@b.messages/]
        [@b.textfield name="normalclass.name" required="true" maxlength="20" label="班级名称" value=(normalclass.name)! comment="名称须唯一"/]
      [#--  [@b.textfield name="normalclass.project.name" required="true" maxlength="30" label="项目名称" value=(squad.name)! comment="名称须唯一"/] --]
       [#-- [@b.textfield name="normalclass.level.name" maxlength="20" label="培养层次" value=(squad.shortName)!/]  --]

         [@b.select name="normalclass.project.id" required="true" label="教学项目" items=projects value=(normalclass.project)! /]
         [@b.select name="normalclass.level.id" required="true" label="培养层次" items=levels value=(normalclass.level)! /]
        [@b.datepicker style="width:130px" required="true" name="normalclass.beginOn" label="生效时间" value=(normalclass.beginOn)!/]
        [@b.datepicker style="width:130px" name="normalclass.endOn" label="失效日期" value=(normalclass.endOn)!/]
        [@b.formfoot]
            [@b.submit value="system.button.submit"/]
            <input type="reset" value="${b.text("system.button.reset")}" class="buttonStyle"/>
            <input type="hidden" name="normalclass.id" value="${(normalclass.id)!}"/>
            <input type="hidden" name="normalclass.createdAt" value="${((normalclass.createdAt)?string('yyyy-MM-dd'))!}"/>
            <input type="hidden" name="normalclass.beginOn" value="${((normalclass.beginOn)?string('yyyy-MM-dd'))!}"/>

        [/@]
    [/@]
[@b.foot/]
<script>
  function validataPlanCount(obj){
    if (isNaN(Number(obj.value))||Number(obj.value)<0){
      obj.value = 0;
    }
  }

  function checkCodeAndName() {
    var oldName = "${(normalclass.name)?default('-1')}";
    var name = jQuery(":input[name=normalclass\\.name]", document.squadForm).val();
    var duplicated = true;

    if(oldName!=name){
      jQuery.ajax({
        type: "post",
        url : "normalclass!checkName.action",
        error : function(){alert('响应失败!');},
        dataType : "text",
        data : "name="+name,
        async : false,
        success : function(callback){
          if(callback=='1'){
            alert("班级名称已经存在!");
            duplicated = false;
          }
        }
      });
    }

    return duplicated;
  }

  jQuery(function() {
    var projectArray = new Array();
    [#list projects as project]
    projectArray[${project_index}]={'id':'${project.id}','name':'${project.name}'};
    [/#list]
    [#if !(levelNullable?exists)]
      [#assign levelNullable=false]
    [/#if]
    var sds = new Major3Select("project","level", "stdType","department", "major","direction",
                  true,true,true,true);
    sds.init(projectArray, '${request.getServletPath()}');

    jQuery("#department").change();
  });
</script>

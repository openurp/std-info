[#ftl]
[@b.head /]
<script>
  jQuery(function(){
    [#if notAddCodes?exists && notAddCodes?size gt 0]
      jQuery("#showErrorStd").append("错误学生学号或名称 ${notAddCodes?size} 个,学号或名称分别是：<br/>[#list notAddCodes?if_exists as code]${code}[#if code_has_next],[/#if][/#list]");
    [/#if]
    [#if studentList?exists && studentList?size gt 0]
      var model="<tr class='#class_list' title='添加'><td class='gridselect'><input type='checkbox' value='#id' name='student.id' class='box'></td><td>#code</td><td>#name</td><td>#department</td><td>#stdType</td><td>#registed</td></tr>";
      var class_list=jQuery("#stdShow .grid .gridtable tbody tr:last").prop("className");
      [#list studentList as student]
        var exists=false;
        jQuery("#stdShow :checkbox[name='student.id']").each(function(){
          if(jQuery(this).val()=="${student.id}") exists=true;
        });
        if(!exists){
          class_list=(class_list=="griddata-odd"?"griddata-even":"griddata-odd");
          jQuery("#stdShow .grid .gridtable tbody")
            .append(model.replace("#class_list",class_list)
              .replace("#id","${student.id}")
              .replace("#code","${(student.user.code)!}")
              .replace("#name","${(student.user.name)!}")
              .replace("#department","${(student.state.department.name)!}")
              .replace("#stdType","${(student.stdType.name)!}")
              .replace("#registed","${((student.registed)?string("有效","<font color='red'>无效</font>"))!}"));
        }
      [/#list]
    [/#if]
  });
</script>
[@b.foot /]

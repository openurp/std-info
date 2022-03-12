[#ftl/]
[@b.head/]
  [@b.toolbar title="维护班级学生"]
    bar.addItem("移出", "removeStd()");
    bar.addItem("添加", "newStd()");
    bar.addItem("保存", "saveStd()");
    bar.addItem("重置", "resetStd()");
    jQuery(function(){
      var model=" <button onclick='#click'>#title</button> ";
      jQuery("#showButton").append(model.replace("#click","removeStd()").replace("#title","移出"))
        .append(model.replace("#click","newStd()").replace("#title","添加"))
        .append(model.replace("#click","saveStd()").replace("#title","保存"))
        .append(model.replace("#click","resetStd()").replace("#title","重置"));

      [#if (flash["message"])??]
        alert("${(flash["message"]?js_string)!}");
      [/#if]
    });
    function newStd(){
      jQuery("#searchStdForm #stdCodes").val("");
      jQuery.colorbox({transition : 'none', title : "添加班级学生", overlayClose : false, width:"800px", inline:true, href:"#doAddDiv"});
    }
    function removeStd(){
      var ids = bg.input.getCheckBoxValues("student.id");
      if (ids == "") {
        alert("请选择至少一个学生")
        return;
      }
      if(confirm("确定要从本班删除选中的学生？")){
        jQuery("#stdShow :checkbox:checked").each(function(){
          jQuery(this).parent().parent().hide();
          jQuery(this).prop("name","student.id.remove");
        });
      }
    }
    function saveStd(){
      var studentIds="";
      jQuery("#stdShow :checkbox[name='student.id']").each(function(){
        studentIds=studentIds+","+jQuery(this).val();
      });
      var studentRemoveIds="";
      jQuery("#stdShow :checkbox[name='student.id.remove']").each(function(){
        studentRemoveIds=studentRemoveIds+","+jQuery(this).val();
      });
      var form=document.saveClassStudent;
      bg.form.addInput(form, 'studentIds', studentIds);
      bg.form.addInput(form, 'studentRemoveIds', studentRemoveIds);
      bg.form.submit(form, "normalclass!saveClassStudent.action", 'normalclassListFrame');
    }
    function resetStd(){
      jQuery("#stdShow .grid .gridtable tbody tr[title='添加']").remove();
      jQuery("#stdShow :checkbox[name='student.id.remove']").each(function(){
        jQuery(this).parent().parent().show();
        jQuery(this).prop("name","student.id");
      });
    }
  [/@]
  <form action="normalclass!saveClassStudent.action" method="post" onsubmit="" name="saveClassStudent">
    <input type="hidden" name="normalclassId" value="${normalclass.id}"/>
    <input type="hidden" name="studentIds" value=""/>
    <input type="hidden" name="studentRemoveIds" value=""/>
    <table class="formTable" width="90%" align="center">
      <tr><td align="center" colspan="4" class="index_view"><b>教学班基本信息</b></td></tr>
      <tr>
        <td class="title" width="20%">班级名称:</td>
        <td class="brightStyle" width="30%">${(normalclass.name)!}</td>
        <td class="title" width="20%">教学项目名称:</td>
        <td class="brightStyle" width="30%">${(normalclass.project.name)!}</td>
      </tr>
      <tr>
        <td class="title" width="20%">培养层次:</td>
        <td width="30%">${(normalclass.level.name)!}</td>
        <td class="title" width="20%">生效日期:</td>
        <td width="30%">${(normalclass.beginOn)!}</td>
      </tr>
      <tr>
        <td class="title" width="20%">失效日期:</td>
        <td width="30%">${(normalclass.endOn)!}</td>
        <td class="title" width="20%"></td>
        <td width="30%"></td>
      </tr>
    </table>
    <div style="width:90%;margin-left:auto;margin-right:auto;background-color:#E1ECFF;text-align:center">
      <b>班级学生列表</b>
    </div>
    <div style="width:90%;margin-left:auto;margin-right:auto" id="stdShow">
      [@b.grid items=students var="student" sortable="false"]
             [@b.row]
               [@b.boxcol /]
          [@b.col property="code" title="学号" width="20%" ]
            ${(student.user.code)!}
          [/@]
          [@b.col property="name" title="姓名" width="20%"]
                 ${(student.user.name)!}
               [/@]
          [@b.col property="department.name" title="院系" width="25%" ]
            ${(student.state.department.name)!}
          [/@]
          [@b.col property="stdType.name" title="学生类别" width="15%" ]
            ${(student.stdType.name)!}
          [/@]
          [@b.col property="registed" title="学籍有效性" ]
            ${((student.registed)?string("有效","<font color='red'>无效</font>"))!}
          [/@]
          [/@]
      [/@]
    </div>
  </form>
  <div style="width:90%;margin-left:auto;margin-right:auto" id="showButton" align="center" >
  </div>
  <div style="width:90%;margin-left:auto;margin-right:auto;color:red" id="showErrorStd" >
  </div>
  [#if (students!?size)==0]
    <div style="width:60%;margin-left:auto;margin-right:auto">
      <div align="center" style="color:#666666;background:#E1ECFF;"><b>该班级没有学生!</b></div>
    </div>
  [/#if]
  <div style="display:none">
    [@b.div id='doAddDiv' href="normalclass!addClassStudentList?student.project.id=${projectContext.project.id}&frist=1&normalclassId=${normalclass.id}" /]
  </div>

</div>

[@b.foot /]

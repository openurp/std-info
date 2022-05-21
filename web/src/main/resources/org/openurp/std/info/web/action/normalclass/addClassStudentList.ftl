[#ftl]
[@b.head /]
  [@b.form name="searchStdForm" id="searchStdForm" action='normalclass!addClassStudentList' method="post"]
    [@b.toolbar title="学生学号或姓名(重复或无效者被忽略)，多个学号或姓名可用空格、逗号、分号、回车分割"]
      bar.addItem("添加","newSubmit()");
    [/@]
    <p align="center">
    <textarea name="stdCodes" id="stdCodes" cols="100" rows="5">${stdCodes!}</textarea>
    </p>
    <input type="hidden" name="student.project.id" value="${projectContext.project.id}" />
    <input type="hidden" name="normalclassId" value="${(normalclassId)!}" />
    [@b.toolbar title="查询学号添加"]
      bar.addItem("单号","checkStd('odd')");
      bar.addItem("双号","checkStd('even')");
      bar.addItem("添加学号","newStdCodes()");
    [/@]
    [@b.grid sortable="false" items=students! var="std" style='width:98%;' filterable='true']
      [@b.gridfilter property="code"]<input type="text" style="width:90%;" name="student.user.code" value="${student.user.code!}"/>[/@]
      [@b.gridfilter property="name"]<input type="text" style="width:90%;" name="student.user.name" value="${student.user.name!}"/>[/@]
      [@b.gridfilter property="gender.name"][/@]
      [@b.gridfilter property="grade"]<input type="text" style="width:90%;" name="student.state.grade" value="${student.state.grade!}"/>[/@]
      [@b.gridfilter property="department.name"]<input type="text" style="width:90%;" name="student.state.department.name" value="${(student.state.department.name)!}"/>[/@]
      [@b.gridfilter property="major.name"]<input type="text" style="width:90%;" name="student.state.major.name" value="${(student.state.major.name)!}"/>[/@]
      [@b.gridfilter property="squad.name"]<input type="text" style="width:90%;" name="student.state.squad.name" value="${(student.state.squad.name)!}"/>[/@]
      [@b.row]
        [@b.boxcol/]
        [@b.col width="12%" property="code" title="学号"/]
        [@b.col width="10%" property="name" title="姓名"/]
        [@b.col width="8%" property="gender.name" title="性别"/]
        [@b.col width="10%" property="grade" title="年级"/]
        [@b.col width="20%" property="department.name" title="院系"/]
        [@b.col width="20%" property="major.name" title="专业"/]
        [@b.col width="20%" property="squad.name" title="所在行政班"/]
      [/@]
    [/@]
  [/@]

<script type="text/javascript">
  function newSubmit(){
    var stdCodes=jQuery("#searchStdForm #stdCodes").val();
    var projectId=jQuery("#searchStdForm #student.project.id").val();
    var normalclassId=jQuery("#searchStdForm #normalclassId").val();
    if(!stdCodes){
      if(confirm("没有添加任何学生学号，放弃添加？")){
        jQuery.colorbox.close();
      }
      return;
    }
    bg.form.submit(document.searchStdForm, 'normalclass!addClassStudent.action', 'showErrorStd');
    jQuery.colorbox.close();
  }
  function newStdCodes(){
    jQuery("#searchStdForm :checkbox[name='std.id']").each(function(){
      var flag = jQuery(this).prop("checked");
      if(flag){
        var code=jQuery(this).parent().next("td").html();
        var codes=jQuery("#searchStdForm #stdCodes").val();
        if(codes.indexOf(code)<0)
          jQuery("#searchStdForm #stdCodes").val((codes==""?"":codes+",")+code);
      }
    });
  }
  function checkStd(type){
    jQuery("#searchStdForm .griddata-"+type+" :checkbox[name='std.id']").each(function(){
      jQuery(this).prop("checked",true);
    });
  }
</script>
[@b.foot /]

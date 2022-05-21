[#ftl/]
[@b.head/]
[@b.toolbar title="教学班级信息管理"]
  bar.addBack();
[/@]
<div class="search-container">
  <div class="search-panel">
        [@b.form theme="search" action="normalclass!search" title="ui.searchForm" target="normalclassListFrame" name="searchForm"]
        [@b.textfield name="normalclass.name" required="true" maxlength="20" label="班级名称" value=(normalclass.name)! comment="代码须唯一,只允许数字和字母" check="match(/^[A-Za-z0-9]+$/g)"/]
         [@b.select name="normalclass.project.id" label="教学项目" items=projects value=(normalclass.project)! empty="${b.text('filed.choose')}..."/]
         [@b.select name="normalclass.level.id" label="培养层次" items=levels value=(normalclass.level)! empty="${b.text('filed.choose')}..."/]
    [@b.select name="fake.normalclass.valid" label='是否有效' items={'' : '...', '1' : '有效', '0' : '无效'} /]
    [/@]
  </div>
  <div class="search-list">
            [@b.div id="normalclassListFrame" /]
  </div>
</div>
<form name="ImportExportForm" id="ImportExportForm" method="post" target="_blank"></form>

<script type="text/javascript">
  jQuery(function() {
    bg.form.submit(document.searchForm);
  });

  //新建班级
  function newNormalclass(){
    jQuery(":hidden[name=normalclassId]").val("");
    bg.form.submit(document.normalclassListForm);
  }

  //修改班级
  function updateNormalclass(){
    var normalclassId=bg.input.getCheckBoxValues('normalclass.id');
    if(normalclassId==""||normalclassId.indexOf(',')!=-1){alert('请仅选择一个班级操作!');return;}
    jQuery(":hidden[name=normalclassId]").val(normalclassId);
    bg.form.submit(document.normalclassListForm);
  }

  //删除班级
  function removeSquad(){
    var normalclassIds=bg.input.getCheckBoxValues('normalclass.id');
    if(normalclassIds==""){
      alert('请至少选择一个班级操作!');
      return;
    }

    if(confirm("您确定要删除所选班级吗?")){
      //jQuery(":hidden[name=normalclassIds]").val(normalclassIds);
      bg.form.addInput(document.normalclassListForm,"normalclassIds",normalclassIds);
      document.normalclassListForm.action="normalclass!removeNormalclass.action";
      bg.form.submit(document.normalclassListForm);
    }
  }

  //计算最新班级人数
  function totalStdCount(){
    var normalclassIds=bg.input.getCheckBoxValues('normalclass.id');
    if(normalclassIds==""){alert('请至少选择一个班级操作!');return;}
    jQuery(":hidden[name=normalclassIds]").val(normalclassIds);
    document.normalclassListForm.action="normalclass!batchUpdateStdCount.action";
    bg.form.submit(document.normalclassListForm);
  }

  //导入班级学生或者班级
  function importStdOrNormalclass(value){
    var normalclassId=bg.input.getCheckBoxValues('normalclass.id');
    var form = document.ImportExportForm;
        form.action="normalclass!importForm.action";
        if(value=='std'){
      bg.form.addInput(form,"templateType","std");
      bg.form.addInput(form,"importTitle","班级学生数据上传");
          bg.form.addInput(form,"display","班级学生信息模板");
          bg.form.addInput(form,"file","template/excel/教学班学生导入数据模版.xls");
    }
    if(value=='normalclass'){
      bg.form.addInput(form,"templateType","normalclass");
      bg.form.addInput(form,"importTitle","班级数据上传");
          bg.form.addInput(form,"display","班级信息模板");
          bg.form.addInput(form,"file","template/excel/教学班班级导入数据模版.xls");
    }
        form.target="_blank";
        bg.form.submit(form);
        form.target="normalclassListFrame";
  }

  //导出班级学生或者班级
  function exportData(value){
    var normalclassId=bg.input.getCheckBoxValues('normalclass.id');
    if(value=='std'){
      if(normalclassId==""||normalclassId.indexOf(',')!=-1){
      alert('请仅选择一个班级操作!');
      return;
    }else{
      getExportData(value);
    }
    }

    if(value=='normalclass'){
      if(normalclassId == ""){
        if(confirm("是否导出查询条件内的所有数据？")){
          getExportData(value);
        }
        return;
      }else{
        getExportData(value);
      }
    }
  }

  function getExportData(value){
    if(value=='std'){
      bg.form.addInput(document.searchForm,"exportType",value);
      bg.form.addInput(document.searchForm,"normalclassId",bg.input.getCheckBoxValues("normalclass.id"));
      bg.form.addInput(document.searchForm,"keys","normalClass.name,normalClass.project.name,normalClass.level.name,std.user.code,std.user.name,std.person.gender.name,status.name");
      bg.form.addInput(document.searchForm,"titles","教学班,教学项目,培养层次,学生代码,学生姓名,学生性别,学籍状态");
      bg.form.addInput(document.searchForm,"fileName","班级学生列表");
    }
    if(value=='normalclass'){
      bg.form.addInput(document.searchForm,"exportType",value);
      bg.form.addInput(document.searchForm,"normalclassIds",bg.input.getCheckBoxValues("normalclass.id"));
      bg.form.addInput(document.searchForm,"keys","name,project.name,level.name,beginOn,endOn");
      bg.form.addInput(document.searchForm,"titles","班级名称,教学项目,培养层次,生效时间,失效时间");
      bg.form.addInput(document.searchForm,"fileName","班级信息");
    }
    bg.form.submit(document.searchForm, "normalclass!export.action", '_blank');
  }

  //模版下载
  function downloadTemplate(value){
    var form=document.ImportExportForm;
    if(value=='std'){
      bg.form.addInput(form,"templateType","std");
    }
    if(value=='normalclass'){
      bg.form.addInput(form,"templateType","normalclass");
    }
    form.action="normalclass!downloadNormalclassStdTemp.action";
    form.submit();
  }

  function printStdList() {
    var ids = bg.input.getCheckBoxValues("normalclass.id");
    if (ids == "") {
      alert("请选择至少一个班级");
      return;
    }
    bg.form.submit(document.searchForm, 'normalclass!batchPrint.action?normalclassIds=' + ids, '_blank');
  }

  //维护班级学生
  function stdClassOperat(){
    var normalclassId=bg.input.getCheckBoxValues('normalclass.id');
    if(normalclassId==""||normalclassId.indexOf(',')!=-1){alert('请仅选择一个班级操作!');return;}
    bg.form.submit(document.searchForm, 'normalclass!setClassStudentForm.action?normalclassId=' + normalclassId, 'normalclassListFrame');
  }
</script>

[@b.foot/]

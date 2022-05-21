[#ftl/]
[@b.head/]
  [@b.grid items=normalclass var="normalclass" sortable="true"]
    [@b.gridbar]
      bar.addItem("新建", "newNormalclass()");
      bar.addItem("修改", "updateNormalclass()");
      bar.addItem("删除", "removeSquad()");

      var bar1=bar.addMenu("导入导出班级");
      bar1.addItem("导入班级","importStdOrNormalclass('normalclass')");
      bar1.addItem("下载模版","downloadTemplate('normalclass')");
      bar1.addItem("导出班级","exportData('normalclass')");

      var bar2=bar.addMenu("导入导出班级学生");
      bar2.addItem("导入班级学生","importStdOrNormalclass('std')");
      bar2.addItem("下载模版","downloadTemplate('std')");
      bar2.addItem("导出班级学生","exportData('std')");

      bar.addItem('打印学生名单', 'printStdList()');

      bar.addItem("维护班级学生","stdClassOperat()");
    [/@]
         [@b.row]
           [@b.boxcol /]
           [@b.col sort="normalclass.name" title="班级名称" width="25%" ]
        <a href="javascript:infoNormalclass(${(normalclass.id)!});" title="查看班级详细信息">${(normalclass.name)!}</a>
      [/@]
           [@b.col property="project.name" title="教学项目" width="25%" /]
           [@b.col property="level.name" title="培养层次" width="25%" /]
           [@b.col property="beginOn" title="生效日期" width="25%" ]${normalclass.beginOn?string("yyyy-MM-dd HH:mm")!}[/@]
           [@b.col property="endOn" title="失效日期" width="25%" ]${(normalclass.endOn?string("yyyy-MM-dd HH:mm"))!}[/@]
    [/@]
    [/@]
    <form action="normalclass!edit.action" name="normalclassListForm" target="normalclassListFrame">
      <input type="hidden" name="normalclassId" value=""/>
      <input type="hidden" name="normalclassIds" value=""/>
      <input type="hidden" name="params" value="${b.paramstring}" />
    </form>

<script>
    //查看班级详细
  function infoNormalclass(normalclassId){
    bg.form.submit(document.normalclassListForm, 'normalclass!info.action?normalclassId=' + normalclassId, 'normalclassListFrame');
  }
</script>
[@b.foot/]

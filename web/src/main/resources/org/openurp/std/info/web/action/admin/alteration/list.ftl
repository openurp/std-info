[#ftl]
[@b.head/]
<script>
  bg.load(["chosen","jquery-colorbox","bui-ajaxchosen"]);
</script>
<style>
  .alterationMailTable {width:100%;border-collapse: collapse;border:solid;border-width:1px;border-color:#006CB2;vertical-align: middle;}
  .alterationMailTable td{border-color:#006CB2;border-style:solid;border-width:0 1px 1px 0;word-wrap:break-word;}
  .alterationMailTable th{border-color:#006CB2;border-style:solid;border-width:0 1px 1px 0;}
</style>
[@b.grid items=stdAlterations var="stdAlteration"]
  <input type="hidden" name="params" value="${b.paramstring}" />
  [@b.gridbar]
    bar.addItem("${b.text('action.add')}",action.method("firstStep"));
    bar.addItem("${b.text('action.delete')}",action.remove());
    bar.addItem("${b.text('action.info')}",action.info());

    bar.addItem("启用",action.multi('enable'));
    bar.addItem("${b.text("action.export")}", "exportDatas()");

    function exportDatas() {
      var stdAlterationIds = bg.input.getCheckBoxValues("stdAlteration.id");
      if (stdAlterationIds == "") {
        if (!confirm("确认导出查询出来的所有结果?")) return;
      }
      var form = action.getForm();
      bg.form.addInput(form, "titles", "code:流水号,std.code:学号,std.name:姓名,std.state.department.name:院系,"+
                                       "std.state.major.name:专业,alterType.name:异动类型,reason.name:异动原因,"+
                                       "semester.code:学年学期,beginOn:生效日期,std.beginOn:学籍生效日期,"+
                                       "updatedAt:记录时间,remark:操作备注", "hidden");
      bg.form.addInput(form, "fileName", "学籍异动信息");
      bg.form.addInput(form, "stdAlterationIds", stdAlterationIds);
      if(action.page.paramstr){
        bg.form.addHiddens(form,action.page.paramstr);
        bg.form.addParamsInput(form,action.page.paramstr);
      }
      bg.form.submit(form,"${b.url('!exportData')}","self");
    }

    function deleteCourseTaker(){
      var form = document.stdAlterIndexForm;
      var ids = bg.input.getCheckBoxValues("stdAlteration.id");
      if (null == ids || "" == ids) {
        alert("请至少选择一条");
        return;
      }
      bg.form.addInput(form,"stdAlteration.ids",ids);
      bg.form.addInput(form,"params",jQuery("input[name='params']").val());
      bg.form.submit(form,"stdAlteration!deleteCourseTaker.action");
    }

    function printForm(){
      var form = document.stdAlterIndexForm;
      var ids = bg.input.getCheckBoxValues("stdAlteration.id");
      if (null == ids || "" == ids) {
        alert("请选择一项");
        return;
      }
      bg.form.addInput(form,"stdAlteration.ids",ids);
      bg.form.submit("stdAlterIndexForm","stdAlteration!printList.action","_blank");
      form.target="contentDiv";
    }
  [/@]
  [@b.row]
    [@b.boxcol/]
    [@b.col property="std.code" title="学号"/]
    [@b.col property="std.name" title="姓名"][@b.a target="contentDiv" href="!info?id=${stdAlteration.id}" title="查看该学生的学籍变动信息"]${(stdAlteration.std.name)?if_exists}[/@][/@]
    [@b.col property="std.state.department.name" title="院系"]${(stdAlteration.std.state.department.shortName)!stdAlteration.std.state.department.name}[/@]
    [@b.col property="std.state.major.name" title="专业"/]
    [@b.col property="alterType.name" title="异动类型"/]
    [@b.col property="reason.name" title="异动原因"/]
    [@b.col property="semester.code" title="学年学期" width="7%"/]
    [@b.col property="alterOn" title="生效日期"]${stdAlteration.alterOn}[/@]
    [@b.col property="effective" title="是否生效" width="7%"]${((stdAlteration.effective)?string("是","否"))?default("否")}[/@]
  [/@]
[/@]
[@b.foot/]

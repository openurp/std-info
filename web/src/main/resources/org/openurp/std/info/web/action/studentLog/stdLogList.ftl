[#ftl]
[@b.head/]
  [@b.grid items=stdLogs var="stdLog"]
    [#if isNotInfo??]
    [@b.gridbar]
      bar.addItem("查看详情","info()");

      function info(){
        var stdLogId = bg.input.getCheckBoxValues("stdLog.id");
        if(stdLogId ==null || stdLogId =="" || stdLogId.indexOf(",")>-1){
          alert("请只选择一条操作!");
          return;
        }
        bg.form.addInput(document.stdLogInfoForm,"stdLogId",stdLogId);
        bg.form.submit(document.stdLogInfoForm);
      }
    [/@]
    [/#if]
    [@b.row]
      [#if isNotInfo??]
      [@b.boxcol/]
      [/#if]
      [@b.col property="time" width="15%" title="生成时间"]${(stdLog.time)?if_exists?string("yyyy-MM-dd HH:mm")}[/@]
      [@b.col property="operation" width="60%"  title="修改内容"]${stdLog.operation!}[/@]
      [@b.col property="user.name" width="10%" title="操作用户"/]
      [@b.col property="ip" width="10%"  title="IP地址"/]
    [/@]
  [/@]
  [@b.form action="!info" target="_blank" name="stdLogInfoForm"/]
[@b.foot/]

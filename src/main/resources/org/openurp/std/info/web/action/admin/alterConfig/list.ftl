[#ftl]
[@b.head/]
[@b.toolbar title="学籍类型异动列表"]
[/@]
[@b.form name="stdAlterConfigListForm" action="!search" target="contentDiv"]
  [@b.grid items=stdAlterConfigs var="stdAlterConfig"]
      [@b.gridbar]
        bar.addItem("${b.text("action.new")}", action.add());
            bar.addItem("${b.text("action.modify")}",action.single("edit"));
            bar.addItem("${b.text("action.delete")}",action.multi("remove", "确认要删除所选的记录吗？"));
      [/@]
    [@b.row]
      [@b.boxcol/]
      [@b.col title="代      码" property="alterType.code" width="8%"/]
      [@b.col title="名      称" property="alterType.name" width="14%"/]
      [@b.col title="异动后是否在校" property="inschool"  width="15%"]${stdAlterConfig.inschool?string("是","否")}[/@]
      [@b.col title="修改预计毕业日期" property="alterGraduateOn" width="15%"]${stdAlterConfig.alterGraduateOn?string("是","否")}[/@]
      [@b.col title="异动后学籍立即失效" property="alterEndOn"  width="15%"]${stdAlterConfig.alterEndOn?string("是","否")}[/@]
      [@b.col title="异动后学籍状态" property="status.name" width="10%" /]
      [@b.col title="修改属性" property="attributes" width="20%"/]
    [/@]
  [/@]
[/@]
[@b.foot/]
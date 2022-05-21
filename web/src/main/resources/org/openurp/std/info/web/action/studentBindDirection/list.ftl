[#ftl/]
[@b.head/]
[@b.grid items=squades var="squad" sortable="true"]
  <input type="hidden" name="params" value="${b.paramstring}" />
  [@b.gridbar]
    bar.addItem("班级学生方向修改",action.single("squadInfos"),"update.png");
  [/@]
    [@b.row]
      [@b.boxcol/]
      [@b.col property="grade" title="年级" width="10%" /]
           [@b.col property="code" title="班级代码" width="10%"]
             ${(squad.code)!}
             <input type="hidden" id="squad${squad.id}_stdCount" value="${(squad.stdCount)}"/>
           [/@]
      [@b.col title="班级名称" width="26%" ]${(squad.name)!}[/@]
      [@b.col property="level.name" title="entity.EducationLevel" width="15%" /]
      [@b.col property="major.name" title="专业" width="15%" /]
      [@b.col property="stdType.name" title="学生类别" width="10%" /]
      [@b.col sort="squad.stdCount" title="计划/实际(人数)" width="15%"]
        ${(squad.planCount)!}/
        [#if squad.stdCount > squad.planCount]
          <font style="color:red">
          <font style="color:red">${(squad.stdCount)!}</font>
        [#else]
          ${(squad.stdCount)!}
        [/#if]
      [/@]
    [/@]
[/@]
[@b.foot/]

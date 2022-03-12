<#include "/template/head.ftl"/>
<script language="JavaScript" type="text/JavaScript" src="static/scripts/Selector.js"></script>
<BODY LEFTMARGIN="0" TOPMARGIN="0">
  <table id="adminClassBar" with="100%"></table>
  <script>
    var bar = new ToolBar("adminClassBar","班级列表",null,true,true);
    bar.addItem("选中添加","setAdminClasses()");
    bar.addItem("取消","cancelSetAdminClasses()");
    var detailArray= {};
  </script>
  <@table.table align="center" id="adminClassListTable">
    <@table.thead>
      <@table.selectAllTd id="adminClassId"/>
      <@table.td name="attr.code"/>
      <@table.td name="attr.infoname"/>
      <@table.td name="std.state.grade"/>
    </@>
    <@table.tbody datas=adminClassList?sort_by("name");adminClass>
      <@table.selectTd id="adminClassId" value=adminClass.id/>
      <script>
         detailArray['${adminClass.id}'] = {'name':'${adminClass.name?if_exists}'};
      </script>
        <td id="adminClassId_${adminClass.id}">${adminClass.code?if_exists}</td>
        <td>${adminClass.name?if_exists}</td>
        <td>${adminClass.grade}</td>
    </@>
  </@>
  <#list 1..1 as i><br></#list>
  <script>
      function setAdminClasses(){
          var adminClassIds =getSelectIds("adminClassId");
          if(null != adminClassIds && "" != adminClassIds){
              self.parent.document.actionForm["adminClassIds"].value +="," +adminClassIds ;
          }

          var adminClassIdValues = adminClassIds.split(",");
          for (var i = 0; i < adminClassIdValues.length; i++) {
              self.parent.$("student.adminClasses").add(new Option($("adminClassId_" + adminClassIdValues[i]).innerHTML, adminClassIdValues[i]));
          }
          cancelSetAdminClasses();
      }
      function cancelSetAdminClasses(){
          self.parent.cancelSetAdminClasses();
      }
      setAdminClassesChecked();
  </script>
  </body>
<#include "/template/foot.ftl"/>

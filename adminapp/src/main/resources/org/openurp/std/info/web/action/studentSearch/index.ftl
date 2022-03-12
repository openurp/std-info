[#ftl]
[@b.head /]
<script src="${base}/static/scripts/common.js?v=2"></script>
<style>
.frameTable{
  border-collapse: collapse;
  border:solid;
  border-width:1px;
  border-color:#006CB2;
  margin-top:0px;
  margin-bottom:0px;
  width:100%;
  font-size: 10pt;
}
.frameTable_title{
  font-size: 12px;
  border:solid;
  border-width:1px;
  margin-top:0px;
  margin-bottom:0px;
  background-color :#E1ECFF;
  border-color:#006CB2;
  width:100%;
}
.frameTable_view{
    font-size: 10pt;
  border:solid;
  border-width:1px;
  border-right-width:1;
  border-color:#006CB2;
    vertical-align: top;
  background-color: #E1ECFF;
}
.frameTable_content{
  border-width:1px;
    font-size: 10pt;
    vertical-align: top;
}
</style>

<div id="conditionTarget">
<script src='${base}/dwr/engine.js'></script>
<script src='${base}/static/scripts/dwr/util.js'></script>
<script src='${base}/dwr/interface/conditionServiceDwr.js'></script>
<script>beangle.load(["jquery-colorbox"])</script>
[@b.toolbar title='信息查询' id='studentSearchBar']
  bar.addItem("选择字段导出", function() {
    var paramMap = {};

    $("#studentSearchForm").find("[name]").each(function() {
      paramMap[$(this).attr("name")] = $(this).val();
    });

    $(this).colorbox({
      "transition": "none",
      "title": "选择字段导出",
      "overlayClose": false,
      "speed": 0,
      "width": "800px",
      "height": "600px",
      "href": "${base}/student-search!selectColumnBeforeExport",
      "data": paramMap
    });
  });

  bar.addItem("在籍人数统计", function() {
    bg.form.submit("studentOtherForm", "${base}/student-report!inschoolStatReport");
  }, "print.png");
[/@]
  <table class="frameTable" height="90%" id="searchTb">
    <tr>
      <td width="90%" class="frameTable_view">
        [@b.form name="studentSearchForm" action="!search" title="ui.searchForm" target="studentList"]
          [#include "../student/searchForm.ftl"/]
        [/@]
      </td>
    </tr>
    <tr>
      <td valign="top" height="97%">[@b.div id="studentList"/]</td>
    </tr>
  </table>
  [@b.form name="studentOtherForm" action="!search" target="_blank"/]
    <script language="javascript">
        function selectExport() {
          jQuery.colorbox({transition:'none', title:"选择字段导出", overlayClose:false, width:"820px", height:"550px", inline:true, "href":"#selectColumnExport"});
        }
    </script>
</div>
[@b.foot /]

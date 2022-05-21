[@b.head/]
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
<script src='${base}/dwr/engine.js'></script>
<script src='${base}/static/scripts/dwr/util.js'></script>
<script src='${base}/dwr/interface/conditionServiceDwr.js'></script>

<div id="conditionTarget">
[#assign doAction="student.action"/]
[@b.toolbar title='学生信息维护' id='studentBar'/]
    <table class="frameTable" height="90%" id="searchTb">
        <tr>
            <td width="80%" class="frameTable_view">
            [@b.form name="studentSearchForm" id="studentSearchForm" action="!search" title="ui.searchForm" target="studentList"]
              [#include "../student/searchForm.ftl"/]
            [/@]
            </td>
        </tr>
        <tr>
            <td valign="top" height="90%">[@b.div id="studentList"/]</td>
        </tr>
    </table>
</div>
[@b.foot/]

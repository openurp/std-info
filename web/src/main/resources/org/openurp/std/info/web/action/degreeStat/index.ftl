[#ftl]
[@b.head/]
  [@b.toolbar title="学位授予信息统计"/]
  <table class="indexpanel notprint" width="100%">
    <tr>
      <td class="index_view">
        [@b.form name="degreeStatForm" action="!stat" title="ui.searchForm" target="degreeStatDiv"]
        <table class="search-widget">
          <tr>
            <td align="right" width="100px">学位授予日期：</td>
            <td width="100px"><select name="degreeAwardOn">[#list years?sort?reverse as year]<option value="${year?string('yyyy-MM-dd')}">${year?string('yyyy-MM-dd')}</option>[/#list]</select></td>
            <td>[@b.submit value="统计"/]</td>
          </tr>
        </table>
        [/@]
      </td>
    </tr>
  </table>
  [@b.div id="degreeStatDiv"/]
  <script>
    $(function() {
      $(document).ready(function() {
        bg.form.submit("degreeStatForm", "${b.url("!stat")}", "degreeStatDiv");
      });
    });
  </script>
[@b.foot/]

[#ftl]
[@b.head/]
  [@b.toolbar title="毕业信息统计"/]
<div class="search-container">
  <div class="search-list">
        [@b.form name="graduationStatForm" action="!stat" title="ui.searchForm" target="graduationStatDiv"]
        <table class="search-widget">
          <tr>
            <td align="right" width="100px">毕业日期：</td>
            <td width="100px"><select name="graduateOn">[#list years?sort?reverse as year]<option value="${year?string('yyyy-MM-dd')}">${year?string('yyyy-MM-dd')}</option>[/#list]</select></td>
            <td>[@b.submit value="统计"/]</td>
          </tr>
        </table>
        [/@]
  </div>
</div>
  [@b.div id="graduationStatDiv"/]
  <script>
    $(function() {
      $(document).ready(function() {
        bg.form.submit("graduationStatForm", "${b.url("!stat")}", "graduationStatDiv");
      });
    });
  </script>
[@b.foot/]

[#ftl]
[@b.head/]
[@b.toolbar id="studentInfoReportBar" title="学籍统计"/]
<style>
  table.button-table {
    ;
  }
  table.button-table td {
    width: 20%;
    padding: 1px;
  }
  table.button-table button {
    width: 100%;
  }
</style>
<table class="button-table" width="100%">
  <tr>
    <td><button id="btnInschool" type="button">在籍院系男女生人数统计</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
</table>
[@b.form name="studentInfoReportForm" action="!index" target="_blank"/]
<script>
  $(function() {
    $(document).ready(function() {
      $("#btnInschool").click(function() {
        bg.form.submit("studentInfoReportForm", "${base}/studentInfoReport!inschoolStatReport.action");
      });
    });
  });
</script>

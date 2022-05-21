[#ftl]
[@b.head/]
  [@b.toolbar id="siiBar" title="学籍信息导入"]
    bar.addItem("导入模板下载", function() {
      bg.form.submit("downloadForm", "${base}/student!downloadTemplate",null,null,false);
    },"action-download");

    bar.addClose();
  [/@]

  [@b.form name="studentInfoExportForm" action="!importData" theme="list" enctype="multipart/form-data"]
    [@b.messages/]
    <label for="importFile" class="label">文件目录:</label>
    <input type="file" name="importFile" value="" id="importFile"/>
    <div style="padding-left: 110px;">
      [@b.submit value="system.button.submit"/]
    </div>
    <div>
      <div style="color: blue">导入说明：</div>
      <table>
        <tr>
          <td width="18px">1.</td>
          <td>上传的是Excel文件。所有信息均要采用文本格式。对于日期和数字等信息也是一样。</td>
        </tr>
        <tr>
          <td>2.</td>
          <td>导入的一律为当前“项目”；一律为“新增”的学籍信息。</td>
        </tr>
        <tr>
          <td>3.</td>
          <td>选择导入文件中所填的“证件号码/身份证”若系统中存在，则将忽略红色字段的内容，比如姓名、出生年月等。</td>
        </tr>
        <tr>
          <td>4.</td>
          <td>若导入文件中填写的“证件号码/身份证”和“学号”相同存在，则不能导入。</td>
        </tr>
        <tr>
          <td>5.</td>
          <td>标注星号的列必填，除了被忽略的列。</td>
        </tr>
      </table>
    </div>
  [/@]
  <div id="contentDiv" class="ajax_container"></div>
  [@b.form name="downloadForm" action="studentInfo!downloadTemplate"]
    <input type="hidden" name="template" value="template/excel/新增学籍导入.xls" />
  [/@]
  <script>
    $(function() {
      $(document).ready(function() {
        $("form[name=studentInfoExportForm]").find(":submit").click(function() {
          bg.form.submit('studentInfoExportForm',null,null, function() {
            ;
          });
          return false;
        });
      });
    });
  </script>
[@b.foot/]

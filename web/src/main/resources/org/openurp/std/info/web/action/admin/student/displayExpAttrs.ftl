[#ftl]
[@b.head/]
<style>
  .attr_item{
    font-size:0.8125rem !important;
    padding:2px 8px 0px 8px;
  }
  .attr_panel{
    padding-left: 10px;
    display:flex;
    flex-wrap: wrap;
  }
  .attr_title{
    border-width:0px 0px 1px 0px;
    border-bottom-style:solid;
    border-bottom-color:#006CB2;
    margin-top: 10px;
    margin-bottom: 0px;
    font-size: 1rem;
  }
</style>
<div id="divExportColumn">
  <div id="selectShowDiv" style="display:none"></div>
  <div><label style="color: red"><input type="checkbox" name="cbAll" value=""/>全选/全不选以下字段</label></div>

  <h5 class="attr_title">
    <input type="checkbox" name="person_all" id="meta_person" value=""/>
    <label for="meta_person"><span style="font-weight: bold; padding-right: 5px">基本信息</span></label>
  </h5>
  <div class="attr_panel">
    [#list person.attrs as attr]
      <div><label class="btn btn-sm attr_item form-check-label"><input type="checkbox" name="person" value="${attr.name}"/><span>${attr.comments}</span></label></div>
    [/#list]
  </div>

  <h5 class="attr_title">
    <input type="checkbox" name="std_all" id="meta_std" value=""/>
    <label for="meta_std"><span style="font-weight: bold; padding-right: 5px">学籍信息</span></label>
  </h5>
  <div class="attr_panel">
    [#list std.attrs as attr]
      <div><label  class="btn btn-sm attr_item form-check-label"><input type="checkbox" name="std" value="${attr.name}"/><span>${attr.comments}</span></label></div>
    [/#list]
  </div>

  <h5 class="attr_title">
    <input type="checkbox" name="contact_all" id="meta_contact" value=""/>
    <label for="meta_contact"><span style="font-weight: bold; padding-right: 5px">联系信息</span></label>
  </h5>
  <div class="attr_panel">
    [#list contact.attrs as attr]
      <div><label class="btn btn-sm attr_item form-check-label"><input type="checkbox" name="contact" value="${attr.name}"/><span>${attr.comments}</span></label></div>
    [/#list]
  </div>

  <h5 class="attr_title">
    <input type="checkbox" name="examinee_all" id="meta_examinee" value=""/>
    <label for="meta_examinee"><span style="font-weight: bold; padding-right: 5px">考生信息</span></label>
  </h5>
  <div class="attr_panel">
    [#list examinee.attrs as attr]
      <div><label class="btn btn-sm attr_item form-check-label"><input type="checkbox" name="examinee" value="${attr.name}"/><span>${attr.comments}</span></label></div>
    [/#list]
  </div>

  <div style="width: 100%; text-align: center;margin-top:10px;">
    <button id="btnExport" type="button" class="btn btn-outline-primary btn-sm"><i class="fa-solid fa-file-excel"></i>导出</button>
  </div>
  <div id="divHidden" style="display: none">
    [#list Parameters?keys as key]
    <input type="hidden" name="${key}" value="${Parameters[key]!}"/>
    [/#list]
  </div>
</div>
<script>
  $(function() {
    $(document).ready(function() {
      var cbAllObj = $("#divExportColumn").find(":checkbox[name=cbAll]");
      cbAllObj.click(function() {
        var isChecked = $(this).is(":checked");
        $("#divExportColumn").find(":checkbox").each(function() {
          if (this.name.indexOf("_all") == -1 && this.name != "cbAll") {
            if (!this.checked && isChecked) {
              showSelected($(this));
            } else if (this.checked && !isChecked) {
              hiddenSelected($(this));
            }
          }
          this.checked = isChecked;
        });
      });

      $("#divExportColumn").find(":checkbox[name$=_all]").click(function() {
        var isChecked = this.checked;
        if (!isChecked) {
          cbAllObj[0].checked = false;
        }
        $("#divExportColumn").find(":checkbox[name='" + $(this).attr("name").split("_")[0] + "']").each(function() {
          if (this.name.indexOf("_all") == -1 && this.name != "cbAll") {
            if (!this.checked && isChecked) {
              showSelected($(this));
            } else if (this.checked && !isChecked) {
              hiddenSelected($(this));
            }
          }

          this.checked = isChecked;
        });
      });

      $("#divExportColumn").find(":checkbox:not([name=cbAll]):not([name$=_all])").click(function() {
        if (this.checked) {
          showSelected($(this));
        } else {
          hiddenSelected($(this));
          cbAllObj[0].checked = $("#divExportColumn").find(":checkbox[name='" + $(this).attr("name") + "_all']")[0].checked = false;
        }
      });

      function showSelected(checkboxObj) {
        if ($("div#selectShowDiv").children().length > 0) {
          var spaceObj = $("<span>");
          spaceObj.css("padding-left", "5px");
          spaceObj.css("padding-right", "5px");
          spaceObj.html(",");
          $("div#selectShowDiv").append(spaceObj);
        } else {
          var headObj = $("<label>");
          headObj.css("color", "blue");
          headObj.html("当前导出的字段显示顺序为：");
          $("div#selectShowDiv").append(headObj);
          $("div#selectShowDiv").append("<br>");
        }
        var showObj = $("<label>");
        showObj.attr("value", checkboxObj.val() + "_" + checkboxObj.attr("name"));
        showObj.html(checkboxObj.next().html());
        $("div#selectShowDiv").append(showObj);
      }

      function hiddenSelected(checkboxObj) {
        var hiddenObj = $("div#selectShowDiv").find("[value='" + checkboxObj.val() + "_" + checkboxObj.attr("name") + "']");

        if (hiddenObj.prev().length > 0 && hiddenObj.prev()[0].tagName == "SPAN") {
          hiddenObj.prev().remove();
        } else if (hiddenObj.next().length > 0 && hiddenObj.next()[0].tagName == "SPAN") {
          hiddenObj.next().remove();
        }
        hiddenObj.remove();
        if ($("div#selectShowDiv").children().length == 2) {
          $("div#selectShowDiv").children().remove();
        }
      }

      $("#btnExport").click(function() {
        var fieldObjs = $("#divExportColumn").find(":checkbox:checked");
        if (fieldObjs.length == 0) {
          alert("请选择要导出的字段，谢谢！");
          return false;
        }

        var formObj = $("<form>");
        formObj.attr("method", "post");
        formObj.attr("action", "${b.url("!exportData")}");
        formObj.attr("target", "_blank");

        var fileNameObj = $("<input>");
        fileNameObj.attr("type", "hidden");
        fileNameObj.attr("name", "fileName");
        fileNameObj.val("学生学籍信息导出");
        formObj.append(fileNameObj);

        var titles = "";

        $("div#selectShowDiv").find("label[value]").each(function() {
          if (titles!="") {
            titles += ",";
          }
          titles += $(this).attr("value")+":"+$(this).html();
        });

        var titleObj = $("<input>");
        titleObj.attr("type", "hidden");
        titleObj.attr("name", "titles");
        titleObj.val(titles);

        formObj.append(titleObj);

        formObj.append($("#divHidden"));

        formObj.appendTo($("#divExportColumn"));

        formObj.submit();

        $.colorbox.close();
      });
    });
  });
</script>
[@b.foot/]

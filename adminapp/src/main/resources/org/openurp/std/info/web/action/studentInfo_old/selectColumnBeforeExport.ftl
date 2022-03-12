[#ftl]
[#if metas?exists && metas?size gt 0]
<div id="divExportColumn">
  <div id="selectShowDiv"></div>
  <div><label style="color: red"><input type="checkbox" name="cbAll" value=""/>全选/全不选以下字段</label></div>
  <div style="padding-left: 50px">
    [#assign index = 0/]
    [#list (metas?sort_by(["meta", "name"]))?if_exists as meta]
      [#if !(entityMeta??) || (entityMeta.id)?default(-1) != meta.meta.id]
        [#assign entityMeta = meta.meta/]
        [#if meta_index gt 0]
            [#if (index % 5) gt 0 && (index % 5) lt 5]
              [#list (index % 5)..4 as i]
              <td width="20%"></td>
              [/#list]
            </tr>
            [/#if]
          </table>
        </td>
      </tr>
    </table>
        [/#if]
        [#assign index = 0/]
    <table width="100%">
      <tr>
        <td><label><span style="font-weight: bold; padding-right: 5px">${meta.meta.comments}</span><input type="checkbox" name="${meta.meta.name}_all" value=""/>全选/全不选</label></td>
      </tr>
      <tr>
        <td>
          <table width="100%">
      [/#if]
      [#if index % 5 == 0]
            <tr>
      [/#if]
              <td width="20%"><label><input type="checkbox" name="${meta.meta.name}" value="${meta.name}"/><span>${meta.comments?split(" ")?first}</span></label></td>
      [#assign index = index + 1/]
      [#if index % 5 == 0]
            </tr>
      [/#if]
    [/#list]
          </table>
        </td>
      </tr>
    </table>
    <div style="width: 100%; text-align: center">
      <button id="btnExport" type="button">导出</button>
    </div>
    <div id="divHidden" style="display: none">
      [#list Parameters?keys as key]
      <input type="hidden" name="${key}" value="${Parameters[key]!}"/>
      [/#list]
    </div>
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
        formObj.attr("action", "${b.url("!export")}");
        formObj.attr("target", "_blank");

        var fileNameObj = $("<input>");
        fileNameObj.attr("type", "hidden");
        fileNameObj.attr("name", "fileName");
        fileNameObj.val("学生学籍信息导出");
        formObj.append(fileNameObj);

        var keys = "", titles = "";

        $("div#selectShowDiv").find("label[value]").each(function() {
          if (!isBlank(keys)) {
            keys += ",";
            titles += ",";
          }
          keys += $(this).attr("value");
          titles += $(this).html();
        });

        //alert(keys + "\n" + titles);
        //return false;

        var keyObj = $("<input>");
        keyObj.attr("type", "hidden");
        keyObj.attr("name", "keys");
        keyObj.val(keys);

        var titleObj = $("<input>");
        titleObj.attr("type", "hidden");
        titleObj.attr("name", "titles");
        titleObj.val(titles);

        formObj.append(keyObj);
        formObj.append(titleObj);

        formObj.append($("#divHidden"));

        formObj.appendTo($("#divExportColumn"));

        formObj.submit();

        $.colorbox.close();
      });
    });
  });
</script>
[/#if]

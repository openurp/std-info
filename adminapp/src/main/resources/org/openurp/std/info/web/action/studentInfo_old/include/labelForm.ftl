[#ftl]
[@b.form name="labelForm" action="!labelSave" target="_self"]
  <input type="hidden" name="student.id" value="${Parameters["student.id"]}"/>
  [#list Parameters?keys as key]
    [#if key?starts_with("state") || key?starts_with("label")]
    <input type="hidden" name="${key}" value="${Parameters[key]!}"/>
    [/#if]
  [/#list]
  <input type="hidden" name="labelIds" value=""/>
  <input type="hidden" name="isClose" value=""/>
  <span style="color: blue">注意：一个类别只能选一个标签。如果一个类别选了多个标签，则随机取其中一个。</span>
  [@b.grid items=labels var="label" sortable="false"]
    [@b.gridbar]
      bar.addItem("添加", function() {
        var formObj = $("form[name=labelForm]");

        var labelObjs = formObj.find(":checkbox[name='label.id']:checked");

        if (0 == labelObjs.length) {
          alert("请选择要添加的标签，谢谢！");
          return;
        }

        if (confirm("提示：如果一个类别选了多个，则将随机取其中一个。\n\n确定要继续吗？")) {
          var labelIds = "";
          labelObjs.each(function() {
            if (!isBlank(labelIds)) {
              labelIds += ",";
            }
            labelIds += $(this).val();
          });

          formObj.find(":hidden[name=labelIds]").val(labelIds);
          formObj.submit();
        }
      }, "action-new");
      bar.addItem("关闭", function() {
        $.colorbox.close();
      }, "action-close");
    [/@]
    [@b.row]
      [@b.boxcol/]
      [@b.col title="代码" property="code"/]
      [@b.col title="名称" property="name"/]
      [@b.col title="类别" property="labelType.name"/]
    [/@]
  [/@]
[/@]

[#ftl]
[@b.head/]
  [@b.toolbar title="属性元信息"]
    bar.addItem("${b.text('action.back')}","goBack1()");
  [/@]
  <div>
  [@b.form theme="list" action="!save" title="属性元信息维护"]
    [@b.select name="propertyMeta.meta.id" items=entityMetas label="实体元" value=(propertyMeta.meta)?if_exists option="id,comments" empty="..." required="true"/]
    [@b.textfield name="propertyMeta.name" label="属性名称" value="${(propertyMeta.name?html)!}" required="true" /]
    [@b.textfield name="propertyMeta.comments" label="属性说明" value="${(propertyMeta.comments?html)!}" check="maxLength(40)"/]
    [@b.textarea name="propertyMeta.remark" label="备注" value="${(propertyMeta.remark?html)!}" check="maxLength(100)"/]
    [@b.formfoot]
      <input type="hidden" name="propertyMeta.id" value="${(propertyMeta.id)!}"/>
      [@b.reset/]&nbsp;&nbsp;[@b.submit value="action.submit"/]
    [/@]
  [/@]
  </div>
  [@b.form name="goBackForm1" action="!search"/]
  <script language="JavaScript">
    function goBack1(){
      bg.form.submit("goBackForm1");
    }
  </script>
[@b.foot/]

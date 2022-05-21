[#ftl]
[@b.head/]
  [@b.toolbar title="元信息"]
    bar.addItem("${b.text('action.back')}","goBack()");
  [/@]
  <div>
  [@b.form title="元信息管理" theme="list" action="!saveEntityMeta"]
    [@b.textfield style="width:200px" check="maxLength(100)" name="entityMeta.name" value="${(entityMeta.name?html)!}" required="true" label="实体元名称"/]
    [@b.textfield style="width:200px" check="maxLength(100)" name="entityMeta.comments" value="${(entityMeta.comments?html)!}" label="实体元说明"/]
    [@b.formfoot]
      <input type="hidden" name="entityMeta.id" value="${(entityMeta.id)!}"/>
        [@b.reset/]&nbsp;&nbsp;[@b.submit value="action.submit"/]
    [/@]
  [/@]
  </div>
  [@b.form name="goBackForm" action="!entityMetaList"/]
  <script language="JavaScript">
    function goBack(){
      bg.form.submit("goBackForm");
    }
  </script>
[@b.foot/]

[#ftl]
[@b.head/]
  [@b.toolbar title="学生信息修改权限"]
    bar.addItem("全部反选","antiElect()")
    bar.addItem("全部选中","electAll()")
    bar.addItem("${b.text('action.save')}","save(false)")
    bar.addItem("${b.text('action.back')}","goBack()");
  [/@]
  [@b.form title="学生信息修改权限配置" name="stdEditForm" action="!save" class="listform"]
    [@b.tabs]
    [#list propertyMetaMap?keys as key]
        [@b.tab label="${(key.comments?html)!}"]
          [@b.grid items=propertyMetaMap.get(key)?sort_by("name") var="propertyMeta" sortable="false"]
            [@b.row]
              [@b.boxcol boxname=(key.name+".id") checked=(stdEditRestrictions?first.metas?seq_contains(propertyMeta))!false/]
              [@b.col width="12%" property="name" title="属性元"/]
              [@b.col width="22%" property="comments" title="属性说明"/]
              [@b.col width="25%" property="meta.comments" title="实体元说明"/]
              [@b.col width="38%" property="type" title="类型"/]
            [/@]
          [/@]
        [/@]
    [/#list]
    <input type="hidden" value="${(user.id)!}" name="user.id"/>
    <input type="hidden" value="${(stdEditRestrictions?first.id)!}" name="stdEditRestriction.id"/>
    [/@]
  [/@]
  <script language="JavaScript">
    function goBack(){
      bg.Go("stdEditRestriction!index.action","main");
    }

    function save(flag){
      if(flag){
        bg.form.addInput(document.stdEditForm,"saveAll","true");
      }
      bg.form.submit("stdEditForm");
    }

    function antiElect(){
      $(".listform :checkbox[name$='.id']").each(function(){
        var flag = $(this).prop("checked");
        $(this).attr("checked",!flag);
      });
    }

    function electAll(){
      $(".listform :checkbox[name$='.id']").each(function(){
        $(this).prop("checked",true);
      });
    }
  </script>
[@b.foot/]

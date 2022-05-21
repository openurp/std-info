[#ftl]
[@b.head/]
  [@b.toolbar title="学生信息修改权限"/]
  [@b.form title="学生信息修改权限配置" name="stdEditForm" action="!save" class="listform"]
      [@b.grid items=entityMetas var="entityMeta" sortable="false"]
      [@b.gridbar]
        bar.addItem("全部反选","antiElect()")
        bar.addItem("全部选中","electAll()")
        bar.addItem("${b.text('action.save')}","save(false)")
[#--        bar.addItem("${b.text('action.back')}","goBack()");--]
      [/@]
      [@b.row]
        [@b.boxcol boxname=("entityMeta.id") checked=(stdEditRestrictions?first.metas?seq_contains(entityMeta))!false/]
        [@b.col property="name" title="实体元名称"]${(entityMeta.comments?html)!}[/@]
      [/@]
    <input type="hidden" value="${(user.id)!}" name="stdEditRestriction.user.id"/>
    <input type="hidden" value="${(stdEditRestrictions?first.id)!}" name="stdEditRestriction.id"/>
    [/@]
  [/@]
  <script language="JavaScript">
    function goBack(){
      bg.Go("${b.url("!index")}","main");
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

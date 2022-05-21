[#ftl]
[@b.head/]
[@b.toolbar title="信息修改权限"]
  bar.addItem("实体元管理", function() {
    window.open("${base}/std-property-meta!entityMetaList");
  }, "update.png");
[/@]
[@b.form name="stdEditRestrictionForm" action="!index"]
  [@b.grid items=users?if_exists var="user" filterable="true" sortable="false"]
    [#--
    [@b.gridfilter property="enabled"]
    <select  name="user.enabled" style="width:98%;" onchange="bg.form.submit(this.form)">
      <option value="" [#if (Parameters['user.enabled']!"")=""]selected="selected"[/#if]>..</option>
      <option value="true" [#if (Parameters['user.enabled']!"")="true"]selected="selected"[/#if]>${b.text("action.activate")}</option>
      <option value="false" [#if (Parameters['user.enabled']!"")="false"]selected="selected"[/#if]>${b.text("action.freeze")}</option>
    </select>
    [/@]
     --]
    [@b.gridbar]
      bar.addItem("分配权限","edit()");
      function edit(){
      var idSeq = bg.input.getCheckBoxValues("user.id");
      if(idSeq==""){alert("请选择帐号");return;}
      bg.form.submit(document.actionForm, "${base}/std-edit-restriction!editForm?user.id="+idSeq);
      }
      [#--
      bar.addItem("${b.text("action.info")}",action.info());
      bar.addItem("${b.text("action.delete")}",action.remove());
       --]
    [/@]
    [@b.row]
      [@b.boxcol value=(user.id)!/]
      [@b.col property="code" width="20%" title="用户帐号"/]
      [@b.col property="name" width="20%" title="用户名"/]
      [@b.col property="category.name" title="身份" /]
      [@b.col title="是否配置"][#if userMap.get(user)??]已配置[#else]未配置[/#if][/@]
    [/@]
  [/@]
[/@]

[@b.form name="actionForm" target="_blank" method="post" action=""/]
[@b.foot/]

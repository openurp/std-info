[#ftl]
[@b.head/]
[@b.form name="propertyMetaIndexForm" action="!search"]
  [@b.grid items=propertyMetas var="propertyMeta" filterable="true"]
    [@b.filter property="meta.comments"]
      <select name="propertyMeta.meta.id" style="width:98%" onchange="bg.form.submit(this.form)">
        <option value="">...</option>
        [#list entityMetas as entityMeta]
          <option value="${(entityMeta.id)!}" [#if (Parameters['propertyMeta.meta.id']!"")=entityMeta.id?string]selected[/#if]>${(entityMeta.comments?html)!}</option>
        [/#list]
      </select>
    [/@]
    [@b.gridbar]
      bar.addItem("${b.text('action.new')}",action.add());
      bar.addItem("${b.text('action.edit')}",action.edit());
      bar.addItem("${b.text('action.info')}",action.info());
      bar.addItem("${b.text('action.delete')}",action.remove());
[#--      bar.addItem("${b.text('初始化')}",action.method('initPropertyMetas',"是否确认初始化，初始化将清除学生信息维护权限和现有属性元信息"));--]
    [/@]
    [@b.row]
      [@b.boxcol width="5%"/]
      [@b.col width="12%" property="name" title="属性元"/]
      [@b.col width="12%" property="comments" title="属性说明"/]
      [@b.col width="38%" property="type" title="类型"/]
      [@b.col width="25%" property="meta.comments" title="实体元说明"/]
    [/@]
  [/@]
[/@]
[@b.foot/]

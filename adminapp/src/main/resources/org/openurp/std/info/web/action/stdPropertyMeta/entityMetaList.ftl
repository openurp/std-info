[#ftl]
[@b.head/]
[@b.form name="entityMetaForm" action="!entityMetaList"]
  [@b.grid items=entityMetas var="entityMeta" filterable="true"]
    [@b.gridbar]
      bar.addItem("${b.text('action.new')}","newMeta()","new.png");
      bar.addItem("${b.text('action.edit')}","edit()");
      bar.addItem("${b.text('action.delete')}","remove()");
      function newMeta(){
        bg.form.submit(document.actionForm, "${base}/std-property-meta!editEntityMeta");
      }
      function edit(){
        var idSeq = bg.input.getCheckBoxValues("entityMeta.id");
        if(idSeq==""){alert("请选择");return;}
        bg.form.submit(document.actionForm, "${base}/std-property-meta!editEntityMeta?entityMeta.id="+idSeq);
      }
      function remove(){
        var idSeq = bg.input.getCheckBoxValues("entityMeta.id");
        if(idSeq==""){alert("请选择");return;}
        if(confirm("是否确认删除?")) {
          bg.form.submit(document.actionForm, "${base}/std-property-meta!removeEntityMeta?entityMeta.id="+idSeq);
        }
      }
    [/@]
    [@b.row]
      [@b.boxcol/]
      [@b.col property="name" title="实体元"/]
      [@b.col property="comments" title="实体说明"/]
    [/@]
  [/@]
[/@]
[@b.form name="actionForm"  method="post" action=""/]
[@b.foot/]

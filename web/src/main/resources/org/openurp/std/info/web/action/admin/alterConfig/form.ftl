[#ftl/]
[@b.head/]
[@b.toolbar title="学籍类型异动"]
  bar.addBack();
[/@]
<style>
   label.title{
     width:200px;
   }
</style>
[@b.form action=b.rest.save(stdAlterConfig) title="学籍类型异动维护" theme="list"]
    [@b.select name="stdAlterConfig.alterType.id" items=stdAlterTypes
          label="学籍异动" value=(stdAlterConfig.alterType.id)!("") empty="..." style="width:200px" required="true" /]
    [@b.radios label="异动后是否在校"   name="stdAlterConfig.inschool" value=stdAlterConfig.inschool required="true" style="width:200px"/]
    [@b.radios label="异动是否有结束日期"   name="stdAlterConfig.temporal" value=stdAlterConfig.temporal required="true" style="width:200px"/]
    [@b.radios label="需要修改学籍失效日期"   name="stdAlterConfig.alterEndOn"  value=stdAlterConfig.alterEndOn required="true" style="width:200px"/]
    [@b.select name="stdAlterConfig.status.id" items=statuses
          label="异动后学籍状态" value=(stdAlterConfig.status.id)!("") empty="..." style="width:200px" required="true" /]
    [@b.textfield label="修改学籍状态的属性" name="stdAlterConfig.attributes" value=stdAlterConfig.attributes! required="false" style="width:300px"/]
    [@b.formfoot]
      [@b.reset value="重置"/]
      [@b.submit value="提交"/]
    [/@]
[/@]

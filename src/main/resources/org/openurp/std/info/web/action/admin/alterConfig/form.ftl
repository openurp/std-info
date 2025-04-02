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
[@b.form action=b.rest.save(alterConfig) title="学籍类型异动维护" theme="list"]
    [@b.select name="alterConfig.alterType.id" items=stdAlterTypes
          label="学籍异动" value=(alterConfig.alterType.id)!("") empty="..." style="width:200px" required="true" /]
    [@b.radios label="异动后是否在校"  name="alterConfig.inschool" value=alterConfig.inschool required="true" style="width:200px"/]
    [@b.radios label="修改预计离校日期" name="alterConfig.alterEndOn"  value=alterConfig.alterEndOn required="true" style="width:200px"/]
    [@b.radios label="修改预计毕业日期" name="alterConfig.alterGraduateOn"  value=alterConfig.alterGraduateOn required="true" style="width:200px"/]
    [@b.select name="alterConfig.status.id" items=statuses
          label="异动后学籍状态" value=(alterConfig.status.id)!("") empty="..." style="width:200px" required="true" /]
    [@b.textfield label="修改学籍状态的属性" name="alterConfig.attributes" value=alterConfig.attributes! required="false" style="width:300px"/]
    [@b.formfoot]
      [@b.reset value="重置"/]
      [@b.submit value="提交"/]
    [/@]
[/@]

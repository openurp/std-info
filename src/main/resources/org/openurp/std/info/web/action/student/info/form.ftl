[#ftl]
[@b.head/]
[@b.toolbar title="修改基本信息"]bar.addBack();[/@]
[@b.form action="!save" theme="list"]
  [@b.field label="注意事项"]<span class="text-warning">部分信息用于上报上级教育部门，请如实填写</span>[/@]
  [@b.field label="学生"]${student.code} ${student.name}[/@]
  [@b.textfield id="phoneticName" name="enName" label="姓名拼音" value=student.enName! required="true"/]
  [@base.code type="political-statuses" label="政治面貌" name="person.politicalStatus.id" empty="..." value=(person.politicalStatus)! required="true"/]
  [@b.textfield name="person.homeTown" label="籍贯" value=person.homeTown! required="false" maxlength="400" style="width:400px"/]
  [@b.cellphone name="mobile" label="移动电话" value=contact.mobile! required="true"/]
  [@b.email name="email" label="电子邮箱" value=contact.email! required="false"/]
  [@b.textfield name="phone" label="联系电话" value=contact.phone! required="false"/]
  [@b.textfield name="address" label="联系地址" value=contact.address! required="false" maxlength="400" style="width:400px"/]
  [@b.textfield name="home.address" label="家庭地址" value=home.address! required="false" maxlength="400" style="width:400px"/]
  [@b.formfoot]
    [@b.reset/]&nbsp;&nbsp;[@b.submit value="action.submit"/]
  [/@]
[/@]
  <script>
    $(function() {
      jQuery('#phoneticName').after("<a href='javascript:void(0)' style='margin-left: 10px;' onclick='return auto_pinyin()'>获取拼音</a>");
    });
    function auto_pinyin(){
      var name = encodeURIComponent('${student.name}');
      $.get("${api}/tools/sns/person/pinyin/"+name+".json",function(data,status){
          jQuery('#phoneticName').val(data);
      });
      return false;
    }
  </script>
[@b.foot/]

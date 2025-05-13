[@b.head/]
[@b.toolbar title="异动申请详情"]
  bar.addBack();
[/@]
  [@b.form name="applyForm" action="!audit" theme="list"]
    [@b.field label="审核环节"][#list tasks as task]${task.name}[#sep],[/#list][/@]
    [#if alterData?size!=0]
    [@b.field label="变更内容"]
      [#list alterData as k,ai]
        ${ai.meta}: ${ai.oldtext!} -> ${ai.newtext!}[#sep]<br>
      [/#list]
    [/@]
    [/#if]
    [@b.radios name="passed" value="1" label="是否同意" required="true" onclick="resetOpinion(this)"/]
    [@b.textarea name="comments" id="comments" required="true" rows="4" style="width:80%" label="审核意见" placeholder="请填写意见" value="同意"]
      <div style="display: block;margin-left: 6.25rem;">可填写其他审核意见和补充内容</div>
    [/@]
    [@b.esign label="签名" name="sign" required="true" width="600" height="200" remoteHref=signature_url/]
    [@b.formfoot]
      <input name="stdAlterApply.id" value="${apply.id}" type="hidden"/>
      [@b.submit value="提交"/]
    [/@]
  [/@]
  <script>
    function resetOpinion(ele){
      var reject=jQuery(ele).val()=='0';
      if(reject) {
        jQuery("#comments").val('');
      }else{
        jQuery("#comments").val('同意');
      }
    }
  </script>
[@b.foot/]

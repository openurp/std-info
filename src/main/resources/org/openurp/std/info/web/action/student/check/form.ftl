[#ftl]
[@b.head/]
<div class="container text-sm">
  [@b.toolbar title="基本信息核对"]
    bar.addBack("${b.text("action.back")}");
  [/@]
  [#macro panel title]
  <div class="card card-info card-outline">
    <div class="card-header">
      <h3 class="card-title">${title}</h3>
    </div>
    [#nested/]
  </div>
  [/#macro]

  [@panel title="个人基本信息"]
    [#assign person = student.person/]
    [@b.form name="checkForm" action="!check" theme="list" caption="请逐项核对" onsubmit="checkAttachment"]
      [@b.field label="操作提示"]下列项目逐一确认，每项信息，若无异议直接点击维护的确认按钮，如信息有误，则可以直接填写。[/@]
      [@b.field label="姓名"]
        ${student.name}
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return check(this);"><i class="fa-solid fa-check"></i> 确认</button>
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return openEdit(this);"><i class="fa-regular fa-pen-to-square"></i> 修改</button>
        <input name="person.name" id="name" value="${student.name}" type="text" style="display:none"/>
      [/@]
      [@b.field label="性别"]
        ${std.gender.name}
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return check(this);"><i class="fa-solid fa-check"></i> 确认</button>
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return openEdit(this);"><i class="fa-regular fa-pen-to-square"></i> 修改</button>
        [@b.select name="person.gender.name" id="gender" value=std.gender! required="true" theme="html" style="display:none" items=genders option="name,name"/]
      [/@]
      [@b.field label="出生年月"]
        ${(person.birthday?string("yyyy年MM月dd日"))!}
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return check(this);"><i class="fa-solid fa-check"></i> 确认</button>
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return openEdit(this);"><i class="fa-regular fa-pen-to-square"></i> 修改</button>
        [@b.date name="person.birthday" id="birthday" value=person.birthday! required="true" theme="html" style="display:none"/]
      [/@]
      [@b.field label="证件类型"]
        ${person.idType.name}
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return check(this);"><i class="fa-solid fa-check"></i> 确认</button>
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return openEdit(this);"><i class="fa-regular fa-pen-to-square"></i> 修改</button>
        [@b.select name="person.idType.name" id="idType" value=person.idType! required="true" theme="html" style="display:none" items=idTypes option="name,name"/]
      [/@]
      [@b.field label="证件号码"]
        [#if person.code?length==18]<u>${person.code[0..5]}</u>&nbsp;<u>${person.code[6..13]}</u>&nbsp;<u>${person.code[14..17]}</u>[#else]${person.code}[/#if]
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return check(this);"><i class="fa-solid fa-check"></i> 确认</button>
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return openEdit(this);"><i class="fa-regular fa-pen-to-square"></i> 修改</button>
        [@b.textfield name="person.code" id="code" value=person.code required="true" theme="html" style="display:none"/]
      [/@]
      [@b.field label="民族"]
        ${(person.nation.name)!}
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return check(this);"><i class="fa-solid fa-check"></i> 确认</button>
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="return openEdit(this);"><i class="fa-regular fa-pen-to-square"></i> 修改</button>
        [@b.select name="person.nation.name" id="nation" value=person.nation! required="true" theme="html" style="display:none;width:100px" items=nations option="name,name" chosenMin="300"/]
      [/@]
      [@b.textfield label="手机号" name="mobile" value="${mobile!}" required="true"]
        [#if smsAvailable]
        <button class="btn btn-sm btn-outline-info" style="border-style: none;" onclick="sendVerificationCode(this.previousElementSibling.value);return false;"><i class="fa-regular fa-message"></i> 发送验证码</button>
        [/#if]
      [/@]
      [#if smsAvailable][@b.textfield label="验证码" name="verificationCode" value="" required="true"/][/#if]
      [@b.file name="attachment" label="证件图片" comment="如信息有误，请上传证件图片。"/]
      [@b.formfoot]
        [@b.submit value="核对完成"/]
      [/@]
    [/@]
  [/@]
  <script>
    var confirmed={};
    function check(elem) {
      if(elem.innerHTML=='<i class="fa-solid fa-check"></i> 确认'){
        elem.innerHTML='<i class="fa-solid fa-check"></i> 已确认';
        elem.className="btn btn-sm btn-outline-success";
        nextSibling(elem).style.display="none";
        var changedElem = nextSibling(nextSibling(elem));
        confirmed[changedElem.id]=1;
        changedElem.style.display="none";
      }else{
        elem.innerHTML='<i class="fa-solid fa-check"></i> 确认';
        elem.className="btn btn-sm btn-outline-info";
        nextSibling(elem).style.display="";
        confirmed[nextSibling(nextSibling(elem)).id]=0;
      }
      return false;
    }

    function sendVerificationCode(v){
      if(v){
        var url = "${b.url('!sendVerificationCode')}";
        var data = {mobile:v};
        $.post(url, data, function (result) {
          alert (result);
        });
      }else{
        alert("请输入手机号。")
      }
    }

    function openEdit(elem) {
      var next = nextSibling(elem);
      if(elem.innerHTML=='<i class="fa-regular fa-pen-to-square"></i> 修改'){
        elem.innerHTML='<i class="fa-solid fa-rotate-left"></i> 放弃修改';
        next.style.display="";
        preSibling(elem).style.display="none";
        confirmed[next.id]=2;
      }else{
        elem.innerHTML='<i class="fa-regular fa-pen-to-square"></i> 修改';
        next.style.display="none";
        preSibling(elem).style.display="";
        confirmed[next.id]=0;
      }
      return false;
    }

    function preSibling(elem){
      var a = elem.previousElementSibling;
      while(a && a.tagName!="INPUT" && a.tagName !="SELECT" && a.tagName !="BUTTON"){
        a = a.previousElementSibling;
      }
      return a;
    }
    function nextSibling(elem){
      var a = elem.nextElementSibling;
      while(a && a.tagName!="INPUT" && a.tagName !="SELECT" && a.tagName !="BUTTON"){
        a = a.nextElementSibling;
      }
      return a;
    }

    function checkAttachment(form){
      var items=["name","gender","birthday","idType","code","nation"];
      var itemNames=["姓名","性别","出生日期","证件类型","证件号码","民族"];
      var missing=[]
      for(var i=0; i<items.length; i++){
        if(typeof confirmed[items[i]] === "undefined" || !confirmed[items[i]]){
          missing.push(itemNames[i]);
        }
      }
      if(missing.length>0){
        alert("请确认"+missing.join("、")+"。");
        return false;
      }
      missing=[];
      for(var i=0; i<items.length; i++){
        if(confirmed[items[i]] >1){
          missing.push(itemNames[i]);
        }
      }
      if(missing.length>0){
        if(!form['attachment'].value){
          alert("请上传包含"+missing.join("、")+"的证件图片。");
          return false;
        }
      }
      return true;
    }
  </script>
</div>
[@b.foot/]

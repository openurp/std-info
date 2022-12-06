[#ftl]
[@b.head/]
[@b.toolbar title='学生信息维护']
     bar.addBackOrClose();
[/@]
[@b.messages slash = "7"/]

  [@b.form name="studentForm" action="!save"]
    <input type="hidden" name="student.id" value="${(student.id)!}"/>
    <input type="hidden" name="contact.id" value="${(contact.id)!}"/>
    <input type="hidden" name="home.id" value="${(home.id)!}"/>
    <input type="hidden" name="examinee.id" value="${(examinee.id)!}"/>

    <div class="card card-primary card-outline" style="background-color: #f4f6f9;">
      <div class="card-header">
        <h3 class="card-title">学生联系信息</h3>
      </div>
      <div class="card-body" style="padding: 0px 20px;">
        [@b.fieldset theme="list"]
          [@b.textfield label="电子邮箱" name="contact.email" value=(contact.email)! maxlength="100" style="width: 200px" /]
          [@b.textfield label="电话" name="contact.phone" value=(contact.phone)! maxlength="100" style="width: 200px"/]
          [@b.textfield label="移动电话" name="contact.mobile" value=(contact.mobile)! maxlength="100" style="width: 200px"/]
          [@b.textfield label="联系地址" name="contact.address" value=(contact.address)! maxlength="100" style="width: 500px" /]
        [/@]
      </div>
      <div class="card-header">
        <h3 class="card-title">学生家庭信息</h3>
      </div>
      <div class="card-body"  style="padding: 0px 20px;">
        [@b.fieldset theme="list"]
          [@b.textfield label="家庭电话" name="home.phone" value=(home.phone)! maxlength="100" style="width: 200px" /]
          [@b.textfield label="家庭地址" name="home.address" value=(home.address)! maxlength="100" style="width: 500px"/]
          [@b.textfield label="家庭地址邮编" name="home.postcode" value=(home.postcode)! maxlength="6" style="width: 200px"/]
          [@b.textfield label="户籍" name="home.formerAddr" value=(home.formerAddr)! maxlength="100" style="width: 200px"/]
          [@b.textfield label="派出所" name="home.police" value=(home.police)! maxlength="100" style="width: 200px"/]
          [@b.textfield label="派出所电话" name="home.policePhone" value=(home.policePhone)! maxlength="100" style="width: 200px"/]
          [@b.formfoot]
            [@b.submit value="保存"/]
          [/@]
        [/@]
      </div>
    </div>
  [/@]
[@b.foot/]

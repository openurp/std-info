[#ftl]
[@b.head/]
[@b.toolbar title='个人基本信息维护']
   bar.addBackOrClose();
[/@]
[@b.messages slash = "7"/]
[@b.form name="studentForm" action="!save" theme="list"]
  <input type="hidden" name="student.id" value="${(student.id)!}"/>
  <input type="hidden" name="student.person.id" value="${(student.person.id)!}"/>
  <input type="hidden" name="examinee.id" value="${(examinee.id)!}"/>
 <div class="container-fluid"  style="background-color: #f4f6f9;">

   <div class="row">
    <div class="card card-primary card-outline col-5" style="margin-bottom: 0rem;background-color: #f4f6f9;">
      <div class="card-header">
        <h3 class="card-title">基本信息</h3>
      </div>
      <div class="card-body" style="padding: 0px 20px;">
        [@b.fieldset]
          [@b.field label="学号"]<span style="height: 25px;display: inline-block;">${student.code}</span>[/@]
          [@b.textfield label="姓名" name="student.name" required="true" value=(student.name)! maxlength="100" /]
          [@b.textfield label="英文名" id="phoneticName" name="student.person.phoneticName" value=(student.person.phoneticName)! maxlength="100" style="width: 120px"/]
          [@b.textfield label="曾用名" name="student.person.formerName" value=(student.person.formerName)! maxlength="100" /]
          [@b.select label="性别" name="student.person.gender.id" items=genders empty="..." required="true" value=(student.person.gender.id)! /]
          [@b.datepicker label="出生年月" name="student.person.birthday" format="yyyy-MM-dd" readonly="readonly" value=(student.person.birthday)! /]
          [@b.select label="证件类型" name="student.person.idType.id" items=idTypes empty="..." value=(student.person.idType.id)! /]
          [@b.textfield label="证件号码" name="student.person.code" required="true" value=(student.person.code)! maxlength="32" /]
          [@b.select label="国家地区" name="student.person.country.id" items=countries empty="..." value=(student.person.country)! /]
          [@b.select label="民族" name="student.person.nation.id" items=nations empty="..." value=(student.person.nation)! /]
          [@b.select label="政治面貌" name="student.person.politicalStatus.id" items=politicalStatuses empty="..." value=(student.person.politicalStatus)! /]
          [@b.textfield label="籍贯" name="student.person.homeTown" value=(student.person.homeTown)! maxlength="100" /]
        [/@]
      </div>
    </div>
    <div class="card card-primary card-outline col-7"  style="margin-bottom: 0rem;background-color: #f4f6f9;">
      <div class="card-header">
        <h3 class="card-title">学籍信息</h3>
      </div>
      <div class="card-body"  style="padding: 0px 20px;">
        [@b.fieldset]
          [@b.select label="培养类型" name="student.eduType.id" items=eduTypes empty="..." required="true" value=student.eduType!/]
          [@b.select label="培养层次" name="student.level.id" items=levels empty="..." required="true" value=student.level!/]
          [@b.select label="学生类别" name="student.stdType.id" items=stdTypes empty="..." required="true" value=student.stdType!/]
          [@b.textfield label="学制" name="student.duration" required="true" value=student.duration  check="greaterThan(0).match('number')" maxlength="5"/]
          [@b.radios label="是否有学籍" name="student.registed" required="true" value=student.registed?string(1, 0)/]
          [@b.startend label="学籍生效日期" name="student.beginOn,student.endOn" required="true" start=student.beginOn end=student.endOn style="width: 120px"/]
          [@b.startend label="入学-毕业日期" name="student.studyOn,student.graduateOn" required="true" start=student.studyOn end=student.graduateOn style="width: 120px" /]
          [@b.select label="学习形式" name="student.studyType.id" required="true" items=studyTypes empty="..." value=(student.studyType.id)! /]
          [@b.select label="导师" name="student.tutor.id" href=EMS.api+'/base/edu/${student.project.id}/teachers.json?q={term}&isTutor=1' empty="..." value=student.tutor!
                     option="id,description" style="width: 400px"/]
          [@b.select label="标签" name="labelIds" items=stdLabels values=student.labels?values /]
          [@b.textfield label="备注" name="student.remark" value=(student.remark?html)! style="width: 400px;" check="maxLength(100)" comments="（限长100个字符）"/]
        [/@]
      </div>
    </div>
  </div>

  <div class="row">

    <div class="card card-primary card-outline col-5" style="background-color: #f4f6f9;">
      <div class="card-header">
        <h3 class="card-title">当前学籍状态</h3>
      </div>
      <div class="card-body"  style="padding: 0px 20px;">
        [#assign state=student.state/]
        <input name="state.id" value="${state.id}" type="hidden"/>
        [@b.fieldset]
          [@b.select label="年级" name="state.grade.id" value=(state.grade)! items=grades required="true" /]
          [@b.select label="院系" id="department"  name="state.department.id" items=departments empty="..." required="true" value=state.department! /]

          [@b.select id="major" label="专业" name="state.major.id" items=majors empty="..." value=state.major! /]
          [@b.select id="direction" label="方向" name="state.direction.id" items=directions empty="..." value=state.direction! /]
          [@b.select label="校区" name="state.campus.id" items=campuses empty="..." required="true" value=state.campus! /]
          [@b.select label="行政班级" name="state.squad.id" items=squads empty="..." value=state.squad! /]
          [@b.radios label="是否在校" name="state.inschool" value=state.inschool/]
          [@b.select label="学籍状态" name="state.status.id" items=statuses empty="..." value=state.status! /]
          [@b.startend label="起始结束" name="state.beginOn,state.endOn" required="true" start=state.beginOn end=state.endOn style="width: 100px"/]
        [/@]
      </div>
    </div>

    <div class="card card-primary card-outline col-7" style="background-color: #f4f6f9;">
      <div class="card-header">
        <h3 class="card-title">招生信息</h3>
      </div>
      <div class="card-body"  style="padding: 0px 20px;">
        [@b.fieldset]
          [@b.textfield label="考生号" name="examinee.code" value=(examinee.code)! maxlength="100"  /]
          [@b.textfield label="准考证号" name="examinee.examNo" value=(examinee.examNo)! maxlength="100" /]
          [@b.select label="生源地" name="examinee.originDivision.id" items=divisions empty="..." value=examinee.originDivision!/]
          [@b.select label="入学方式" name="examinee.enrollMode.id" items=enrollModes empty="..." value=examinee.enrollMode!/]
          [@b.select label="培养方式" name="examinee.educationMode.id" items=educationModes empty="..." value=examinee.educationMode!/]
          [@b.textfield label="委培单位" name="examinee.client"   value=examinee.client!  style="width: 400px"/]
          [@b.textfield label="毕业学校名称" name="examinee.schoolName" value=(examinee.schoolName)! maxlength="100" style="width: 400px"/]
          [@b.datepicker label="毕业日期" id="examinee.graduateOn" name="examinee.graduateOn" value=examinee.graduateOn!  /]
          [@b.textfield label="招生录取总分" name="examinee.score" value=(examinee.score)! maxlength="100" /]
        [/@]
      </div>
    </div>

  </div><!--end row-->
  <div class="row">
    <div class="col-12">
    [@b.formfoot]
      [@b.submit value="保存"/]
    [/@]
    </div>
  </div>
</div><!--end container-->
[/@]

<br>
  <script>
    $(function() {
      jQuery('#phoneticName').after("<a href='javascript:void(0)' style='margin-left: 10px;' onclick='return auto_pinyin()'>获取拼音</a>");
    });
    function auto_pinyin(){
      var name = document.studentForm['student.name'].value;
      if(name) name = encodeURIComponent(name);
      $.get("${api}/tools/sns/person/pinyin/"+name+".json",function(data,status){
          jQuery('#phoneticName').val(data);
      });
      return false;
    }
  </script>

[@b.foot/]

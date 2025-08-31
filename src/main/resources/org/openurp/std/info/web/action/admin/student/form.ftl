[#ftl]
[@b.head/]
[@b.toolbar title='个人基本信息维护']
   bar.addBackOrClose();
[/@]
[@b.messages slash = "7"/]
[@b.form name="studentForm" action="!save" theme="list"]
  <input type="hidden" name="student.id" value="${(student.id)!}"/>
  <input type="hidden" name="person.id" value="${(student.person.id)!}"/>
  <input type="hidden" name="examinee.id" value="${(examinee.id)!}"/>
 <div class="container-fluid"  style="background-color: #f4f6f9;">
   [#assign person =student.person/]
   <div class="row">
    <div class="card card-primary card-outline col-5" style="margin-bottom: 0rem;background-color: #f4f6f9;">
      <div class="card-header">
        <h3 class="card-title">基本信息</h3>
      </div>
      <div class="card-body" style="padding: 0px 20px;">
        [@b.fieldset]
          [@b.field label="学号"]<span style="height: 25px;display: inline-block;">${student.code}</span>[/@]
          [@b.textfield label="姓名" name="student.name" required="true" value=(student.name)! maxlength="100" /]
          [@b.textfield label="英文名" id="phoneticName" name="person.phoneticName" value=(person.phoneticName)! maxlength="100" style="width: 120px"/]
          [@b.textfield label="曾用名" name="person.formerName" value=(person.formerName)! maxlength="100" /]
          [@base.code type="genders" label="性别" name="person.gender.id" empty="..." required="true" value=(person.gender)! /]
          [@b.date label="出生年月" name="person.birthday" format="yyyy-MM-dd" readonly="readonly" value=(person.birthday)! /]
          [@base.code type="id-types" label="证件类型" name="person.idType.id" empty="..." value=(person.idType)! /]
          [@b.textfield label="证件号码" name="person.code" required="true" value=(person.code)! maxlength="32" /]
          [@base.code type="countries" label="国家地区" name="person.country.id" empty="..." value=(person.country)! /]
          [@base.code type="nations" label="民族" name="person.nation.id" empty="..." value=(person.nation)! /]
          [@base.code type="political-statuses" label="政治面貌" name="person.politicalStatus.id" empty="..." value=(person.politicalStatus)! /]
          [@b.textfield label="籍贯" name="person.homeTown" value=(person.homeTown)! maxlength="100" /]
        [/@]
      </div>
    </div>
    <div class="card card-primary card-outline col-7"  style="margin-bottom: 0rem;background-color: #f4f6f9;">
      <div class="card-header">
        <h3 class="card-title">学籍信息</h3>
      </div>
      <div class="card-body"  style="padding: 0px 20px;">
        [@b.fieldset]
          [@base.code type="education-types" label="培养类型" name="student.eduType.id" empty="..." required="true" value=student.eduType!/]
          [@base.code type="education-levels" label="培养层次" name="student.level.id" empty="..." required="true" value=student.level!/]
          [@base.code type="std-types" label="学生类别" name="student.stdType.id" empty="..." required="true" value=student.stdType!/]
          [@b.textfield label="学制" name="student.duration" required="true" value=student.duration  check="greaterThan(0).match('number')" maxlength="5"/]
          [@b.radios label="是否有学籍" name="student.registed" required="true" value=student.registed?string(1, 0)/]
          [@b.startend label="入学~预计毕业" name="student.beginOn,student.graduateOn" required="true" start=student.beginOn end=student.graduateOn style="width: 120px"/]
          [@b.startend label="预计离校~最晚" name="student.endOn,student.maxEndOn" required="true" start=student.endOn end=student.maxEndOn style="width: 120px"
          onchange="syncGraduateOn(this)"
          comment="最晚离校，不随学籍异动而变化"/]
          [@base.code type="study-types" label="学习形式" name="student.studyType.id" required="true" empty="..." value=(student.studyType.id)! /]
          [@base.teacher label="导师" name="tutor.id" empty="..." values=student.majorTutors style="width: 400px" multiple="true"/]
          [#if advisorSupported]
          [@base.teacher label="论文指导教师" name="advisor.id" empty="..." value=student.thesisTutor! style="width: 400px"/]
          [/#if]
          [@b.select label="标签" name="labelIds" items=stdLabels values=student.labels?values /]
          [@b.radios label="是否延期毕业" name="student.graduationDeferred" required="true" value=student.graduationDeferred?string(1, 0)/]
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
          [@base.grade label="年级" name="state.grade.id" value=(state.grade)! required="true" /]
          [@b.select label="院系" id="department"  name="state.department.id" items=departments empty="..." required="true" value=state.department! /]

          [@b.select id="major" label="专业" name="state.major.id" items=majors empty="..." value=state.major! /]
          [@b.select id="direction" label="方向" name="state.direction.id" items=directions empty="..." value=state.direction! /]
          [@base.campus label="校区" name="state.campus.id" empty="..." required="true" value=state.campus! /]
          [@b.select label="班级" name="state.squad.id" items=squads empty="..." value=state.squad! /]
          [@b.radios label="是否在校" name="state.inschool" value=state.inschool/]
          [@base.code type="student-statuses" label="学籍状态" name="state.status.id" empty="..." value=state.status! /]
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
          [@base.code type="divisions" cache="false" label="生源地" name="examinee.originDivision.id" empty="..." value=examinee.originDivision!/]
          [@base.code type="enroll-modes" label="入学方式" name="examinee.enrollMode.id" empty="..." value=examinee.enrollMode!/]
          [@base.code type="education-modes" label="培养方式" name="examinee.educationMode.id" empty="..." value=examinee.educationMode!/]
          [@b.textfield label="委培单位" name="examinee.client"   value=examinee.client!  style="width: 400px"/]
          [@b.textfield label="毕业学校名称" name="examinee.schoolName" value=(examinee.schoolName)! maxlength="100" style="width: 400px"/]
          [@b.date label="毕业日期" id="examinee.graduateOn" name="examinee.graduateOn" value=examinee.graduateOn!  /]
          [@b.textfield label="招生录取成绩" name="examinee.score" value=(examinee.score)! maxlength="100" /]
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
  //如果更改毕业日期，同步更改预计离校日期
  function syncGraduateOn() {
    var form = document.studentForm;
    var date = form['student.graduateOn'].value;
    if (date) {
      var maxEndOn = form['student.maxEndOn'].value;
      if(maxEndOn != form['student.endOn'].value){
        form['student.endOn'].value = date;
      }
    }
  }
  $(function() {
    jQuery('#phoneticName').after("<a href='javascript:void(0)' style='margin-left: 10px;' onclick='return auto_pinyin()'>获取拼音</a>");
    document.studentForm['student.graduateOn'].onchange=syncGraduateOn;
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

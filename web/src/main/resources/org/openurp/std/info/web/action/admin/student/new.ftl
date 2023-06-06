[#ftl]
[@b.head/]
<style>
  fieldset.listset li > label.title{
    min-width:8rem;
  }
</style>
  [@b.toolbar title="新增学生"]
    bar.addClose();
    [#if (Parameters["isOk"]!"x") == "true"]
    alert("保存成功！");
    window.close();
    [/#if]
  [/@]
  [@b.form name="studentAddForm" action="!saveAddInfo" theme="list"]
    [@b.textfield label="学号" name="student.code" value="" maxlength="30" required="true" style="width: 200px"/]
    [@b.textfield label="姓名" name="student.name" required="true" value="" maxlength="100" style="width: 200px"/]
    [@base.code type="genders" label="性别" name="person.gender.id" empty="..." required="true" /]
    [@b.datepicker label="出生年月" name="person.birthday"  required="true" format="yyyy-MM-dd" readonly="readonly" value="" style="width: 200px"/]
    [@base.code type="id-types" label="证件类型" name="person.idType.id" empty="..."  required="true"/]
    [@b.textfield label="证件号码" name="person.code" required="true" value="" maxlength="30" style="width: 200px"/]
    [#assign s = "state_"/]
    [@base.grade label="年级" name="state.grade.id"  required="true" /]
    [@b.textfield label="学制" name="student.duration" required="true" value="" style="width: 200px" check="greaterThan(0).match('number')" maxlength="5"/]
    [@base.campus label="校区" name="state.campus.id" empty="..." required="true" /]
    [@b.select label="院系" name="state.department.id" items=project.departments empty="..." required="true" value="" style="width: 200px"/]

    [@base.code type="education-types" label="培养类型" name="student.eduType.id" empty="..." required="true" /]
    [@b.select id=s + "level" label="培养层次" name="student.level.id" items=project.levels empty="..." required="true" value="" /]
    [@b.select id=s + "stdType" label="学生类别" name="student.stdType.id" items=project.stdTypes empty="..." required="true" value=""/]
    [@b.select id=s + "major" label="专业" name="state.major.id" href="${EMS.api}/base/edu/${project.id}/majors.json" empty="..." value=(state.major.id)! style="width: 200px"/]
    [@b.select id=s + "direction" label="方向" name="state.direction.id" items=directions empty="..." value=(state.direction.id)! style="width: 200px"/]
    [#if squadSupported]
    [@b.select label="行政班级" name="state.squad.id" items=[] empty="..." value="" style="width: 200px" comment="（填了年级、培养层次、学生类别、专业所在院系、专业后，才可选；若仍空，则表示无班级可填）"/]
    [/#if]
    [@b.startend label="最长学习年限" name="student.beginOn,student.endOn" required="true" required="true" style="width: 120px"/]
    [@b.startend label="入学-预毕业日期"  name="student.studyOn,student.graduateOn" required="true" value="" style="width: 120px"/]
    [@base.code type="student-statuses" label="学籍状态" name="state.status.id" empty="..."  required="true" /]
    [@base.code type="study-types" label="学习形式" name="student.studyType.id" required="true" empty="..."/]
    [@b.validity]
      $("[name='student.code']", document.studentAddForm).require().assert(function() {
        var stdCode = $("[name='person.code']").val();
        return !(null == stdCode || undefined == stdCode || stdCode.replace(/\s/gm, "").length == 0);
      }, "请先填写证件号码，谢谢！").assert(function() {
        var isOk = false;

        $.ajax({
          "type": "post",
          "url": "${b.url('!checkStudentCodeAjax')}",
          "dataType": "json",
          "data": {
            "code": $("[name='student.code']").val(),
            "personCode": $("[name='person.code']").val()
          },
          "async": false,
          "success": function(data) {
            isOk = data.isOk;
          }
        });

        return isOk;
      }, "学号已存在或异常！！！");
    [/@]
    [@b.formfoot]
      <input id="${s}project" type="hidden" name="student.project.id" value="${project.id}"/>
      <input type="hidden" name="person.id" value=""/>
      [@b.submit value="保存"/]
    [/@]
  [/@]
  <script>
    $(document).ready(function() {
      var formObj = $("form#studentAddForm");
      [#if squadSupported]
      formObj.find("select[name='state.squad.id']").focus(function() {
        var currVal = $(this).val();

        this.length = 1;
        var grade = formObj.find("[name='state.grade']").val();
        var levelId = formObj.find("[name='student.level.id']").val();
        var stdTypeId = formObj.find("[name='student.stdType.id']").val();
        var departmentId = formObj.find("[name='state.department.id']").val();
        var majorId = formObj.find("[name='state.major.id']").val();
        var directionId = formObj.find("[name='state.direction.id']").val();

        if (grade==""  || levelId=="" || stdTypeId=="" || departmentId=="" || majorId=="" ) {
          return false;
        }

        var currObj = $(this);

        var params = new FormData();
        params.append("squad.grade", grade);
        params.append("squad.level.id", levelId);
        params.append("squad.stdType.id",stdTypeId);
        params.append("squad.department.id", departmentId);
        params.append("squad.major.id", majorId);
        params.append("squad.direction.id", directionId);
        params.append("isEdit", "1");
        fetch("${EMS.api}/base/std/${project.id}/squads.json",{method:"POST",body:params})
          .then(res => res.json())
          .then(obj =>{
            var datas = obj.datas;
            for (var i = 0; i < datas.length; i++) {
              var optionObj = $("<option>");
              optionObj.val(datas[i].id);
              optionObj.text(datas[i]['attributes'].name + "(" + datas[i]['attributes'].code + ")");
              if (currVal && datas[i].id == currVal) {
                optionObj.attr("selected", true);
              }
              currObj.append(optionObj);
            }
           }
        );
      });
     [/#if]
      formObj.find("[name='person.code']").change(function() {
        formObj.find("[name^='person']").each(function() {
          if ("person.code" != this.name) {
            this.disabled = false;
          }
        });

        var code = $(this).val();
        if (code) {
          $.ajax({
            "type": "post",
            "url": "${b.url('!loadPersonAjax')}",
            "dataType": "json",
            "async": false,
            "data": {
              "code": code
            },
            "success": function(data) {
              if(data.person){
                alert(data.person)
                putValueInFormItem("person.id", data.person.id);
                putValueInFormItem("student.name", data.person.formatedName);
                putValueInFormItem("person.gender.id", data.person.gender.id);
                putValueInFormItem("person.birthday", data.person.birthday);
                putValueInFormItem("person.idType.id", data.person.idType.id);
                //putValueInFormItem("person.country.id", data.person.country.id);
                //putValueInFormItem("person.nation.id", data.person.nation.id);
                //putValueInFormItem("person.homeTown", data.person.homeTown);
              }
            }
          });
        }
      });

      function putValueInFormItem(itemName, value) {
        if (value) {
          var itemObj = formObj.find("[name='" + itemName + "']");
          itemObj.val(value);
          var itemType = itemObj.attr("type");
          if (itemType || "text" == itemType) {
            itemObj[0].disabled = true;
          }
        }
      }
    });
  </script>
[@b.foot/]

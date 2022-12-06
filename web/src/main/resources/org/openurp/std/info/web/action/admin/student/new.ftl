[#ftl]
[@b.head/]
  [@b.toolbar title="新增学生"]
    bar.addClose();
    [#if (Parameters["isOk"]!"x") == "true"]
    alert("保存成功！");
    window.close();
    [/#if]
  [/@]
  [@b.form name="studentAddForm" action="!saveAddInfo" target="_self" theme="list"]
    [@b.textfield label="学号" name="student.code" value="" maxlength="30" required="true" style="width: 200px"/]
    [@b.textfield label="姓名" name="student.name" required="true" value="" maxlength="100" style="width: 200px"/]
    [@b.textfield label="英文名" name="student.person.phoneticName" value="" maxlength="100" style="width: 200px"/]
    [@b.textfield label="曾用名" name="student.person.formerName" value="" maxlength="100" style="width: 200px"/]
    [@b.select label="性别" name="student.person.gender.id" items=genders  required="true" value="" style="width: 200px"/]
    [@b.datepicker label="出生年月" name="student.person.birthday"  required="true" format="yyyy-MM-dd" readonly="readonly" value="" style="width: 200px"/]
    [@b.select label="证件类型" name="student.person.idType.id" items=idTypes   required="true" value="" style="width: 200px"/]
    [@b.textfield label="证件号码" name="student.person.code" required="true" value="" maxlength="30" style="width: 200px" comment="（优先输入此项；若系统存在，则必需用系统中的数据）"/]
    [@b.select label="国家地区" name="student.person.country.id"  required="true" items=countries  value="" style="width: 200px"/]
    [@b.select label="民族" name="student.person.nation.id" required="true" items=nations   value="" style="width: 200px"/]
    [@b.select label="政治面貌" name="student.person.politicalStatus.id" items=politicalStatuses empty="..." value="" style="width: 200px"/]
    [@b.textfield label="籍贯" name="student.person.homeTown" value="" maxlength="100" style="width: 200px"/]
    [#assign s = "state_"/]
    [@b.textfield label="年级" name="student.state.grade" value="" maxlength="7" required="true" style="width: 200px"/]
    [@b.textfield label="学制" name="student.duration" required="true" value="" style="width: 200px" check="greaterThan(0).match('number')" maxlength="5"/]
    [@b.select label="校区" name="student.state.campus.id" items=campuses required="true" value="" style="width: 200px"/]
    [@b.select label="院系" name="student.state.department.id" items=project.departments empty="..." required="true" value="" style="width: 200px"/]

    [@b.select id=s + "level" label="培养层次" name="student.level.id" items=project.levels empty="..." required="true" value="" /]
    [@b.select label="培养类型" name="student.eduType.id" items=eduTypes empty="..." required="true" value=""/]
    [@b.select id=s + "stdType" label="学生类别" name="student.stdType.id" items=project.stdTypes empty="..." required="true" value=""/]
    [@b.select id=s + "major" label="专业" name="student.state.major.id" href="${ems.api}/base/edu/${project.id}/majors.json" empty="..." value=(state.major.id)! style="width: 200px"/]
    [@b.select id=s + "direction" label="方向" name="student.state.direction.id" items=directions empty="..." value=(state.direction.id)! style="width: 200px"/]
    [#if squadSupported]
    [@b.select label="行政班级" name="student.state.squad.id" items=[] empty="..." value="" style="width: 200px" comment="（填了年级、培养层次、学生类别、专业所在院系、专业后，才可选；若仍空，则表示无班级可填）"/]
    [/#if]
    [@b.radios label="是否有学籍" name="student.registed" required="true" value=true/]
    [@b.radios label="是否在校" name="student.state.inschool" value=true/]
    [@b.startend label="入学-预毕业日期"  name="student.studyOn,student.graduateOn" required="true" value="" style="width: 120px"/]
    [@b.startend label="学籍生效日期" name="student.beginOn,student.endOn" required="true" required="true" style="width: 120px"/]
    [@b.select label="学籍状态" name="student.state.status.id" items=statuses  required="true" value="" style="width: 200px"/]
    [@b.select label="学习形式" name="student.studyType.id"  required="true" items=studyTypes  value="" style="width: 200px"/]
    [@b.select label="导师" name="student.tutor.id" items=tutors empty="..." value="" style="width: 200px"/]
    [@b.textarea label="备注" name="student.state.remark" value="" style="width: 200px; height: 50px" maxlength="100" comments="限长100个字符"/]
    [@b.validity]
      $("[name='student.code']", document.studentAddForm).require().assert(function() {
        var stdCode = $("[name='student.person.code']").val();
        return !(null == stdCode || undefined == stdCode || stdCode.replace(/\s/gm, "").length == 0);
      }, "请先填写证件号码，谢谢！").assert(function() {
        var isOk = false;

        $.ajax({
          "type": "post",
          "url": "${b.base}/student!checkStudentCodeAjax",
          "dataType": "json",
          "data": {
            "code": $("[name='student.code']").val(),
            "personCode": $("[name='student.person.code']").val()
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
      <input type="hidden" name="student.person.id" value=""/>
      <input type="hidden" name="student.state.beginOn" value=""/>
      <input type="hidden" name="student.state.endOn" value=""/>
      [@b.submit value="保存"/]
    [/@]
  [/@]
  <script>
    $(document).ready(function() {
      var formObj = $("form#studentAddForm");
      formObj.find(":text[name='student.beginOn']").blur(function() {
        this.form["student.state.beginOn"].value = this.value;
      });
      $(":text[name='student.endOn']").blur(function() {
        this.form["student.state.endOn"].value = this.value;
      });

      [#if squadSupported]
      formObj.find("select[name='student.state.squad.id']").focus(function() {
        var currVal = $(this).val();

        this.length = 1;
        var grade = formObj.find("[name='student.state.grade']").val();
        var levelId = formObj.find("[name='student.level.id']").val();
        var stdTypeId = formObj.find("[name='student.stdType.id']").val();
        var departmentId = formObj.find("[name='student.state.department.id']").val();
        var majorId = formObj.find("[name='student.state.major.id']").val();
        var directionId = formObj.find("[name='student.state.direction.id']").val();

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
        fetch("${ems.api}/base/std/${project.id}/squads.json",{method:"POST",body:params})
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
      formObj.find("[name='student.person.code']").change(function() {
        formObj.find("[name^='student.person']").each(function() {
          if ("student.person.code" != this.name) {
            this.disabled = false;
            this.value = "";
          }
        });

        var code = $(this).val();
        if (!isBlank(code)) {
          $.ajax({
            "type": "post",
            "url": "${b.base}/student!loadPersonAjax",
            "dataType": "json",
            "async": false,
            "data": {
              "code": code
            },
            "success": function(data) {
              putValueInFormItem("student.person.id", data.person.id);
              putValueInFormItem("student.name", data.user.name);
              putValueInFormItem("student.person.phoneticName", data.person.phoneticName);
              putValueInFormItem("student.person.formerName", data.person.formerName);
              putValueInFormItem("student.person.gender.id", data.person.gender.id);
              putValueInFormItem("student.person.birthday", data.person.birthday);
              putValueInFormItem("student.person.idType.id", data.person.idType.id);
              putValueInFormItem("student.person.country.id", data.person.country.id);
              putValueInFormItem("student.person.nation.id", data.person.nation.id);
              putValueInFormItem("student.person.homeTown", data.person.homeTown);
            }
          });
        }
      });

      function putValueInFormItem(itemName, value) {
        if (!isBlank(value)) {
          var itemObj = formObj.find("[name='" + itemName + "']");
          itemObj.val(value);
          var itemType = itemObj.attr("type");
          if (isBlank(itemType) || "text" == itemType) {
            itemObj[0].disabled = true;
          }
        }
      }
    });
  </script>
[@b.foot/]

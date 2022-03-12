[#ftl]
[#assign isEdit = "1" == Parameters["isEdit"]!/]
[@b.form action="!studentStateSave" name="studentStateForm" target="_self" theme="list"]
  <input type="hidden" name="student.id" value="${student.id}"/>
  <input type="hidden" name="state.id" value="${(state.id)!}"/>
  [#list Parameters?keys as key]
    [#if key?starts_with("state") && !key?starts_with("state.") || key?starts_with("label")]
  <input type="hidden" name="${key}" value="${(Parameters[key]?html)!}"/>
    [/#if]
  [/#list]
  [@b.field label="学号"]${student.user.code}[/@]
  [#assign disallowCount = -1/]
  [@b.textfield label="年级" name="state.grade" value=(state.grade)! maxlength="7" required="true" style="width: 200px"/]
  [#assign s = "state_"/]
  [@b.select label="院系" id=s + "department"  name="state.department.id" items=departments empty="..." required="true" value=(state.department.id)! style="width: 200px"/]

  <input id="${s}project" type="hidden" value="${student.project.id}"/>
  <input id="${s}level" type="hidden" value="${student.level.id}"/>
  <input id="${s}stdType" type="hidden" value="${student.stdType.id}"/>
  [@b.select id=s + "major" label="专业" name="state.major.id" items=[] empty="..." value=(state.major.id)! style="width: 200px"/]
  [@b.select id=s + "direction" label="方向" name="state.direction.id" items=[] empty="..." value=(state.direction.id)! style="width: 200px"/]
  [@b.select label="校区" name="state.campus.id" items=campuses empty="..." required="true" value=(state.campus.id)! style="width: 200px"/]
  [@b.select label="行政班级" name="state.squad.id" items=[] empty="..." value=(state.squad.id)! style="width: 200px" comment="（填了年级、专业所在院系、专业后，才可选；若仍空，则表示无班级可填）"/]
  [#switch disallowCount]
    [#case 3]
      <input id="${s}direction" type="hidden" name="state.direction.id" value="${(state.direction.id)!}"/>
    [#case 2]
      <input id="${s}major" type="hidden" name="state.major.id" value="${state.major.id}"/>
    [#case 1]
      <input id="${s}department" type="hidden" name="state.department.id" value="${state.department.id}"/>
      [#break/]
    [#case 0]
      <input type="hidden" name="state.grade" value="${state.grade}"/>
  [/#switch]
    [@b.radios label="是否在校" name="state.inschool" value=(state.inschool?string(1, 0))!/]
    [@b.select label="学籍状态" name="state.status.id" items=statuses empty="..." value=(state.status.id)! style="width: 200px"/]
    [@b.datepicker id="state_beginOn" label="起始日期" name="state.beginOn" maxDate="#F{$dp.$D(\\'state_endOn\\')}" format="yyyy-MM-dd" readonly="readonly" required="true" value=((state.beginOn)?string("yyyy-MM-dd"))! style="width: 200px"/]
    [@b.datepicker id="state_endOn" label="结束日期" name="state.endOn" minDate="#F{$dp.$D(\\'state_beginOn\\')}" format="yyyy-MM-dd" readonly="readonly" value=(state.endOn?string("yyyy-MM-dd"))! style="width: 200px"/]
    [@b.validity]
      $(":text[name='state.beginOn']", document.studentStateForm).require().assert(function(element) {
        [#-- 如果确定要直接关闭，则不需要验证了 --]
        var isCloseObj = $("form[name=studentStateForm]").find(":hidden[name=isClose]");
        if (isCloseObj.length == 0 || isCloseObj.val()!="") {
          return true;
        }

        var formObj = $("form[name=studentStateForm]");

        var stateDataMap = {};
        stateDataMap["student.id"] = formObj.find(":hidden[name='student.id']").val();
        stateDataMap["id"] = formObj.find(":hidden[name='state.id']").val();
        stateDataMap["beginOn"] = formObj.find(":text[name='state.beginOn']").val();
        stateDataMap["endOn"] = formObj.find(":text[name='state.endOn']").val();

        for (var i = 0; i > -1; i++) {
          var iStateId = formObj.find(":hidden[name='state" + i + ".id']").val();
          var iStateGrade = formObj.find(":hidden[name='state" + i + ".grade']").val();
          if (iStateId=="" && iStateGrade=="") {
            break;
          }
          stateDataMap["state" + i + ".id"] = iStateId;
          stateDataMap["state" + i + ".grade"] = iStateGrade;
          stateDataMap["state" + i + ".beginOn"] = formObj.find(":hidden[name='state" + i + ".beginOn']").val();
          stateDataMap["state" + i + ".endOn"] = formObj.find(":hidden[name='state" + i + ".endOn']").val();
        }

        $.ajax({
          "type": "post",
          "url": "${base}/student!stateDateCheckAjax",
          "dataType": "json",
          "data": stateDataMap,
          "async": false,
          "success": function(data) {
            isOk = data.isOk;
          },
          "error": function(rs) {
            isOk = false;
          }
        });
        return isOk;
      }, "所设起始日期和结束日期与其它的学籍状态记录日期冲突或不连续");
    [/@]
    [@b.textarea label="备注" name="state.remark" value=(state.remark?html)! style="width: 200px; height: 50px" maxlength="100" comments="限长100个字符"/]
  [@b.field label="温馨提示"]<span style="color: blue">点击“修改”只是暂存于页面上，没有点击最终的“保存”将会丢失数据。而点击“关闭”，本次新增或维护的数据将丢失，回到上次保存的数据。</span>[/@]
  [@b.formfoot]
    [@b.submit value=(!isEdit)?string("添加", "修改")/]
    <input type="hidden" name="isClose" value=""/>
    <button id="btnStateClose" class="btn btn-outline-primary btn-sm">关闭</button>
  [/@]
  [#if disallowCount lt 3]
<script src='${base}/dwr/engine.js'></script>
<script src='${base}/static/scripts/dwr/util.js'></script>
  <script src="${base}/dwr/interface/projectMajorDwr.js"></script>
  <script src="${base}/static/scripts/common/majorSelect.js?v=201811"></script>
  <script>
    new Major3Select("${s}project", "${s}level", "${s}stdType", "${s}department", "${s}major", "${s}direction", true, true, true, true).init([ { "id": "${student.project.id}", "name": "" }, "${request.getServletPath()}" ]);
  </script>
  [/#if]
  <script>
    $(function() {
      var formObj = $("form[name=studentStateForm]");

      [#if disallowCount lt 4]
      $(document).ready(function() {
        formObj.find("[name='state.department.id']").change();
        formObj.find("[name='state.squad.id']").click();
      });

      formObj.find("select[name='state.squad.id']").focus(function() {
        $(this).click();
      }).click(function() {
        var currVal = $(this).val();

        this.length = 1;

        var grade = formObj.find("[name='state.grade']").val();
        var projectId = formObj.find(":hidden#${s}project").val();
        var levelId = formObj.find(":hidden#${s}level").val();
        var stdTypeId = formObj.find(":hidden#${s}stdType").val();
        var departmentId = formObj.find("[name='state.department.id']").val();
        var majorId = formObj.find("[name='state.major.id']").val();
        var directionId = formObj.find("[name='state.direction.id']").val();
        var campusId = formObj.find("[name='state.campus.id']").val();

        if (grade=="" || projectId=="" || levelId=="" || stdTypeId=="" || departmentId=="" || majorId=="" ) {
          return false;
        }

        var currObj = $(this);

        $.ajax({
          "type": "post",
          "url": "${base}/student!loadSquadAjax",
          "dataType": "json",
          "data": {
            "grade": grade,
            "projectId": projectId,
            "levelId": levelId,
            "stdTypeId": stdTypeId,
            "departmentId": departmentId,
            "majorId": majorId,
            "directionId": directionId,
            "campusId": campusId,
            "isEdit": "1"
          },
          "async": false,
          "success": function(data) {
            for (var i = 0; i < data.squades.length; i++) {
              var optionObj = $("<option>");
              optionObj.val(data.squades[i].id);
              optionObj.text(data.squades[i].name);
              if (currVal!="" && data.squades[i].id == currVal) {
                optionObj.attr("selected", true);
              }
              currObj.append(optionObj);
            }
          }
        });
      });
      [/#if]

      var spanObj = $("<span>");
      spanObj.css("padding-right", "5px");
      spanObj.insertAfter(formObj.find(":text[name='state.endOn']"));

      var btnCleanEndOnObj = $("<button>");
      btnCleanEndOnObj.attr("type", "button");
      btnCleanEndOnObj.text("清空日期");
      btnCleanEndOnObj.click(function() {
        $(this).parent().children().eq(1).val("");
      });
      btnCleanEndOnObj.insertAfter(formObj.find(":text[name='state.endOn']").next());

      formObj.find("button#btnStateClose").click(function() {
        if (confirm("确定要关闭当前对话框吗？\n如果当前是新增未保存入库的数据，关闭后将会丢失，要继续吗？")) {
          formObj.find(":hidden[name=isClose]").val(1);
          var idObj = formObj.find(":hidden[name='state.id']");
          if ("" == idObj.val() && ${(!isEdit)?string}) {
            $.colorbox.close();
          } else {
            formObj.submit();
          }
        }
      });
    });
  </script>
[/@]
[@b.foot/]

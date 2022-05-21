[#ftl]
[@b.head]
<link rel="stylesheet" type="text/css" href="${base}/static/scripts/commons/css/common.css">
<script src="${base}/static/scripts/common.js?v=2"></script>
<script>beangle.load(["jquery-colorbox"])</script>
[/@]

[@b.toolbar title='个人基本信息维护']
     bar.addBackOrClose();
[/@]
[@b.messages slash = "7"/]

[#if !((student.person.id)??)]
<div style="color: red">当前学生基本信息还未配置！</div>
[/#if]

  [@b.form name="studentForm" action="!saveStudent" theme="list" target="_self"]
    <input type="hidden" name="student.id" value="${(student.id)!}"/>
    <input type="hidden" name="student.person.id" value="${(student.person.id)!}"/>

    [@b.textfield label="姓名" name="student.user.name" required="true" value=(student.user.name)! maxlength="100" style="width: 200px"/]
    [@b.textfield label="英文名" name="student.person.phoneticName" value=(student.person.phoneticName)! maxlength="100" style="width: 200px"/]
    [@b.textfield label="曾用名" name="student.person.formerName" value=(student.person.formerName)! maxlength="100" style="width: 200px"/]
    [@b.select label="性别" name="student.person.gender.id" items=genders empty="..." required="true" value=(student.person.gender.id)! style="width: 200px"/]
    [@b.datepicker label="出生年月" name="student.person.birthday" format="yyyy-MM-dd" readonly="readonly" value=((student.person.birthday)?string("yyyy-MM-dd"))! style="width: 200px"/]
    [@b.select label="证件类型" name="student.person.idType.id" items=idTypes empty="..." value=(student.person.idType.id)! style="width: 200px"/]
    [@b.textfield label="证件号码" name="student.person.code" required="true" value=(student.person.code)! maxlength="32" style="width: 200px"/]
    [@b.select label="国家地区" name="student.person.country.id" items=countries empty="..." value=(student.person.country.id)! style="width: 200px"/]
    [@b.select label="民族" name="student.person.nation.id" items=nations empty="..." value=(student.person.nation.id)! style="width: 200px"/]
    [@b.select label="政治面貌" name="student.person.politicalStatus.id" items=politicalStatuses empty="..." value=(student.person.politicalStatus.id)! style="width: 200px"/]
    [@b.textfield label="籍贯" name="student.person.homeTown" value=(student.person.homeTown)! maxlength="100" style="width: 200px"/]

    [@b.field label="学号"]${student.user.code}[/@]
    [@b.select label="培养层次" name="student.level.id" items=levels empty="..." required="true" value=student.level.id style="width: 200px"/]
    [@b.select label="学生类别" name="student.stdType.id" items=stdTypes empty="..." required="true" value=student.stdType.id style="width: 200px"/]
    [@b.textfield label="学制" name="student.duration" required="true" value=student.duration style="width: 200px" check="greaterThan(0).match('number')" maxlength="5"/]
    [@b.radios label="是否有学籍" name="student.registed" required="true" value=student.registed?string(1, 0)/]
    [@b.startend label="学籍生效日期" name="student.beginOn,student.endOn" required="true" start=student.beginOn end=student.endOn style="width: 120px"/]
    [@b.startend label="入学-毕业日期" name="student.studyOn,student.graduateOn" required="true" start=student.studyOn end=student.graduateOn style="width: 120px" /]
    [@b.select label="学习形式" name="student.studyType.id" required="true" items=studyTypes empty="..." value=(student.studyType.id)! style="width: 200px"/]
    [@b.select label="导师" name="student.tutor.id" items=tutors empty="..." value=(student.tutor.id)! style="width: 200px"/]
    [@b.field label="学籍状态" required="true"]
        <table width="80%" cellpadding="0" cellspacing="0">
          <tr>
            <td><button id="btnAddState" type="button">添加</button><input id="stateRow111111" type="text" name="stateRow" value="" style="display: none"/></td>
          </tr>
          <tr>
            <td style="padding-top: 3px; padding-bottom: 3px"><span style="color: blue">注意：<span style="color: red">红色</span>为当前学籍状态，取起始日期最近的记录，<span style="color: black">黑色</span>为历史学籍状态，<span style="color: Gold">黄色</span>为将来学籍状态。若界面上的学籍状态记录未保存，则将丢失或回到上次保存的结果。</span></td>
          </tr>
          <tr>
            <td>
              [#if student.states?size gt 0]
              <table class="gridtable">
                <thead class="gridhead">
                  <th>列表</th>
                  <th width="6%">操作</th>
                </thead>
                <tbody>
                  [#assign isRed = false/]
                  [#list student.states?sort_by("beginOn")?reverse as hisState]
                  <tr valign="top">
                    <td>
                      [#assign isNearNow = ((hisState.id!0)==student.state.id)/]
                      <table class="${(!isRed && isNearNow)?string("red", (hisState.beginOn?string("yyyyMMdd")?number gt now)?string("yellow", "gray"))} infoTable" style="border-width: 0px">
                      [#if !isRed && isNearNow][#assign isRed = true/][/#if]
                        <tr>
                          <td class="title" width="8%">年级</td>
                          <td width="10%">${hisState.grade}</td>
                          <td class="title" width="8%">院系</td>
                          <td>${(hisState.department.name)!}</td>
                          <td class="title" width="8%">专业</td>
                          <td>${(hisState.major.name)!}  ${(hisState.direction.name)!}</td>
                          <td class="title" width="8%">班级</td>
                          <td>${(hisState.squad.shortName)?default((hisState.squad.name)!)}</td>
                        </tr>
                        <tr>
                          <td class="title">校区</td>
                          <td>${(hisState.campus.name)!}</td>
                          <td class="title">状态</td>
                          <td>${hisState.status.name} ${hisState.inschool?string("在校", "不在校")}</td>
                          <td class="title">起始~结束</td>
                          <td>${hisState.beginOn?string("yyyy-MM-dd")}~${(hisState.endOn?string("yyyy-MM-dd"))!}</td>
                          <td class="title">备注</td>
                          <td>${(hisState.remark?html?replace("\n", "<br>"))!}</td>
                        </tr>
                        <tr>
                        </tr>
                      </table>
                    </td>
                    <td>
                      <button id="btnStateEdit" type="button">修改</button>
                      <br>
                      <button id="btnStateRemove" type="button">删除</button>
                      <input type="hidden" name="state${hisState_index}.id" value="${(hisState.id)!}"/>
                      <input type="hidden" name="state${hisState_index}.grade" value="${hisState.grade}"/>
                      <input type="hidden" name="state${hisState_index}.department.id" value="${hisState.department.id}"/>
                      [#-- 用于数据入数据库中导入的，而模型中是NotNull，故报错了；现在暂做屏蔽之 --]
                      <input type="hidden" name="state${hisState_index}.major.id" value="${(hisState.major.id)!}"/>
                      <input type="hidden" name="state${hisState_index}.direction.id" value="${(hisState.direction.id)!}"/>
                      <input type="hidden" name="state${hisState_index}.inschool" value="${hisState.inschool?string(1, 0)}"/>
                      <input type="hidden" name="state${hisState_index}.status.id" value="${(hisState.status.id)!}"/>
                      <input type="hidden" name="state${hisState_index}.squad.id" value="${(hisState.squad.id)!}"/>
                      <input type="hidden" name="state${hisState_index}.campus.id" value="${(hisState.campus.id)!}"/>
                      <input type="hidden" name="state${hisState_index}.beginOn" value="${hisState.beginOn?string("yyyy-MM-dd")}"/>
                      <input type="hidden" name="state${hisState_index}.endOn" value="${(hisState.endOn?string("yyyy-MM-dd"))!}"/>
                      <input type="hidden" name="state${hisState_index}.remark" value="${(hisState.remark?html)!}"/>
                    </td>
                  </tr>
                  [/#list]
                </tbody>
              </table>
              [/#if]
            </td>
          </tr>
        </table>

    [/@]
      [@b.validity]
        $(":hidden[name=stateRow]", document.studentForm).assert(function(element) {
          return 1 <= $(":hidden[name=stateRow]").parent().parent().next().next().children().children().children().last().children().length;
        }, "本学籍必须至少有一条学籍状态记录");
      [/@]
    [#-- 学生分类标签 --]
    [@b.field label="分类标签"]
        <table width="80%" cellpadding="0" cellspacing="0">
          <tr>
            <td><button id="btnAddLabel" type="button">添加</button></td>
          </tr>
          <tr>
            <td height="5px"></td>
          </tr>
          <tr>
            <td>
              [#if 0 != student.labels?values?size]
              <table class="blue infoTable">
                [#list student.labels?values?sort_by([ "labelType", "name" ]) as label]
                <tr>
                  <td class="title" style="width: 20%">${label.labelType.name}：</td>
                  <td>${label.name}<span role="stdLabel" title="删除分类标签" style="padding-left: 5px; color: red; cursor: pointer">╳</span><input type="hidden" name="label${label_index}.id" value="${label.id}"/></td>
                </tr>
                [/#list]
              </table>
              [/#if]
            </td>
          </tr>
        </table>
    [/@]
      [@b.textarea label="备注" name="student.remark" value=(student.remark?html)! style="width: 200px; height: 50px" check="maxLength(100)" comments="（限长100个字符）"/]

    [@b.formfoot]
      [@b.submit value="保存"/]
    [/@]
  [/@]

  <script>
    $(function() {
      var formObj = $("form[name=studentForm]");

      function loadMethod() {
        [#-- 添加 --]
        formObj.find("button#btnAddState").click(function() {
          var paramDataMap = {};
          paramDataMap["student.id"] = "${student.id}";

          formObj.find(":hidden[name^=state]").each(function() {
            paramDataMap[$(this).attr("name")] = $(this).val();
          });

          formObj.find(":hidden[name^=label]").each(function() {
            paramDataMap[$(this).attr("name")] = $(this).val();
          });

          $(this).colorbox({
            "transition": "none",
            "title": "添加学籍状态记录",
            "overlayClose": false,
            "speed": 0,
            "width": "800px",
            "height": "600px",
            "href": "${base}/student!studentStateEdit",
            "data": paramDataMap,
            "closeButton": false
          });
        });

        [#-- 修改 --]
        formObj.find("button#btnStateEdit").click(function() {
          var paramDataMap = {};
          paramDataMap["student.id"] = "${student.id}";
          paramDataMap["isEdit"] = 1;

          [#-- 先提取当前的要“修改”的数据 --]
          var currIndex = $(this).parent().find(":hidden[name^=state]").first().attr("name").split(".")[0].replace("state", "");
          var stateObjs = $(this).parent().parent().parent().find(":hidden[name^=state]");
          var cacheMap = {};
          var i = 0;
          stateObjs.each(function() {
            var elementName = $(this).attr("name");
            var eNameSections = elementName.split(".");

            var index = eNameSections[0].replace("state", "");

            eNameSections[0] = "state";
            if (index != currIndex) {
              var k = cacheMap[index];
              if (isBlank(k)) {
                k = cacheMap[index] = i++;
              }
              eNameSections[0] += k;
            }
            paramDataMap[eNameSections.join(".")] = $(this).val();
          });

          stateObjs.remove();

          [#-- 再把其它的记录数据也带上 --]
          $(this).parent().parent().parent().find(":hidden[name^=state]").each(function() {
            paramDataMap[$(this).attr("name")] = $(this).val();
          });

          formObj.find(":hidden[name^=label]").each(function() {
            paramDataMap[$(this).attr("name")] = $(this).val();
          });

          $(this).parent().parent().remove();

          $(this).colorbox({
            "transition": "none",
            "title": "修改学籍状态记录",
            "overlayClose": false,
            "speed": 0,
            "width": "800px",
            "height": "600px",
            "href": "${base}/student!studentStateEdit",
            "data": paramDataMap,
            "closeButton": false
          });
        });

        [#-- 删除学籍状态记录 --]
        formObj.find("button#btnStateRemove").click(function() {
          if (1 == $(this).parent().parent().parent().children().length) {
            alert("本学生学籍状态记录必须至少有一条！\n故本条不能删除！\n\n提示：可以再添加一条学籍状态记录，再删除本条，谢谢配合！");
            return false;
          }

          if (confirm("确定要删除当第 " + ($(this).parent().parent().index() + 1) + " 行学籍状态记录吗？\n如果删除后，又点击了“保存”，则该学籍状态就完全被删除了。\n要删除吗？")) {
            var stateFormObj = $("<form>");
            stateFormObj.attr("action", "${base}/student!studentStateSave");
            stateFormObj.attr("target", "_self");

            $(this).parent().find(":hidden").remove();
            var index = 0;
            $(this).parent().parent().parent().children().each(function() {
              var stateObjs = $(this).find(":hidden[name^=state]");
              stateObjs.each(function() {
                var name = $(this).attr("name");
                var nameSections = name.split(".");
                nameSections[0] = "state" + index;
                $(this).attr("name", nameSections.join("."));
                $(this).appendTo(stateFormObj);
              });
              if (stateObjs.length > 0) {
                index++;
              }
            });
            formObj.find(":hidden[name^=label]").appendTo(stateFormObj);
            stateFormObj.append(formObj.find(":hidden[name='student.id']"));
            var isRemoveObj = $("<input>");
            isRemoveObj.attr("type", "hidden");
            isRemoveObj.attr("name", "isRemove");
            isRemoveObj.val(1);
            stateFormObj.append(isRemoveObj);
            stateFormObj.appendTo($("body"));
            stateFormObj.submit();
          }
        });

        [#-- 学生分类标签 --]
        [#-- 添加 --]
        formObj.find("button#btnAddLabel").click(function() {
          var paramDataMap = {};
          paramDataMap["student.id"] = "${student.id}";

          formObj.find(":hidden[name^=state]").each(function() {
            paramDataMap[$(this).attr("name")] = $(this).val();
          });

          formObj.find(":hidden[name^=label]").each(function() {
            paramDataMap[$(this).attr("name")] = $(this).val();
          });

          $(this).colorbox({
            "transition": "none",
            "title": "添加学生分类标签",
            "overlayClose": false,
            "speed": 0,
            "width": "800px",
            "height": "600px",
            "href": "${base}/student!labelEdit",
            "data": paramDataMap,
            "closeButton": false
          });
        });

        [#-- 删除 --]
        formObj.find("span[role=stdLabel]").click(function() {
          if (confirm("确定要删除第 " + ($(this).parent().parent().index() + 1) + " 行学生分类标签吗？")) {
            $(this).next().remove();

            [#-- 注意：不能直接删除TR，否则将影响“添加”的选择列表 --]
            var lFormObj = $("<form>");
            lFormObj.attr("action", "${base}/student!labelSave");
            lFormObj.attr("target", "_self");

            $(this).parent().find(":hidden").remove();
            formObj.find(":hidden[name^=state]").appendTo(lFormObj);
            $(this).parent().parent().parent().children()
            var index = 0;
            $(this).parent().parent().parent().find(":hidden[name^=label]").each(function() {
              $(this).attr("name", "label" + index++ + ".id")
              $(this).appendTo(lFormObj);
            });
            lFormObj.append(formObj.find(":hidden[name='student.id']"));
            lFormObj.appendTo($("body"));
            lFormObj.submit();
          }
        });
      }

      $(document).ready(function() {
        loadMethod();
      });
    });
  </script>

[@b.foot/]

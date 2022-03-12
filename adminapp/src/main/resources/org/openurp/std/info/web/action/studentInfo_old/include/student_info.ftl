[#ftl]
[#assign stdRestricts = (propertyMetaMap[studentMeta])?if_exists/]
[#assign stateRestricts = (propertyMetaMap[stateMeta])?if_exists/]
[#if stdRestricts?size gt 0 || stateRestricts?size gt 0]
  [@b.form action="!saveStudent" name="studentForm" target="_self" theme="list"]
    <input type="hidden" name="student.id" value="${student.id}"/>
    [@b.field label="学号"]${student.user.code}[/@]
    [#if stdRestricts?seq_contains("level")]
      [@b.select label="培养层次" name="student.level.id" items=levels empty="..." required="true" value=student.level.id style="width: 200px"/]
    [#else]
      [@b.field label="培养层次"][@i18nName student.level/][/@]
    [/#if]
    [#if stdRestricts?seq_contains("stdType")]
      [@b.select label="学生类别" name="student.stdType.id" items=stdTypes empty="..." required="true" value=student.stdType.id style="width: 200px"/]
    [#else]
      [@b.field label="学生类别"][@i18nName student.stdType/][/@]
    [/#if]
    [#if stdRestricts?seq_contains("duration")]
      [@b.textfield label="学制" name="student.duration" required="true" value=student.duration style="width: 200px" check="greaterThan(0).match('number')" maxlength="5"/]
    [#else]
      [@b.field label="学制"]${student.duration}[/@]
    [/#if]
    [#if stdRestricts?seq_contains("registed")]
      [@b.radios label="是否有学籍" name="student.registed" required="true" value=student.registed?string(1, 0)/]
    [#else]
      [@b.field label="是否有学籍"]${student.registed?string("是", "否")}[/@]
    [/#if]
    [#if stdRestricts?seq_contains("beginOn") && stdRestricts?seq_contains("endOn")]
      [@b.startend label="学籍生效日期" name="student.beginOn,student.endOn" required="true" start=student.beginOn end=student.endOn style="width: 120px"/]
    [#else]
      [@b.field label="学籍生效日期"]${student.beginOn?string("yyyy-MM-dd")}~${student.endOn?string("yyyy-MM-dd")}[/@]
    [/#if]
    [#if stdRestricts?seq_contains("studyOn") && stdRestricts?seq_contains("graduateOn")]
      [@b.startend label="入学-毕业日期" name="student.studyOn,student.graduateOn" required="true" start=student.studyOn end=student.graduateOn style="width: 120px" /]
    [#else]
      [@b.field label="入学-毕业日期"]${student.studyOn?string("yyyy-MM-dd")}~${student.graduateOn?string("yyyy-MM-dd")}[/@]
    [/#if]
    [#if stdRestricts?seq_contains("stdType")]
      [@b.select label="学习形式" name="student.studyType.id" required="true" items=studyTypes empty="..." value=(student.studyType.id)! style="width: 200px"/]
    [#else]
      [@b.field label="学习形式"][@i18nName (student.stdType)!/][/@]
    [/#if]
    [#if stdRestricts?seq_contains("tutor")]
      [@b.select label="导师" name="student.tutor.id" items=tutors empty="..." value=(student.tutor.id)! style="width: 200px"/]
    [#else]
      [@b.field label="导师"][@i18nName (student.tutor)!/][/@]
    [/#if]
    [@b.field label="学籍状态" required="true"]
      [#if stateRestricts?size gt 0]
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
                  <th width="20%">操作</th>
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
                          <td class="title" width="15%">年级</td>
                          <td width="35%">${hisState.grade}</td>
                          <td class="title" width="15%">管理院系</td>
                          <td>[@i18nName (hisState.department)!/]</td>
                        </tr>
                        <tr>
                          <td class="title">专业</td>
                          <td>[@i18nName (hisState.major)!/]  [@i18nName (hisState.direction)!/]</td>
                          <td class="title">行政班</td>
                          <td>${(hisState.squad.shortName)?default((hisState.squad.name)!)}</td>
                        </tr>
                        <tr>
                          <td class="title">是否在校</td>
                          <td>${hisState.inschool?string("是", "否")}</td>
                          <td class="title">状态</td>
                          <td>[@i18nName hisState.status/]</td>
                        </tr>
                        <tr>
                          <td class="title">专业培养方案</td>
                          <td>${(hisState.program.name)!}</td>
                          <td class="title">校区</td>
                          <td>[@i18nName (hisState.campus)!/]</td>
                        </tr>
                        <tr>
                          <td class="title">起始日期</td>
                          <td>${hisState.beginOn?string("yyyy-MM-dd")}</td>
                          <td class="title">结束日期</td>
                          <td>${(hisState.endOn?string("yyyy-MM-dd"))!}</td>
                        </tr>
                        <tr>
                          <td class="title" style="vertical-align: top; padding-top: 4px">备注</td>
                          <td colspan="3">${(hisState.remark?html?replace("\n", "<br>"))!}</td>
                        </tr>
                      </table>
                    </td>
                    <td>
                      <button id="btnStateEdit" type="button">修改</button>
                      <span style="padding-right: 5px"></span>
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
      [#else]
        [@b.div]
          [#list student.states?sort_by("beginOn")?reverse as hisState]
          <table class="${((student.state.id)?default(-1) == (hisState.id)?default(-2))?string("red", "gray")} infoTable" style="border-width: 0px; width: 70%">
            <tr>
              <td class="title" width="15%">年级</td>
              <td width="35%">${hisState.grade}</td>
              <td class="title" width="15%">管理院系</td>
              <td>[@i18nName (hisState.department)!/]</td>
            </tr>
            <tr>
              <td class="title">专业</td>
              <td>[@i18nName (hisState.major)!/] [@i18nName (hisState.direction)!/]</td>
               <td class="title">行政班</td>
              <td>${(hisState.squad.shortName)?default(hisState.squad.name)}</td>
            </tr>
            <tr>
              <td class="title">是否在校</td>
              <td>${hisState.inschool?string("是", "否")}</td>
              <td class="title">状态</td>
              <td>[@i18nName hisState.status/]</td>
            </tr>
            <tr>
              <td class="title">专业培养方案</td>
              <td>${(hisState.program.name)!}</td>
              <td class="title">校区</td>
              <td>[@i18nName (hisState.campus)!/]</td>
            </tr>
            <tr>
              <td class="title">起始日期</td>
              <td>${hisState.beginOn?string("yyyy-MM-dd")}</td>
              <td class="title">结束日期</td>
              <td>${(hisState.endOn?string("yyyy-MM-dd"))!}</td>
            </tr>
            <tr>
              <td class="title" style="vertical-align: top; padding-top: 4px">备注</td>
              <td colspan="3">${(hisState.remark?html)!}</td>
            </tr>
          </table>
            [#if hisState_has_next]<div style="padding-top: 3px; padding-bottom: 3px"><hr color="black" style="font-size: 0pt"></div>[/#if]
          [/#list]
        [/@]
      [/#if]
    [/@]
    [#if stateRestricts?size gt 0]
      [@b.validity]
        $(":hidden[name=stateRow]", document.studentForm).assert(function(element) {
          return 1 <= $(":hidden[name=stateRow]").parent().parent().next().next().children().children().children().last().children().length;
        }, "本学籍必须至少有一条学籍状态记录");
      [/@]
    [/#if]
    [#-- 学生分类标签 --]
    [@b.field label="分类标签"]
      [#if stdRestricts?seq_contains("labels")]
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
      [#else]
        [#if 0 != student.labels?values?size]
        <table class="blue infoTable" style="width: 80%">
          [#list student.labels?values?sort_by([ "labelType", "name" ]) as label]
          <tr>
            <td class="title" style="width: 20%">${label.labelType.name}：</td>
            <td>${label.name}</td>
          </tr>
          [/#list]
        </table>
        [#else]
        <br>
        [/#if]
      [/#if]
    [/@]
    [#if stdRestricts?seq_contains("remark")]
      [@b.textarea label="备注" name="student.remark" value=(student.remark?html)! style="width: 200px; height: 50px" check="maxLength(100)" comments="（限长100个字符）"/]
    [#else]
      [@b.field label="备注"]${(student.remark?html)!}[/@]
    [/#if]
    [@b.formfoot]
      [@b.submit value="保存"/]
    [/@]
  [/@]
  [#if stateRestricts?size gt 0]
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
            "href": "${base}/student!studentStateEdit.action",
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
            "href": "${base}/student!studentStateEdit.action",
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
            stateFormObj.attr("action", "${base}/student!studentStateSave.action");
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
            "href": "${base}/student!labelEdit.action",
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
            lFormObj.attr("action", "${base}/student!labelSave.action");
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
  [/#if]
[#else]
  [#-- 这里是查看，或没有权限维护时进入的地方 --]
  <table class="infoTable" align="center" width="100%">
    <tr style="background-color: white">
      <td width="10%"></td>
      <td width="23%"></td>
      <td width="10%"></td>
      <td width="23%"></td>
      <td width="10%"></td>
      <td></td>
    </tr>
    <tr>
      <td colspan="6" style="font-weight: bold; text-align: center; height: 22px">当前学籍信息</td>
    </tr>
    <tr>
      <td class="title" width="10%">学号：</td>
      <td width="23%">${student.user.code}[#if !student.registed]<sup>无学籍</sup>[/#if]</td>
      <td class="title" width="10%">学生类别：</td>
      <td width="23%">[@i18nName student.stdType/]</td>
      <td rowspan="5" colspan="2">[@eams.avatar width="80px" height="110px" user=student.user/]</td>
    </tr>
    <tr>
      <td class="title">年级：</td>
      <td>${(student.state.grade)!}</td>
      <td class="title">培养层次：</td>
      <td>[@i18nName student.level/]</td>
    </tr>
    <tr>
      <td class="title">学制：</td>
      <td>${student.duration}</td>
      <td class="title">管理院系：</td>
      <td>[@i18nName (student.state.department)?if_exists/]</td>
    </tr>
    <tr>
      <td class="title">专业：</td>
      <td>[@i18nName (student.state.major)?if_exists/] [@i18nName (student.state.direction)?if_exists/]</td>
      <td class="title">行政班：</td>
      <td>[@i18nName (student.state.squad)?if_exists/]</td>
    </tr>
    <tr>
      <td class="title">校区：</td>
      <td>[@i18nName (student.state.campus)?if_exists/]</td>
      <td class="title">学籍状态：</td>
      <td>[@i18nName (student.state.status)?if_exists/]</td>
    </tr>
    <tr>
      <td class="title">学籍有效日期：</td>
      <td>${(student.beginOn?string("yyyy-MM-dd"))!} ${(student.endOn?string("yyyy-MM-dd"))!}</td>
      <td class="title">是否在校：</td>
      <td>${(student.state.inschool?string("是", "否"))!}</td>
    </tr>
    <tr>
      <td class="title">入学-毕业日期：</td>
      <td>${(student.studyOn?string("yyyy-MM-dd"))!}入学  [#if (graduation.graduateOn)??]${graduation.graduateOn?string('yyyy-MM-dd')}毕业[#else]${(student.graduateOn?string("yyyy-MM-dd"))!}预计毕业[/#if]</td>
      <td class="title" style="vertical-align: top; padding-top: 4px">分类标签：</td>
      <td style="padding-top: 0px; padding-bottom: 0px; padding-left: 0px; padding-right: 0px">
        [#if 0 != student.labels?values?size]
        <table class="blue infoTable">
          [#list student.labels?values?sort_by([ "labelType", "name" ]) as label]
          <tr>
            <td class="title" style="width: 20%">${label.labelType.name}：</td>
            <td>${label.name}</td>
          </tr>
          [/#list]
        </table>
        [/#if]
      </td>
    </tr>
    <tr>
      <td class="title">学习形式：</td>
      <td>[@i18nName (student.studyType)!/]</td>
      <td class="title">[#if student.tutor??]导师[#else]班主任[/#if]：</td>
      <td>[#if student.tutor??][@i18nName (student.tutor)!/][#else]${(student.state.squad.instructor.name)!}[/#if]</td>
      [#if student??]
      <td class="title">最近维护时间：</td>
      <td>${student.updatedAt?string("yyyy-MM-dd")}</td>
      [#else]
      <td class="title"></td>
      <td></td>
      [/#if]
    </tr>
    <tr>
      <td class="title">备注：</td>
      <td colspan="5">${(student.remark?html)!}</td>
    </tr>
  </table>
  [#-- 学籍状态日志 --]
  [#if !(!((student.state)??) || (student.states?size)?default(0) == 0)!]
  <div style="height: 5px"></div>
  <table class="infoTable" align="center" width="100%">
    <tr>
      <td height="22" style="font-weight: bold; text-align: center">学籍记录日志</td>
    </tr>
  </table>
  <table class="list infoTable">
    <thead>
      <tr>
        <th>年级</th>
        <th>院系</th>
        <th width="15%">专业</th>
        <th width="18%">行政班</th>
        <th width="6%">是否在校</th>
        <th width="6%">状态</th>
        <th>校区</th>
        <th width="15%">有效期限</th>
        <th>备注</th>
      </tr>
    </thead>
    <tbody>
      [#list student.states?sort_by("beginOn")?reverse as hisState]
      <tr[#if (hisState.id!0) == student.state.id] class="red"[/#if]>
        <td>${hisState.grade}</td>
        <td>[@i18nName hisState.department/]</td>
        <td>[@i18nName (hisState.major)?if_exists/] [@i18nName (hisState.direction)!/]</td>
        <td>${(hisState.squad.shortName)?default((hisState.squad.name)!)}</td>
        <td>${hisState.inschool?string("是", "否")}</td>
        <td>[@i18nName hisState.status/]</td>
        <td>[@i18nName (hisState.campus)!/]</td>
        <td>${hisState.beginOn?string("yyyy-MM-dd")}~${(hisState.endOn?string("yyyy-MM-dd"))!}</td>
        <td>${(hisState.remark?html)!}</td>
      </tr>
      [/#list]
    </tbody>
  </table>
  [/#if]
[/#if]

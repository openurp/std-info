[#ftl]
<link href="${base}/static/css/supply.css?v=1" rel="stylesheet" type="text/css"/>

[@b.toolbar title="班级中的学生调配"]
  bar.addItem("保存调配", function() {
    var squades = "", flags = "", freshmen= "";

    var currTableObj = $("table#distributeTable");

    currTableObj.find(".addButton").each(function() {
      if (squades.length > 0) {
        squades += ";";
        flags += ";";
        freshmen += ";";
      }
      var squadKey = $(this).attr("key");
      squades += squadKey;

      $(this).parent().parent().parent().find("td[key^='" + squadKey + "_']").each(function() {
        var background = $(this).parent().next().children().last().css("background");
        if (!isBlank(background) && background.indexOf("url") != -1) {
          if (flags.length > 0 && flags[flags.length - 1] != ";") {
            flags += ",";
          }
          flags += $(this).attr("key");
        } else if ($(this).children().first().attr("class").indexOf("cancelButton") != -1) {
          if (freshmen.length > 0 && freshmen[freshmen.length - 1] != ";") {
            freshmen += ",";
          }
          freshmen += $(this).attr("key");
        }
      });
    });

    //alert("squades = [" + squades + "]");
    //alert("flags = [" + flags + "]");
    //alert("freshmen = [" + freshmen + "]");

    if (isBlank(flags.replace(new RegExp(";", "gm"), "")) && isBlank(freshmen.replace(new RegExp(";", "gm"), ""))) {
      alert("当前界面上没有进行过任何调配，故无需保存调配！");
      return false;
    }

    var squadUnits = squades.split(";");
    var flagUnits = flags.split(";");
    var freshmanUnits = freshmen.split(";");
    var statMsg = "本次参加调配的班级共有 " + squadUnits.length + " 个，其中：";
    for (var i = 0; i < squadUnits.length; i++) {
      statMsg += "\n第 " + (i + 1) + " 个班级，有 " + (isBlank(flagUnits[i]) ? 0 : flagUnits[i].split(",").length) + " 名学生将被移除，有 " + (isBlank(freshmanUnits[i]) ? 0 : freshmanUnits[i].split(",").length) + " 名学生将被加入";
      statMsg += (i + 1 < squadUnits.length ? "；" : "。\n");
    }
    statMsg += "\n注意，一旦“确定”，将不能逆操作！\n确定要如此调配吗？";
    if (confirm(statMsg)) {
      var form = document.studentDistributionForm;

      form["flags"].value = flags;
      form["freshmen"].value = freshmen;
      //form["params"].value += "&squades=" + squades + "&flags=" + flags + "&freshmen=" + freshmen;

      bg.form.submit(form, "${base}/squadStudent!distribute.action", "squadStudentDiv");
    }
  }, "save.png");

  bar.addItem("调配说明", function() {
    $(this).colorbox({
      "transition": "none",
      "title": "班级中学生调配操作的说明",
      "speed": 0,
      "width": "600px",
      "height": "500px",
      "overlayClose": false,
      "href": "${base}/squadStudent!help.action"
    });
  }, "help-contents.png");

  bar.addItem("取消返回", function() {
    bg.form.submit(document.squadStudentBackForm);
  }, "backward.png");
[/@]
<div style="padding-bottom: 10px">
  <table class="gridtable" width="100%" style="text-align: center">
    <tr>
      <td style="font-weight: bold; background-color: #C7DBFF">所选班级和已配学生</td>
    </tr>
  </table>
  <table id="distributeTable" class="gridtable" width="100%">
    <thead class="gridhead">
      <tr>
        <th>班级代码</th>
        <th>班级名称</th>
        <th>班级年级</th>
        <th>班级培养层次</th>
        <th>班级学生类别</th>
        <th>班级院系</th>
        <th>班级专业</th>
        <th>班级方向</th>
        <th>班级校区</th>
      </tr>
    </thead>
    <tbody>
    [#list squades as squad]
      [#assign trClass = (0 == squad_index % 2)?string("griddata-even", "griddata-odd")/]
      <tr class="${trClass}">
        <td>${squad.code}</td>
        <td>${squad.name}</td>
        <td>${squad.grade}</td>
        <td>${squad.level.name}</td>
        <td>${squad.stdType.name}</td>
        <td>${squad.department.name}</td>
        <td>${squad.major.name}</td>
        <td>${(squad.direction.name)!}</td>
        <td>${(squad.campus.name)!}</td>
      </tr>
      <tr class="${trClass}">
        <td colspan="9">
          <div style="text-align: left"><span style="color: blue; font-weight: bold">${squad.name}</span>中已配学生<span style="margin-left: 10px"><button class="addButton" type="button" key="${squad.project.id}_${squad.level.id}_${squad.stdType.id}_${squad.major.id}_${(squad.direction.id)!"-"}_${(squad.campus.id)!"-"}#${squad.id}" style="border-width: 2px; border-color: green; color: green; cursor:pointer; font-weight: bold; background-color: Honeydew">添加</button><span></div>
          <div style="text-align: left; background-color: rgba(255, 255, 0, 0.4); width: 100%; overflow-x: auto; overflow-y: hidden;white-space: nowrap">
            <table class="table-noborder" style="border-width: 1px">
              <tr>
                [#list squad.stdStates?sort_by(["std", "code"]) as stdState]
                <td style="border-width: 1px">
                  <table cellspacing="0" cellpadding="0">
                    <tr>
                      <td rowspan="3">[@eams.avatar user= stdState.std.user width="40px" height="55px"/]</td>
                      <td>学号：</td>
                      <td>${stdState.std.user.code}</td>
                      <td key="${squad.project.id}_${squad.level.id}_${squad.stdType.id}_${squad.major.id}_${(squad.direction.id)!"-"}_${(squad.campus.id)!"-"}#${squad.id}_${stdState.std.id}" width="40px"><button class="removeButton" type="button" style="border-width: 2px; border-color: red; color: red; cursor: pointer; font-weight: bold; background-color: LavenderBlush">移出</button></td>
                    </tr>
                    <tr>
                      <td>姓名：</td>
                      <td>${stdState.std.user.name}</td>
                      <td rowspan="2" style="text-align: center"></td>
                    </tr>
                    <tr>
                      <td>在籍/在校：</td>
                      <td>${stdState.std.registed?string("是", "否")}/${stdState.inschool?string("是", "否")}</td>
                    </tr>
                  </table>
                </td>
                [/#list]
              </tr>
            </table>
          </div>
        </td>
      </tr>
    [/#list]
    </tbody>
  </table>
</div>

[@b.form name="studentDistributionForm" action="squadStudent!distribute" target="squadStudentDiv"]
  <input type="hidden" name="flags" value=""/>
  <input type="hidden" name="freshmen" value=""/>
  [#assign filterKeys = [ "squadId", "squadIds", "params" ]/]
  [#assign params = ""/]
  [#list Parameters?keys as key]
    [#if !filterKeys?seq_contains(key)]
      [#assign params = params + "&" + key + "=" + Parameters[key]!/]
    [/#if]
  [/#list]
  <input type="hidden" name="params" value="&params=${params?url("UTF-8")}"/>
[/@]

[@b.form name="squadStudentBackForm" action="squadStudent!search" target="squadStudentDiv"]
  [#assign filterKeys = [ "squadId", "squadIds", "params" ]/]
  [#list Parameters?keys as key]
    [#if !filterKeys?seq_contains(key)]
  <input type="hidden" name="${key}" value="${Parameters[key]!}"/>
    [/#if]
  [/#list]
[/@]

<script>
  $(function() {
    $(document).ready(function() {
      var currTableObj = $("table#distributeTable");

      $(".addButton").click(function() {
        var squadKey = $(this).attr("key");
        var squadKeySections = squadKey.split("#");
        var brotherKey = squadKeySections[0];
        var addButtonDiv = $(this).parent().parent();
        [#-- 当前班已经学生 --]
        var memberInCurrClassObjs = addButtonDiv.next().children().first().children().first().children().first().children();
        var freshmenInCurrClassObjs = addButtonDiv.next().next().children().first().children().first().children().first().children();

        [#-- 准备要过滤学生条件的数据 --]
        var members = "", flags = "", brothers = "", otherFlags = "";
        var freshmen = "", otherFreshmen = "";

        memberInCurrClassObjs.each(function() {
          if (members.length > 0) {
            members += ",";
          }
          members += $(this).find("[key]").attr("key");

          var background = $(this).parent().next().children().last().css("background");
          if (!isBlank(background) && background.indexOf("url") != -1) {
            if (flags.length > 0) {
              flags += ",";
            }
            flags += $(this).attr("key");
          }
        });

        freshmenInCurrClassObjs.each(function() {
          if (freshmen.length > 0) {
            freshmen += ",";
          }
          freshmen += $(this).find("[key]").attr("key");
        });

        var brotherClassObjs = currTableObj.find("[key^='" + brotherKey + "']:not([key^='" + squadKey + "'])");
        brotherClassObjs.each(function() {
          var brotherObj = $(this);
          var brotherRole = brotherObj.attr("class");
          if (isBlank(brotherRole)) {
            var background = brotherObj.parent().next().children().last().css("background");
            if (!isBlank(background) && background.indexOf("url") != -1) {
              if (otherFlags.length > 0) {
                otherFlags += ",";
              }
              otherFlags += $(this).attr("key");
            }
            if ("cancelButton" == brotherObj.children().first().attr("class")) {
              if (otherFreshmen.length > 0) {
                otherFreshmen += ",";
              }
              otherFreshmen += $(this).attr("key");
            }
          } else if (brotherRole.indexOf("addButton") != -1) {
            if (brothers.length > 0) {
              brothers += ",";
            }
            brothers += brotherObj.attr("key");
          }
        });
        //alert("brothers: [" + brothers + "]");
        //alert("freshmen: [" + freshmen + "]");
        //alert("otherFlags: [" + otherFlags + "]");
        //alert("otherFreshmen: [" + otherFreshmen + "]");

        [#--  --]
        $(this).colorbox({
          "transition": "none",
          "title": "本班级可配学生列表",
          "speed": 0,
          "width": "800px",
          "height": "600px",
          "overlayClose": false,
          "href": "${base}/squadStudent!loadDistributableStudentsInColorbox.action",
          "data": {
            "squad.id": squadKeySections[1],
            "freshmen": freshmen,
            "brothers": brothers,
            "otherFlags": otherFlags,
            "otherFreshmen": otherFreshmen
          }
        });
      });

      var removeButtonObjs = $(".removeButton");
      removeButtonObjs.click(function() {
        var flagPlaceObj = $(this).parent().parent().next().children().last();
        flagPlaceObj.css("background-image", "url('${base}/static/images/people_out.png')");
        flagPlaceObj.css("background-repeat", "no-repeat");
        flagPlaceObj.css("background-position", "center center");
        flagPlaceObj.css("background-size", "20px 20px");

        $(this).parent().append(cancelObj.clone(true));
        $(this).remove();
      });

      var removeObj = removeButtonObjs.eq(0).clone(true);
      var cancelObj = removeObj.clone();
      cancelObj.css("border-color", "DimGray");
      cancelObj.css("color", "gray");
      cancelObj.css("background-color", "WhiteSmoke");
      cancelObj.html("取消");
      cancelObj.click(function() {
        var memberKey = $(this).parent().attr("key");
        var memberKeySections = memberKey.split("#");
        var memberId = memberKeySections[1].split("_")[1];
        if (currTableObj.find("[key$=_" + memberId + "]").length > 1) {
          $.ajax({
            "type": "post",
            "url": "${base}/studentInfoSearch!loadStudentInAjax.action",
            "async": false,
            "dataType": "json",
            "data": {
              "student.id": memberId
            },
            "success": function(data) {
              alert("当前学生 " + data.student.user.name + "(" + data.student.user.code + ") 已经被加入了“新生”（即绿色区域）中，不能立即“取消”。\n若要“取消”，则必须先将该学生从“新生”中“取消”。");
            },
            "error": function(rs) {
              alert(rs.responseText);
            }
          });
          return;
        }

        var flagPlaceObj = $(this).parent().parent().next().children().last();
        flagPlaceObj.css("background", "");

        $(this).parent().append(removeObj.clone(true));
        $(this).remove();
      });
    });
  });
</script>

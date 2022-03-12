[#ftl]
[@b.form name="dsAjaxForm" action="squadStudent!loadDistributableStudentsInAjax" target="distributableStudentsDiv"]
  <input type="hidden" name="squad.id" value="${Parameters["squad.id"]}"/>
  <input type="hidden" name="freshmen" value="${Parameters["freshmen"]!}"/>
  <input type="hidden" name="brothers" value="${Parameters["brothers"]!}"/>
  <input type="hidden" name="otherFlags" value="${Parameters["otherFlags"]!}"/>
  <input type="hidden" name="otherFreshmen" value="${Parameters["otherFreshmen"]!}"/>
  <input type="hidden" name="isSingle" value="${Parameters["isSingle"]}"/>
  [@b.grid items=students var="student" sortable="true" filterable="true"]
    [@b.gridbar]
      bar.addItem("加入本班", function() {
        var studentIds = bg.input.getCheckBoxValues("student.id");
        if (isBlank(studentIds)) {
          alert("请选择要加入本班的学生，谢谢！");
          return;
        }

        var freshmanIds = studentIds.split(",")
        //alert("您当前选择了 " + freshmanIds.length + " 名学生要加入本班中。\n他们（id）是：" + studentIds + " 。");

        currentSquad("${squad.project.id}_${squad.level.id}_${squad.stdType.id}_${squad.major.id}_${(squad.direction.id)!"-"}_${(squad.campus.id)!"-"}#${squad.id}").addFreshmen(freshmanIds);

        function currentSquad(squadKey) {
          var addButtonRowObj = $("button[key='" + squadKey + "']").parent().parent();
          var historyFreshmenDivObj = addButtonRowObj.next().next();
          var fTbodyObj, freshmenRowObj = null;
          if (historyFreshmenDivObj.length == 0) {
            historyFreshmenDivObj = $("<div>");
            historyFreshmenDivObj.css("text-align", "left");
            historyFreshmenDivObj.css("background-color", "rgba(0, 255, 0, 0.4)");
            historyFreshmenDivObj.css("width", "100%");
            historyFreshmenDivObj.css("overflow-x", "auto");
            historyFreshmenDivObj.css("overflow-y", "hidden");
            historyFreshmenDivObj.css("white-space", "nowrap");

            var fTableObj = $("<table>");
            fTableObj.addClass("table-noborder");
            fTableObj.css("border-width", "1px");
            historyFreshmenDivObj.append(fTableObj);

            fTbodyObj = $("<tbody>");
            fTableObj.append(fTbodyObj);

            freshmenRowObj = $("<tr>");
            fTbodyObj.append(freshmenRowObj);
          } else {
            $("<div>").append(historyFreshmenDivObj);

            fTbodyObj = historyFreshmenDivObj.children().first().children().first();
            freshmenRowObj = fTbodyObj.children().first();
          }

          return {
            "addFreshmen": function(freshmanIds) {
              var isSingle = 1 == ${Parameters["isSingle"]};
              for (var i = 0; i < freshmanIds.length; i++) {
                if (isSingle && i > 0 && i % 4 == 0) {
                  freshmenRowObj = $("<tr>");
                  fTbodyObj.append(freshmenRowObj);
                }
                var freshmanObj = $("<td>");
                freshmanObj.css("border-width", "1px");
                freshmenRowObj.append(freshmanObj);

                $.ajax({
                  "type": "post",
                  "url": "${base}/studentInfoSearch!loadStudentInAjax.action",
                  "async": false,
                  "dataType": "json",
                  "data": {
                    "student.id": freshmanIds[i]
                  },
                  "success": function(data) {
                    var stdTableObj = $("<table>");
                    stdTableObj.attr("cellspacing", "0px");
                    stdTableObj.attr("cellpadding", "0px");
                    freshmanObj.append(stdTableObj);

                    var stdTrObj1 = $("<tr>");
                    stdTableObj.append(stdTrObj1);

                    var stdTdObj1_1 = $("<td>");
                    stdTdObj1_1.attr("rowspan", "3");
                    var photoObj = $("<img>");
                    photoObj.attr("src", data.student.photo);
                    photoObj.attr("width", "40px");
                    photoObj.attr("height", "55px");
                    stdTdObj1_1.append(photoObj);
                    stdTrObj1.append(stdTdObj1_1);

                    var stdTdObj1_2 = $("<td>");
                    stdTdObj1_2.html("学号：");
                    stdTrObj1.append(stdTdObj1_2);

                    var stdTdObj1_3 = $("<td>");
              stdTdObj1_3.html(data.student.user.code);
                    stdTrObj1.append(stdTdObj1_3);

                    var stdTdObj1_4 = $("<td>");
                    stdTdObj1_4.attr("key", squadKey + "_" + freshmanIds[i]);
                    stdTdObj1_4.attr("width", "40px");
                    var cancalObj = $("<button>");
                    cancalObj.addClass("cancelButton");
                    cancalObj.attr("type", "button");
                    cancalObj.css("border-width", "2px");
                    cancalObj.css("border-color", "DarkOrange");
                    cancalObj.css("color", "DarkOrange");
                    cancalObj.css("cursor", "pointer");
                    cancalObj.css("font-weight", "bold");
                    cancalObj.css("background-color", "Linen");
                    cancalObj.html("取消");
                    cancalObj.click(function() {
                      if(historyFreshmenDivObj.children().first().find("table").length == 1) {
                        historyFreshmenDivObj.remove();
                      } else {
                        $(this).parent().parent().parent().parent().parent().remove();
                      }
                    });
                    stdTdObj1_4.append(cancalObj);
                    stdTrObj1.append(stdTdObj1_4);

                    var stdTrObj2 = $("<tr>");
                    stdTableObj.append(stdTrObj2);

                    var stdTdObj2_1 = $("<td>");
                    stdTdObj2_1.html("姓名：");
                    stdTrObj2.append(stdTdObj2_1);

                    var stdTdObj2_2 = $("<td>");
                    stdTdObj2_2.html(data.student.user.name);
                    stdTrObj2.append(stdTdObj2_2);

                    var stdTdObj2_3 = $("<td>");
                    stdTdObj2_3.attr("rowspan", "2");
                    stdTrObj2.append(stdTdObj2_3);

                    var stdTrObj3 = $("<tr>");
                    stdTableObj.append(stdTrObj3);

                    var stdTdObj3_1 = $("<td>");
                    stdTdObj3_1.html("在籍/在校：");
                    stdTrObj3.append(stdTdObj3_1);

                    var stdTdObj3_2 = $("<td>");
                    stdTdObj3_2.html(data.student.registed + "/" + data.student.state.inschool);
                    stdTrObj3.append(stdTdObj3_2);

                    //alert(freshmenRowObj.html());
                  },
                  "error": function(rs) {
                    //alert(rs.responseText);
                  }
                });
              }

              addButtonRowObj.parent().append(historyFreshmenDivObj);
              $.colorbox.close();
            }
          };
        }
      }, "new.png");
    [/@]
    [@b.row]
      [@b.boxcol/]
      [@b.col property="user.code" title="学号"/]
      [@b.col property="user.name" title="姓名"/]
      [@b.col property="duration" title="学制" width="5%" filterable="false"/]
      [@b.col property="state.direction.name" title="方向" width="10%" filterable="false"/]
      [@b.col property="state.campus.name" title="校区" width="10%" filterable="false" filterable="false"/]
      [@b.col property="registed" title="在籍" width="5%" filterable="false"]${(student.registed)?string("是", "否")}[/@]
      [@b.col property="inschool" title="在校" width="5%" filterable="false"]${(student.state.inschool)?string("是", "否")}[/@]
      [@b.col property="state.squad.name" title="班级" width="25%" filterable="false"/]
    [/@]
  [/@]
[/@]

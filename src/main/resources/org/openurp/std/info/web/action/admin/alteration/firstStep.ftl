[#ftl]
[@b.head/]
[@b.toolbar title="<span style='color:red'>第一步</span>：学生查询"]
  bar.addItem("添加到异动列表","addToCart()");
  bar.addItem("${b.text('返回')}","goBack()","backward.png");

  function goBack(){
    bg.form.submit("stdAlterFirstStepForm","stdAlteration!index.action","main");
  }

  function del(stdId) {
      jQuery("#conditionTable").find("#stdId"+stdId).parents("tr").remove();
    }

  function addToCart() {
    var studentIds = bg.input.getCheckBoxValues("student.id");
      if(studentIds=="" || studentIds==null) {
        alert("请至少选择一条操作");return;
      }
      jQuery("#studentIds").val("");
    var checkedBox = jQuery("#alterationStudentGrid").find(":input:checked");
      checkedBox.each(function() {
        if(jQuery(this).val()=="on") return;
        if(jQuery("#conditionTable").find(".stdId[value="+jQuery(this).val()+"]").length>0) return;
        jQuery("#conditionBody").append("<tr align='center'><input type='hidden' class='stdId' value=''><td class='stdCode'></td><td class='stdName'></td><td class='stdGrade'></td><td class='departName'></td><td class='majorName'></td><td class='rm'></td></tr>");
        var selectTd = jQuery(this).parent().nextAll();
        jQuery("#conditionTable tr:last").find("td").each(function(){
          jQuery(this).html(selectTd.filter("[classname='"+jQuery(this).prop("className") + "']").html());
        });
        jQuery("#conditionTable tr:last").find(".stdId").val(jQuery(this).val());
        jQuery("#conditionTable tr:last").find("td.rm").html("<a href='javascript:void(0)' onclick='del("+jQuery(this).val()+")' id='stdId"+jQuery(this).val()+"'>移除</a>");
      });
      jQuery.colorbox({transition : 'none', "opacity" :0.2, height:"80%",width:"60%", inline:true, href:"#setAlterationDiv"});
  }
[/@]
<div class="search-container">
  <div class="search-panel">
      [@b.form name="stdAlterFirstStepForm" action="!listStudents" title="ui.searchForm" target="stdListDiv" theme="search"]
         [@b.textfield name="stdCodes" label="学号" value="" maxlength="50000" placeholder="逗号或空格隔开多个学号"/]
         [@b.textfields names="student.name;姓名,student.state.grade.code;年级" maxLength="100"/]
         [@b.select label="是否在籍" id="active" name="active" items={'1':'是','0':'否'} value="1" empty="..."/]
         [@b.select label="是否在校" id="inschool" name="inschool" items={'1':'是','0':'否'} value="1" empty="..."/]
      [/@]
  </div>
  <div class="search-list">
        [@b.div id="stdListDiv" href="!listStudents?active=1&inschool=1" /]
  </div>
</div>
  <div style="display:none">
    <div id="setAlterationDiv">
      [@b.toolbar title="设置异动列表"]
        bar.addItem("下一步","secondStep()");
        bar.addItem("${b.text('action.close')}","jQuery.colorbox.close();");

         function secondStep() {
              var stdIds ="";
              jQuery("#conditionTable .stdId").each(function(i){
                if(i>0){
                  stdIds += "," ;
                }
                stdIds += jQuery(this).val();
              });
              if(stdIds==""||stdIds==null){
                alert("请将待异动学生添加入列表");
              }else{
                jQuery("#studentIds").val(stdIds);
                bg.form.submit(document.alterSettingForm);
              }
              jQuery.colorbox.close();
            }
      [/@]
      [@b.form action="!secondStep" name="alterSettingForm" target="contentDiv"]
          <input type="hidden" value="" name="studentIds" id="studentIds">
          <table id="columnTable" class="grid-table">
          <tr>
            <td>
              <label for="alterConfig">异动类型</label>
              <select id="alterConfig" name="alterConfig.id" >
              [#list alterConfigs as ac]
              <option value="${ac.id}">${ac.alterType.name}</option>
              [/#list]
              </select>
            </td>
          </tr>
          </table>
          <br/>
          <table id="conditionTable" class="grid-table" style="border: 0.5px solid #006CB2;">
            <thead class="grid-head">
              <tr>
                <th style="width: 100px;">学号</th>
                <th style="width: 100px;">姓名</th>
                <th style="width: 70px;">年级</th>
                <th style="width: 150px;">院系</th>
                <th>专业</th>
                <th style="width: 50px;">操作</th>
              </tr>
            </thead>
            <tbody id="conditionBody">
            </tbody>
          </table>
        [/@]
    </div>
  </div>
[@b.foot/]

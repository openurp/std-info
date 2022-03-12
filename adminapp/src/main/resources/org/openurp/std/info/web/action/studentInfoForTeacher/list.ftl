[#ftl]
[@b.head/]
[@b.toolbar title= ("<font color='blue'>"+squad.name+"</font>学生列表")/]
  [@b.grid items=squad.students?sort_by("code") var="student" id="studentPasswordGrid"]
    [@b.gridbar]
      bar.addItem("查询学生信息",action.info());
      bar.addItem("修改学生密码","changePassword()");

      function del(stdId) {
            jQuery("#conditionTable").find("#stdId"+stdId).parents("tr").remove();
          }

          function pareDatas(){
            var stdIds ="";
            jQuery("#conditionTable .stdId").each(function(i){
              if(i>0){
                stdIds += "," ;
              }
          stdIds += jQuery(this).val();
            });
            if(stdIds==""||stdIds==null){
              alert("请选择带改变密码的学生");
              return false;
            }else{
              jQuery("#studentIds").val(stdIds);
              return true;
            }
          }

      function changePassword(){
        var studentIds = bg.input.getCheckBoxValues("student.id");
          if(studentIds=="" || studentIds==null) {
            alert("请至少选择一条操作");return;
          }
          jQuery("#conditionBody").empty();
          jQuery("#studentIds").val("");
        var checkedBox = jQuery("#studentPasswordGrid").find(":input:checked");
          checkedBox.each(function() {
            if(jQuery(this).val()=="on") return;
            if(jQuery("#conditionTable").find(".stdId[value="+jQuery(this).val()+"]").length>0) return;
            jQuery("#conditionBody").append("<tr align='center'><input type='hidden' class='stdId' value=''><td class='stdCode'></td><td class='stdName'></td><td class='stdGrade'></td><td class='departName'></td><td class='majorName'></td><td class='rm'></td></tr>");
            var selectTd = jQuery(this).parent().nextAll();
            jQuery("#conditionTable tr:last").find("td").each(function(){
              jQuery(this).html(selectTd.filter("."+jQuery(this).prop("className")).html());
            });
            jQuery("#conditionTable tr:last").find(".stdId").val(jQuery(this).val());
            jQuery("#conditionTable tr:last").find("td.rm").html("<a href='javascript:void(0)' onclick='del("+jQuery(this).val()+")' id='stdId"+jQuery(this).val()+"'>移除</a>");
          });
        jQuery.colorbox({title:'修改密码',transition : 'none', height:"80%",width:"60%", inline:true, href:"#stdPasswordDiv"});
      }
    [/@]
    [@b.row]
      [@b.boxcol/]
      [@b.col property="code" title="attr.stdNo" class="stdCode"/]
      [@b.col property="name" title="attr.name" class="stdName"/]
      [@b.col property="gender.name" title="entity.gender"/]
      [@b.col property="grade" title="adminClass.grade" class="stdGrade"/]
      [@b.col property="department.name" title="common.college" class="departName"/]
      [@b.col property="major.name" title="entity.major" class="majorName"/]
    [/@]
  [/@]
  <div style="display:none">
    <div id="stdPasswordDiv">
        <table id="conditionTable" class="gridtable">
          <tHead class="gridhead">
            <th>学号</th>
            <th>姓名</th>
            <th>年级</th>
            <th>院系</th>
            <th>专业</th>
            <th>操作</th>
          </tHead>
          <tbody id="conditionBody">
          </tbody>
        </table>
        [@b.form action="!updatePassword" name="stdPasswordForm" target="main" theme="list"]
          [@b.password label="请输入密码" required="true" name="user.password"/]
          [@b.formfoot]
            <input type="hidden" value="" name="studentIds" id="studentIds">
               <input type="button" onclick='reset()' value="${b.text("system.button.reset")}" class="buttonStyle"/>
               <input type="submit" onclick="bg.form.submit('stdPasswordForm',null,null,'pareDatas()');jQuery.colorbox.close();return false;" value="${b.text('action.submit')}">
        [/@]
        [/@]
    </div>
  </div>
[@b.foot/]

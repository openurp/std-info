[#ftl]
[@b.head/]
[@b.grid items=graduations var="graduation"]
  [@b.gridbar]
    bar.addItem("${b.text('action.export')}", "exportData()");
    bar.addItem("学位证书下载", "degreeDownload()");
		[#if project.minor]
    	bar.addItem("专业证书下载", "diplomaDownload()");
    [#else ]
			bar.addItem("毕业证书下载", "diplomaDownload()");
    [/#if]
  [/@]
  [@b.row]
    [@b.boxcol /]
      [@b.col title="学号" property="std.user.code" width="12%"][/@]
      [@b.col title="姓名" property="std.user.name" width="6%"][/@]
      [@b.col title="培养层次" property="std.level.name" width="6%"][/@]
      [@b.col title="院系" property="std.state.department.name" width="10%"]
      ${graduation.std.state.department.shortName!graduation.std.state.department.name}
      [/@]
      [@b.col title="专业/方向" property="std.state.major.name" width="14%"]
        <span style="font-size:0.8em">${(graduation.std.state.major.name)!} ${(graduation.std.state.direction.name)!}</span>
      [/@]
      [@b.col title="毕业证书编号" property="code" width="12%"]<span style="font-size:0.8em">${graduation.code!}</span>[/@]
      [@b.col title="毕业日期" property="graduateOn" width="7%"]${((graduation.graduateOn)?string("yy-MM-dd"))?default("")}[/@]
      [@b.col title="毕结业情况" property="educationResult.name" width="6%"][/@]
      [@b.col title="学位" property="degree.name" width="6%"]
      <span style="font-size:0.8em">${(graduation.degree.name)!}</span>
      [/@]
      [@b.col title="学位授予日期" property="degreeAwardOn" width="7%"]${((graduation.degreeAwardOn)?string("yy-MM-dd"))?default("")}[/@]
      [@b.col title="学位证书号" property="diplomaNo" width="11%"]<span style="font-size:0.8em">${graduation.diplomaNo!}</span>[/@]
  [/@]
[/@]
<script>

	var form = document.searchForm;
	function exportData(){
    bg.form.addInput(form, "keys", "graduateOn,std.state.major.name,std.level.name,std.user.name,std.person.gender.name,std.person.code,std.user.code,std.person.nation.name,std.contact.mobile,std.contact.email,diplomaNo,code,degreeAwardOn,educationResult.name,degree.name");
    bg.form.addInput(form, "titles", "毕业年份,专业,学历,姓名,性别,身份证,学号,民族,手机,邮箱,学位证书号,毕业证书号,学位授予日期,毕结业情况,学位");
    bg.form.addInput(form, "fileName", "毕业信息");
    bg.form.submit(form, "${b.url('!export')}","_self");
  }

  function degreeDownload()
  {
		var url = "${b.url('!degreeDownload?id=aaa')}";
    var graduationId = bg.input.getCheckBoxValues("graduation.id");
    if(graduationId==""||graduationId.indexOf(',')!=-1){
			alert("请仅选择一条进行操作!");
			return;
  	}
		var newUrl = url.replace("aaa",graduationId);
		bg.form.submit(form,newUrl,"_blank");
  }

	function diplomaDownload()
	{
		var url = "${b.url('!diplomaDownload?id=aaa')}";
		var graduationId = bg.input.getCheckBoxValues("graduation.id");
		if(graduationId==""||graduationId.indexOf(',')!=-1){
			alert("请仅选择一条进行操作!");
			return;
		}
		var newUrl = url.replace("aaa",graduationId);
		bg.form.submit(form,newUrl,"_blank");
	}
</script>
[@b.foot/]

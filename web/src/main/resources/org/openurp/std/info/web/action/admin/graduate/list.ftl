[#ftl]
[@b.head/]
[@b.grid items=graduates var="graduate"]
  [@b.gridbar]
    var m1 = bar.addItem("${b.text('action.export')}", "exportData()");
    bar.addItem("导入..",action.method('importForm'));
    [#--
    var m2 = bar.addMenu("证书下载");
    m2.addItem("学位证书下载", "degreeDownload()");
    [#if project.minor]
      m2.addItem("专业证书下载", "certificationDownload()");
    [#else ]
      m2.addItem("毕业证书下载", "certificationDownload()");
    [/#if]
    --]
    [#if (Parameters['graduate.season.id']!'')?length>0]
    bar.addItem("学籍状态处理", action.method("batchUpdateStdState","确定根据毕业状态处理该批次处理学籍状态？"));
    [/#if]
  [/@]
  [@b.row]
      [@b.boxcol /]
      [@b.col title="学号" property="std.code" width="100px"][/@]
      [@b.col title="姓名" property="std.name" width="6%"]
        [@b.a href="student!info?id=${graduate.std.id}" target="_blank"]${graduate.std.name}[/@]
      [/@]
      [@b.col title="培养层次" property="std.level.name" width="6%"][/@]
      [@b.col title="培养类型" property="std.eduType.name" width="6%"][/@]
      [@b.col title="院系" property="std.state.department.name" width="10%"]
      ${graduate.std.state.department.shortName!graduate.std.state.department.name}
      [/@]
      [@b.col title="专业/方向" property="std.state.major.name"]
        <span style="font-size:0.8em">${(graduate.std.state.major.name)!} ${(graduate.std.state.direction.name)!}</span>
      [/@]
      [@b.col title="毕结业情况" property="result.name" width="80px"][/@]
      [@b.col title="毕业日期" property="graduateOn" width="7%"]${((graduate.graduateOn)?string("yy-MM-dd"))?default("")}[/@]
      [@b.col title="毕业证书编号" property="certificateNo"]<span style="font-size:0.8em">${graduate.certificateNo!}</span>[/@]
      [@b.col title="学位" property="degree.name" width="6%"]
      <span style="font-size:0.8em">${(graduate.degree.name)!}</span>
      [/@]
      [@b.col title="学位授予日期" property="degreeAwardOn" width="90px"]${((graduate.degreeAwardOn)?string("yy-MM-dd"))?default("")}[/@]
      [@b.col title="学位证书号" property="diplomaNo"]<span style="font-size:0.8em">${graduate.diplomaNo!}</span>[/@]
  [/@]
[/@]
<script>

  var form = document.searchForm;
  function exportData(){
    bg.form.addInput(form, "keys", "graduateOn,std.state.major.name,std.level.name,std.name,std.person.gender.name,std.person.code,std.code,std.person.nation.name,diplomaNo,certificateNo,degreeAwardOn,result.name,degree.name");
    bg.form.addInput(form, "titles", "毕业日期,专业,学历,姓名,性别,身份证,学号,民族,学位证书号,毕业证书号,学位授予日期,毕结业情况,学位");
    bg.form.addInput(form, "fileName", "毕业信息");
    bg.form.submit(form, "${b.url('!exportData')}","_self");
  }

  function degreeDownload(){
    var url = "${b.url('!degreeDownload?id=aaa')}";
    var graduateId = bg.input.getCheckBoxValues("graduate.id");
    if(graduateId==""||graduateId.indexOf(',')!=-1){
      alert("请仅选择一条进行操作!");
      return;
    }
    var newUrl = url.replace("aaa",graduateId);
    bg.form.submit(form,newUrl,"_blank");
  }

  function certificationDownload(){
    var url = "${b.url('!certificationDownload?id=aaa')}";
    var graduateId = bg.input.getCheckBoxValues("graduate.id");
    if(graduateId==""||graduateId.indexOf(',')!=-1){
      alert("请仅选择一条进行操作!");
      return;
    }
    var newUrl = url.replace("aaa",graduateId);
    bg.form.submit(form,newUrl,"_blank");
  }
</script>
[@b.foot/]

[#ftl]
[@b.head/]
[@b.grid items=graduates var="graduate"]
  [@b.gridbar]
    var m1 = bar.addMenu("${b.text('action.export')}", "exportData()");
    m1.addItem("导出学位网格式","exportDegree()");
    bar.addItem("导入..",action.method('importForm'));
    bar.addItem("证书打印", action.multi('certificate',null,null,false));
    [#if (Parameters['graduate.season.id']!'')?length>0]
    bar.addItem("学籍状态处理", action.method("batchUpdateStdState","确定根据毕业状态处理该批次处理学籍状态？"));
    [/#if]
  [/@]
  [@b.row]
      [@b.boxcol /]
      [@b.col title="学号" property="std.code" width="110px"]
        <div class="text-ellipsis">${graduate.std.code}</div>
      [/@]
      [@b.col title="姓名" property="std.name" width="6%"]
        <div class="text-ellipsis" title="${graduate.std.name}">
          [@b.a href="student!info?id=${graduate.std.id}" target="_blank"]${graduate.std.name}[/@]
        </div>
      [/@]
      [@b.col title="培养层次" property="std.level.name" width="6%"][/@]
      [@b.col title="培养类型" property="std.eduType.name" width="6%"][/@]
      [@b.col title="院系" property="std.state.department.name" width="8%"]
      ${graduate.std.state.department.shortName!graduate.std.state.department.name}
      [/@]
      [@b.col title="专业/方向" property="std.state.major.name"]
        <span style="font-size:0.8em">${(graduate.std.state.major.name)!} ${(graduate.std.state.direction.name)!}</span>
      [/@]
      [@b.col title="毕结业情况" property="result.name" width="80px"][/@]
      [@b.col title="毕业日期" property="graduateOn" width="7%"]${((graduate.graduateOn)?string("yy-MM-dd"))?default("")}[/@]
      [@b.col title="毕业证书编号" property="certificateNo"]<span style="font-size:0.8em">${graduate.certificateNo!}</span>[/@]
      [@b.col title="学位" property="degree.name" width="8%"]
      <span style="font-size:0.8em">${(graduate.degree.name)!}</span>
      [/@]
      [@b.col title="学位授予日期" property="degreeAwardOn" width="90px"]${((graduate.degreeAwardOn)?string("yy-MM-dd"))?default("")}[/@]
      [@b.col title="学位证书号" property="diplomaNo"]<span style="font-size:0.8em">${graduate.diplomaNo!}</span>[/@]
  [/@]
[/@]
<script>
  var form = document.searchForm;
  function exportData(){
    bg.form.addInput(form, "titles", "graduateOn:毕业日期,std.state.major.name:专业,std.state.direction.name:方向,std.level.name:学历,std.name:姓名,"+
                     "std.gender.name:性别,std.person.code:身份证,std.code:学号,"+
                     "std.person.nation.name:民族,diplomaNo:学位证书号,certificateNo:毕业证书编号,certificateSeqNo:毕业证书序列号,"+
                     "degreeAwardOn:学位授予日期,result.name:毕结业情况,degree.name:学位");
    bg.form.addInput(form, "convertToString", "0");
    bg.form.addInput(form, "fileName", "毕业信息");
    bg.form.submit(form, "${b.url('!exportData')}","_self");
  }

  function exportDegree(){
    bg.form.addInput(form, "titles",
                     "std.name:姓名(XM),std.enName:姓名拼音(XMPY),std.gender.code:性别码(XBM),std.gender.name:性别(XB),"+
                     "std.person.country.code:国家或地区码(GBM),std.person.nation.code:民族码(MZM),"+
                     "std.person.nation.name:民族(MZ),std.person.politicalStatus.code:政治面貌码(ZZMMM),"+
                     "std.person.politicalStatus.name:政治面貌(ZZMM),std.person.birthday:出生日期(CSRQ),"+
                     "std.person.idType.code:证件类型码(ZJLXM),std.person.idType.name:证件类型(ZJLX),"+
                     "std.person.code:证件号码(ZJHM),std.project.school.code:学位授予单位码(XWSYDWM),"+
                     "std.project.school.name:学位授予单位(XWSYDW),blank.1:学位授予单位校长（院长、所长）姓名(XZXM):校长,"+
                     "blank.2:学位评定委员会主席姓名(ZXXM):主席,std.project.school.code:培养单位码(PYDWM),"+
                     "std.project.school.name:培养单位(PYDW),degree.code:学位类别码(XWLBM),degree.name:学位类别(XWLB),"+
                     [#if project.category.name?contains("成人")]
                     "std.state.major.code:学士专业码(ZYDM),std.state.major.name:学士专业(ZYMC),"+
                     [#else]
                     "std.state.major.code:专业码(ZYDM),std.state.major.name:专业(ZYMC),"+
                     [/#if]
                     "std.state.major.name:证书专业名称(ZSZYMC),"+
                     "examinee.code:考生号(KSH),std.studyOn:入学年月(RXNY),std.code:学号(XH),"+
                     "std.duration:学制(XZ),std.studyType.code:学习形式码(XXXSM),std.studyType.name:学习形式(XXXS),"+
                     [#if project.category.name?contains("成人")]"foreignLangPassedOn:通过英语水平考试年月(WYKSNY),"+[/#if]
                     "graduateOn:毕业年月(BYNY),"+
                     "degreeAwardOn:获学位日期(HXWRQ),diplomaNo:学位证书编号(XWZSBH),blank.3:决议编号（文号）(JYBH):文号,"+
                     "std.person.code:照片文件名称(ZP),blank.4:备注(BZ),blank.5:QQ号码(QQHM),blank.6:微信账号(WXZH),"+
                     "blank.7:电子邮箱(DZYX),blank.8:院系代码(YXDM)");
    bg.form.addInput(form, "fileName", "上传学位网");
    bg.form.addInput(form, "convertToString", "1");
    bg.form.submit(form, "${b.url('!exportData')}","_self");
  }
</script>
[@b.foot/]

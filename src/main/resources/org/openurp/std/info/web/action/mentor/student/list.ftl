[@b.head/]
  [@b.form name="studentListForm" action="!search"]
    [@b.grid items=students var="student" sortable="true"]
      [@b.gridbar]
        var titles="std.code:学号,std.name:姓名,std.enName:姓名拼音,person.gender.name:性别,"+
           "std.state.grade.code:年级,std.studyType.name:学习形式,std.duration:学制,"+
           "std.level.name:培养层次,std.stdType.name:学生类别,"+
           [#if project.eduTypes?size>1]"std.eduType.name:培养类型,"+[/#if]
           "std.state.department.name:院系,std.state.major.name:专业,std.state.direction.name:专业方向,"+
           "std.state.squad.name:班级,std.state.status.name:学籍状态,"+
           [#if project.category.name?contains("成人")]"std.state.squad.master.name:班主任,"+[#else]"std.state.squad.mentor.name:辅导员,"+[/#if]
           "person.birthday:出生日期,person.nation.name:民族,person.politicalStatus.name:政治面貌,person.country.name:国家地区,"+
           "person.idType.name:证件类型,person.code:证件号码,"+
           "std.studyOn:入校日期,std.graduateOn:预计毕业日期,"+
           [#if tutorSupported]"std.tutor.name:导师姓名,std.advisor.name:学位论文导师姓名,"+[/#if]
           "contact.mobile:手机,contact.address:联系地址,contact.email:电子邮箱,"+
           "examinee.code:考生号,examinee.educationMode.name:培养方式,"+
           "examinee.originDivision.name:生源地,examinee.client:委培单位";

        bar.addItem("${b.text('action.export')}",action.exportData(titles,null,'fileName=学籍信息'));
      [/@]
      [@b.row]
        [@b.boxcol/]
        [@b.col property="code" title="学号" width="120px"/]
        [@b.col property="name" title="姓名" width="80px"]
          [@b.a href="!info?id=${student.id}" target="_blank"]
            <div title="${student.name}" class="text-ellipsis">${student.name}</div>
          [/@]
        [/@]
        [@b.col property="gender.name" title="性别" width="50px"/]
        [@b.col property="state.grade" title="年级" width="60px"/]
        [@b.col property="level.name" title="培养层次" width="60px"/]
        [#if project.eduTypes?size>1]
        [@b.col property="eduType.name" title="培养类型" width="60px"/]
        [/#if]
        [@b.col property="state.department.name" title="院系" width="100px"]
          ${student.state.department.shortName!student.state.department.name}
        [/@]
        [@b.col property="state.major.name" title="专业与方向"]
          ${(student.state.major.name)!} ${(student.state.direction.name)!}
        [/@]
        [@b.col property="duration" title="学制" width="50px"/]
        [@b.col property="state.squad.name" title="班级"/]
        [#if tutorSupported]
        [@b.col property="tutor.name" title="导师" width="80px"/]
        [/#if]
        [@b.col property="state.status.name" title="学籍状态"  width="60px"/]
        [@b.col property="studyType.name" title="学习形式" width="60px"/]
        [@b.col property="beginOn" title="入学年月" width="60px"]${(student.beginOn?string("yyyy-MM"))!}[/@]
      [/@]
    [/@]
  [/@]
[@b.foot/]

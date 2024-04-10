[@b.head/]
  [@b.form name="studentListForm" action="!search"]
    [@b.grid items=students var="student" sortable="true"]
      [@b.gridbar]
        var titles="gender.name_person:性别,birthday_person:出生日期,nation.name_person:民族,country.name_person:国家地区,"+
                   "idType.name_person:证件类型,code_person:证件号码,politicalStatus.name_person:政治面貌,code_std:学号,"+
                   "name_std:姓名,state.grade.code_std:年级,studyType.name_std:学习形式,duration_std:学制,"+
                   "level.name_std:培养层次,stdType.name_std:学生类别,eduType.name_std:培养类型,"+
                   "state.department.name_std:院系,state.major.name_std:专业,state.direction.name_std:专业方向,"+
                   "studyOn_std:入校日期,graduateOn_std:预计毕业日期,state.status.name_std:学籍状态,tutor.name_std:导师姓名,"+
                   "advisor.name_std:学位论文导师姓名,mobile_contact:手机,address_contact:联系地址,email_contact:电子邮箱,"+
                   "code_examinee:考生号,examNo_examinee:准考证号,educationMode.name_examinee:培养方式,"+
                   "originDivision.name_examinee:生源地,client_examinee:委培单位"
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
        [@b.col property="eduType.name" title="培养类型" width="60px"/]
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

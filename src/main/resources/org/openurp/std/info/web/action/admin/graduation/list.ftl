[@b.head/]
    [@b.grid items=students var="student" sortable="true"]
      [@b.gridbar]
        bar.addItem("${b.text("action.export")}",action.exportData("code:学号,name:姓名,gender.name:性别,state.grade.code:年级,"+
                "level.name:层次,duration:学制,department.name:院系,disciplineCode:专业代码,disciplineName:专业名称,"+
                "state.squad.code:班级号码,person.idType.name:证件类型,person.code:证件号码,"+
                "person.nation.name:民族,person.politicalStatus.name:政治面貌,examinee.code:考生号,studyOn:入学日期,graduateOn:预计毕业日期"
                ,null,'fileName=预计毕业生数据'));
      [/@]
      [@b.row]
        [@b.boxcol/]
        [@b.col property="code" title="学号" width="120px"/]
        [@b.col property="name" title="姓名" width="80px"]
          <div title="${student.name}" class="text-ellipsis">${student.name}</div>
        [/@]
        [@b.col property="gender.name" title="性别" width="50px"/]
        [@b.col property="state.grade" title="年级" width="60px"/]
        [@b.col property="level.name" title="培养层次" width="60px"/]
        [@b.col property="duration" title="学制" width="50px"/]
        [@b.col property="state.department.name" title="院系" width="100px"]
          ${student.state.department.shortName!student.state.department.name}
        [/@]
        [@b.col property="state.major.name" title="专业"]
          ${student.disciplineName} ${student.disciplineCode!}
        [/@]
        [@b.col property="state.squad.name" title="班级"]
          <div title="${(student.state.squad.name)!}" class="text-ellipsis">${(student.state.squad.shortName)!(student.state.squad.name)}</div>
        [/@]
        [@b.col property="person.nation.name" title="民族"  width="70px"/]
        [@b.col property="person.politicalStatus.name" title="政治面貌"  width="100px"/]
        [@b.col property="studyType.name" title="学习形式" width="80px"/]
        [@b.col property="beginOn" title="入学年月" width="60px"]${(student.beginOn?string("yyyy-MM"))!}[/@]
      [/@]
    [/@]
[@b.foot/]

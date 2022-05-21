[#ftl]
<br/>
<table style="width:95%" align="center" class="infoTable" id="studentInfoTb">
    <tr>
        <td colspan="5" style="font-weight:bold;text-align:center" class="darkColumn">学籍信息</td>
    </tr>
    <tr>
        <td width="25%" class="title"${titleTdHTML}>学号：</td>
        <td width="25%">${(student.user.code)!}</td>
        <td width="25%" class="title"${titleTdHTML}>姓名：</td>
        <td>${(student.user.name)!}</td>
        <td width="11%" rowspan="5" id='photoImg'>[@eams.avatar  width="80px" height="110px" user=student.user/]</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>英文名：</td>
        <td>${(student.enName)!}</td>
        <td class="title"${titleTdHTML}>性别：</td>
        <td>${(student.person.gender.name)!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>所在年级：</td>
        <td>${(student.state.grade)!}</td>
        <td class="title"${titleTdHTML}>学制：</td>
        <td>${(student.duration)!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>项目：</td>
        <td>${(student.project.name)!}</td>
        <td class="title"${titleTdHTML}>培养层次：</td>
        <td>${(student.level.name)!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>学生类别：</td>
        <td>${(student.stdType.name)!}</td>
        <td class="title"${titleTdHTML}>院系：</td>
        <td>${(student.state.department.name)!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>专业：</td>
        <td>${(student.state.major.name)!}</td>
        <td class="title"${titleTdHTML}>方向：</td>
        <td>${(student.state.direction.name)!}</td>
    </tr>
    <tr>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>入校时间：</td>
        <td>${((student.beginOn)?string("yyyy-MM-dd"))!}</td>
        <td class="title"${titleTdHTML}>应毕业时间：</td>
        <td>${((student.endOn)?string("yyyy-MM-dd"))!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>行政管理院系：</td>
        <td>${(student.state.department.name)!}</td>
        <td class="title"${titleTdHTML}>学习形式：</td>
        <td>${(student.studyType.name)!}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>是否在籍：</td>
        <td>${active?string("是", "否")}</td>
        <td class="title"${titleTdHTML}>是否在校：</td>
        <td>${inSchool?string("是", "否")}</td>
    </tr>
    <tr>
      <td class="title"${titleTdHTML}>行政班级：</td>
        <td>${(student.state.squad.name)!}</td>
        <td class="title"${titleTdHTML}>所属校区：</td>
        <td>${(student.state.campus.name)!}</td>
    </tr>
    <tr>
        <td class="title"${titleTdHTML}>备注：</td>
        <td colspan="3">${(student.remark)!}</td>
    </tr>
</table>

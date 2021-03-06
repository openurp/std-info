[#ftl]
  [#-- 这里是查看，或没有权限维护时进入的地方 --]
  <table class="infoTable" align="center" width="100%">
    <tr>
      <td class="title" width="10%">学号：</td>
      <td width="23%">${student.user.code}[#if !student.registed]<sup>无学籍</sup>[/#if] ${student.user.name}</td>
      <td class="title" width="10%">学生类别：</td>
      <td width="23%">${(student.stdType.name)!}</td>
      <td rowspan="5" colspan="2"><img width="80px" height="110px" src="${avatarUrl}" alt="${(student.user.name)!}" title="${(student.user.name)!}"/></td>
    </tr>
    <tr>
      <td class="title">年级：</td>
      <td>${(student.state.grade)!}</td>
      <td class="title">培养层次：</td>
      <td>${(student.level.name)!}</td>
    </tr>
    <tr>
      <td class="title">学制：</td>
      <td>${student.duration}</td>
      <td class="title">管理院系：</td>
      <td>${(student.state.department.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">专业：</td>
      <td>${(student.state.major.name)?if_exists} ${(student.state.direction.name)?if_exists}</td>
      <td class="title">行政班：</td>
      <td>${(student.state.squad.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">校区：</td>
      <td>${(student.state.campus.name)?if_exists}</td>
      <td class="title">学籍状态：</td>
      <td>${(student.state.status.name)?if_exists}</td>
    </tr>
    <tr>
      <td class="title">学籍有效日期：</td>
      <td>${(student.beginOn?string("yyyy-MM-dd"))!} ${(student.endOn?string("yyyy-MM-dd"))!}</td>
      <td class="title">是否在校：</td>
      <td>${(student.state.inschool?string("是", "否"))!}</td>
    </tr>
    <tr>
      <td class="title">入学-毕业日期：</td>
      <td>${(student.studyOn?string("yyyy-MM-dd"))!}入学  [#if (graduation.graduateOn)??]${graduation.graduateOn?string('yyyy-MM-dd')}毕业[#else]${(student.graduateOn?string("yyyy-MM-dd"))!}预计毕业[/#if]</td>
      <td class="title" style="vertical-align: top; padding-top: 4px">分类标签：</td>
      <td style="padding-top: 0px; padding-bottom: 0px; padding-left: 0px; padding-right: 0px">
        [#if 0 != student.labels?values?size]
        <table class="blue infoTable">
          [#list student.labels?values?sort_by([ "labelType", "name" ]) as label]
          <tr>
            <td class="title" style="width: 20%">${label.labelType.name}：</td>
            <td>${label.name}</td>
          </tr>
          [/#list]
        </table>
        [/#if]
      </td>
    </tr>
    <tr>
      <td class="title">学习形式：</td>
      <td>${(student.studyType.name)!}</td>
      <td class="title">[#if student.tutor??]导师[#else]班主任[/#if]：</td>
      <td>[#if student.tutor??]${(student.tutor.name)!}[#else]${(student.state.squad.instructor.name)!}[/#if]</td>
      [#if student??]
      <td class="title">最近维护时间：</td>
      <td>${student.updatedAt?string("yyyy-MM-dd")}</td>
      [#else]
      <td class="title"></td>
      <td></td>
      [/#if]
    </tr>
    <tr>
      <td class="title">备注：</td>
      <td colspan="5">${(student.remark?html)!}</td>
    </tr>
  </table>
  [#-- 学籍状态日志 --]
  [#if student.states?size>1]
  <div style="height: 5px"></div>
  <table class="list infoTable">
    <thead>
      <tr>
        <th>年级</th>
        <th>院系</th>
        <th width="15%">专业</th>
        <th width="18%">行政班</th>
        <th width="6%">是否在校</th>
        <th width="6%">状态</th>
        <th>校区</th>
        <th width="15%">有效期限</th>
        <th>备注</th>
      </tr>
    </thead>
    <tbody>
      [#list student.states?sort_by("beginOn")?reverse as hisState]
      <tr[#if (hisState.id!0) == student.state.id] class="red"[/#if] style="text-align:center">
        <td>${hisState.grade}</td>
        <td>${hisState.department.name}</td>
        <td>${(hisState.major.name)?if_exists} ${(hisState.direction.name)!}</td>
        <td>${(hisState.squad.shortName)?default((hisState.squad.name)!)}</td>
        <td>${hisState.inschool?string("是", "否")}</td>
        <td>${hisState.status.name}</td>
        <td>${(hisState.campus.name)!}</td>
        <td>${hisState.beginOn?string("yyyy-MM-dd")}~${(hisState.endOn?string("yyyy-MM-dd"))!}</td>
        <td>${(hisState.remark?html)!}</td>
      </tr>
      [/#list]
    </tbody>
  </table>
  [/#if]

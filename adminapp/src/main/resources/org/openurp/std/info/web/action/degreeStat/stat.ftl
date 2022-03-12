[#ftl]
<style>
.usst {
  height: 100%;
  font-family: 宋体;
  font-size: 14pt;
  text-align: center;
}

.usst > .title1 {
  width: 100%;
  height: 78px;
  padding-top: calc((78px - 14pt) / 2);
  font-weight: bold;
}
.usst > .title2 {
  width: 100%;
  height: 25px;
}
.usst > .title3 {
  width: 100%;
  height: 53px;
  padding-top: calc((53px - 14pt) / 2);
}

.usst > table.listTable1 {
  border-collapse: collapse;
  border-style:solid;
  border-width:1px;
  border-color:#006CB2;
  vertical-align: middle;
  font-style: normal;
}
.usst > table.listTable1 tr:first-child {
  height: 44px;
  font-weight: bold;
}
.usst > table.listTable1 tr {
  height: 33px;
}
.usst > table.listTable1 tr > td {
  border-style:solid;
  border-width:1px;
  border-color:#006CB2;
  padding: 0px;
}

.usst > table.listTable2 {
  border-collapse: collapse;
  border-style:solid;
  border-width:1px;
  border-color:#006CB2;
  vertical-align: middle;
  font-style: normal;
}
.usst > table.listTable2 tr:first-child {
  font-weight: bold;
}
.usst > table.listTable2 tr:last-child {
  font-weight: bold;
}
.usst > table.listTable2 tr {
  height: 25px;
}
.usst > table.listTable2 tr > td {
  border-style:solid;
  border-width:1px;
  border-color:#006CB2;
  padding: 0px;
}
.usst > table.listTable2 tr > td.eduSpan2 {
  font-weight: bold;
  vertical-align: middle;
}
.usst > table.listTable2 tr > td.major2 {
  text-align: start;
  vertical-align: middle;
}

.usst > table.listTable3 {
  border-collapse: collapse;
  border-style:solid;
  border-width:1px;
  border-color:#006CB2;
  vertical-align: middle;
  font-style: normal;
}
.usst > table.listTable3 tr:first-child {
  height: 34px;
  font-weight: bold;
}
.usst > table.listTable3 tr {
  height: 25px;
}
.usst > table.listTable3 tr > td {
  border-style:solid;
  border-width:1px;
  border-color:#006CB2;
  padding: 0px;
}
.usst > table.listTable3 tr > td.department3 {
  font-weight: bold;
  vertical-align: middle;
}
.usst > table.listTable3 tr > td.eduSpan3 {
  font-weight: bold;
  vertical-align: middle;
}
</style>
<div class="usst">
  <div class="title1">${degreeAwardOn?string('yyyy年MM月dd日')}学位授予数据汇总</div>
  <table class="listTable1" align="center">
    <tr>
      <td width="57px">序号</td>
      <td width="208px">院系</td>
      [#list educationLevels?sort_by("code") as eduSpan]
      <td width="88px">${eduSpan.name}</td>
      [/#list]
      <td width="72px">小计</td>
    </tr>[#assign results1 = graduationStatHelper.dataByDepartmentEducationLevel(educationLevels, graduationStats)/][#assign seqNo1 = 1/]
    [#list departments?sort_by("code") as department]
      [#if results1[department.id?string]??]
    <tr>
      <td>${seqNo1}[#assign seqNo1 = seqNo1 + 1/]</td>
      <td>${department.name}</td>[#assign sum = 0/]
        [#list educationLevels?sort_by("code") as eduSpan]
      <td>[#assign graduationStats1 = (results1[department.id?string][eduSpan.id?string])?default([])/][#assign amount = 0/][#list graduationStats1 as enrollStat][#assign amount = amount + enrollStat.count/][/#list][#if amount gt 0]${amount}[/#if][#assign sum = sum + amount/]</td>
        [/#list]
      <td>${sum}</td>
    </tr>
      [/#if]
    [/#list]
  </table>
  <div style='PAGE-BREAK-AFTER: always'></div>
  <div class="title2">${degreeAwardOn?string('yyyy年MM月dd日')}学位授予专业数据汇总</div>
  <table class="listTable2" align="center">
    <tr>
      <td width="108px">层次</td>
      <td width="57px">序号</td>
      <td width="148px">教育部专业代码</td>
      <td width="294px">专业</td>
      <td width="184px">人数</td>
    </tr>[#assign results2 = graduationStatHelper.dataByEducationLevelMajor(graduationStats)/][#assign sum = 0/]
    [#list educationLevels?sort_by("code") as eduSpan]
      [#assign byMajorMap2 = (results2[eduSpan.id?string])?default({})/]
      [#if byMajorMap2?keys?size gt 0]
        [#list byMajorMap2?keys as majorId]
    <tr>
          [#if majorId_index == 0]
      <td class="eduSpan2"[#if byMajorMap2?keys?size gt 1] rowspan="${byMajorMap2?keys?size}"[/#if]>${eduSpan.name}</td>
          [/#if]
      <td>${majorId_index + 1}</td>
      <td>${desciplineHelper.getDisciplineCode(majorMap[majorId])}</td>
      <td class="major2">${majorMap[majorId].name}</td>[#assign byMales2 = (byMajorMap2[majorId]["1"])?default([])/][#assign byFemales2 = (byMajorMap2[majorId]["2"])?default([])/][#assign maleAmount = 0/][#assign femaleAmount = 0/][#list byMales2 as male][#assign maleAmount = maleAmount + male.count/][/#list][#list byFemales2 as female][#assign femaleAmount = femaleAmount + female.count/][/#list]
      <td>${maleAmount + femaleAmount}（女${femaleAmount}）</td>[#assign sum = sum + maleAmount + femaleAmount/]
    </tr>
        [/#list]
      [/#if]
    [/#list]
    <tr>
      <td colspan="4">合计</td>
      <td>${sum}</td>
    </tr>
  </table>
  <div style='PAGE-BREAK-AFTER: always'></div>
  <div class="title3">${degreeAwardOn?string('yyyy年MM月dd日')}各层次专业学位授予数据</div>
  <table class="listTable3" align="center">
    <tr>
      <td width="172px">院系</td>
      <td width="101px">学生类别</td>
      <td width="217px">专业</td>
      <td width="101px">录取人数</td>
    </tr>[#assign results3 = graduationStatHelper.dataByDepartmentEducationLevel(graduationStats)/]
    [#list departments?sort_by("code") as department]
      [#assign byEducationLevelMap3 = (results3[department.id?string])?default({})/]
      [#list byEducationLevelMap3?keys as eduSpanId]
        [#assign byMajors3 = byEducationLevelMap3[eduSpanId]?default({})/]
        [#list byMajors3?keys as majorId]
    <tr>
          [#if majorId_index == 0]
            [#if eduSpanId_index == 0]
              [#assign dRowSpan = 0/][#list byEducationLevelMap3?keys as eduSpanId2][#assign dRowSpan = dRowSpan + byEducationLevelMap3[eduSpanId2]?keys?size/][/#list]
      <td class="department3"[#if dRowSpan gt 1] rowspan="${dRowSpan}"[/#if]>${department.name}</td>
            [/#if]
      <td class="eduSpan3"[#if byMajors3?keys?size gt 1] rowspan="${byMajors3?keys?size}"[/#if]>${educationLevelMap[eduSpanId].name}</td>
          [/#if]
      <td>${majorMap[majorId].name}</td>[#assign sum = 0/][#list byMajors3[majorId] as enrollStat][#assign sum = sum + enrollStat.count/][/#list]
      <td>${sum}</td>
    </tr>
        [/#list]
      [/#list]
    [/#list]
  </table>
</div>

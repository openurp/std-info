[#ftl]
<div class="stat_report">
  <div class="title">${season.name}院系毕业数据汇总</div>
  <table class="listTable" align="center">
    <tr>
      <td width="57px">序号</td>
      <td>院系</td>
      [#list educationLevels?sort_by("code") as eduSpan]
      <td width="88px">${eduSpan.name}</td>
      [/#list]
      <td width="72px">小计</td>
    </tr>[#assign results1 = graduateStatHelper.dataByDepartmentEducationLevel2(educationLevels, graduateStats)/][#assign seqNo1 = 1/]
    [#list departments?sort_by("code") as department]
      [#if results1[department.id?string]??]
    <tr>
      <td>${seqNo1}[#assign seqNo1 = seqNo1 + 1/]</td>
      <td>${department.name}</td>[#assign sum = 0/]
        [#list educationLevels?sort_by("code") as eduSpan]
      <td>[#assign graduateStats1 = (results1[department.id?string][eduSpan.id?string])?default([])/][#assign amount = 0/][#list graduateStats1 as enrollStat][#assign amount = amount + enrollStat.count/][/#list][#if amount gt 0]${amount}[/#if][#assign sum = sum + amount/]</td>
        [/#list]
      <td>${sum}</td>
    </tr>
      [/#if]
    [/#list]
  </table>

  <div class="title">${season.name}专业毕业数据汇总</div>
  <table class="listTable" align="center">
    <tr>
      <td width="108px">层次</td>
      <td width="57px">序号</td>
      <td width="148px">教育部专业代码</td>
      <td>专业</td>
      <td width="184px">人数</td>
    </tr>[#assign results2 = graduateStatHelper.dataByEducationLevelMajor(graduateStats)/][#assign sum = 0/]
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

<div class="title">${season.name}层次专业毕业数据</div>
  <table class="listTable" align="center">
    <tr>
      <td width="172px">院系</td>
      <td width="101px">培养层次</td>
      <td>专业</td>
      <td width="101px">人数</td>
    </tr>[#assign results3 = graduateStatHelper.dataByDepartmentEducationLevel(graduateStats)/]
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

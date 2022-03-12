[#ftl]
[#assign personResitricts = (propertyMetaMap[personMeta])?if_exists/]
[#if !((student.person.id)??)]
<div style="color: red">当前学生基本信息还未配置！</div>
[/#if]
[#assign isOpen = personResitricts?size gt 0/]
[#if isOpen]
  [@b.form name="personForm" action="student!savePerson.action" theme="list" target="_self"]
    [#if isOpen]
    <input type="hidden" name="student.id" value="${(student.id)!}"/>
    <input type="hidden" name="student.person.id" value="${(student.person.id)!}"/>
    [/#if]
    [#if personResitricts?seq_contains("formatedName") || isOpen && !((student.user.name)??)]
      [@b.textfield label="姓名" name="student.user.name" required="true" value=(student.user.name)! maxlength="100" style="width: 200px"/]
    [#else]
      [@b.field label="姓名"]${(student.user.name)!"<br>"}[/@]
    [/#if]
    [#if personResitricts?seq_contains("phoneticName")]
      [@b.textfield label="英文名" name="student.person.phoneticName" value=(student.person.phoneticName)! maxlength="100" style="width: 200px"/]
    [#else]
      [@b.field label="英文名"]${(student.person.phoneticName)!"<br>"}[/@]
    [/#if]
    [#if personResitricts?seq_contains("formerName")]
      [@b.textfield label="曾用名" name="student.person.formerName" value=(student.person.formerName)! maxlength="100" style="width: 200px"/]
    [#else]
      [@b.field label="曾用名"]${(student.person.formerName)!"<br>"}[/@]
    [/#if]
    [#if personResitricts?seq_contains("gender") || isOpen && !((student.user.name)??)]
      [@b.select label="性别" name="student.person.gender.id" items=genders empty="..." required="true" value=(student.person.gender.id)! style="width: 200px"/]
    [#else]
      [@b.field label="性别"][@i18nName (student.person.gender)!/][/@]
    [/#if]
    [#if personResitricts?seq_contains("birthday")]
      [@b.datepicker label="出生年月" name="student.person.birthday" format="yyyy-MM-dd" readonly="readonly" value=((student.person.birthday)?string("yyyy-MM-dd"))! style="width: 200px"/]
    [#else]
      [@b.field label="出生年月"]${((student.person.birthday)?string("yyyy-MM-dd"))!}[/@]
    [/#if]
    [#if personResitricts?seq_contains("idType")]
      [@b.select label="证件类型" name="student.person.idType.id" items=idTypes empty="..." value=(student.person.idType.id)! style="width: 200px"/]
    [#else]
      [@b.field label="证件类型"][@i18nName (student.person.idType)!/][/@]
    [/#if]
    [#if personResitricts?seq_contains("code") || isOpen && !((student.person.code)??)]
      [@b.textfield label="证件号码" name="student.person.code" required="true" value=(student.person.code)! maxlength="32" style="width: 200px"/]
    [#else]
      [@b.field label="证件号码"]${(student.person.code)!"<br>"}[/@]
    [/#if]
    [#if personResitricts?seq_contains("country")]
      [@b.select label="国家地区" name="student.person.country.id" items=countries empty="..." value=(student.person.country.id)! style="width: 200px"/]
    [#else]
      [@b.field label="国家地区"][#if (student.person.country)??][@i18nName (student.person.country)!/][#else]<br>[/#if][/@]
    [/#if]
    [#if personResitricts?seq_contains("nation")]
      [@b.select label="民族" name="student.person.nation.id" items=nations empty="..." value=(student.person.nation.id)! style="width: 200px"/]
    [#else]
      [@b.field label="民族"][#if (student.person.nation)??][@i18nName (student.person.nation)!/][#else]<br>[/#if][/@]
    [/#if]
    [#if personResitricts?seq_contains("homeTown")]
      [@b.textfield label="籍贯" name="student.person.homeTown" value=(student.person.homeTown)! maxlength="100" style="width: 200px"/]
    [#else]
      [@b.field label="籍贯"]${(student.person.homeTown)!"<br>"}[/@]
    [/#if]
    [@b.formfoot]
      [@b.submit value="保存"/]
      <input type="hidden" name="defaultTab" value="tab2"/>
    [/@]
  [/@]
[#else]
  <table class="infoTable">
    <tr>
      <td class="title" width="10%">姓名：</td>
      <td width="23%">${student.user.name?html}</td>
      <td class="title" width="10%">英文名：</td>
      <td width="23%">${(student.person.phoneticName?html)!}</td>
      <td class="title" width="10%">曾用名：</td>
      <td>${(student.person.formerName?html)!}</td>
    </tr>
    <tr>
      <td class="title">国家地区：</td>
      <td>[@i18nName (student.person.country)!/]</td>
      <td class="title">性别：</td>
      <td>[@i18nName (student.person.gender)!/]</td>
      <td class="title">出生年月：</td>
      <td>${((student.person.birthday)?string("yyyy-MM-dd"))!}</td>
    </tr>
    <tr>
      <td class="title">民族：</td>
      <td>[@i18nName (student.person.nation)!/]</td>
      <td class="title">证件类型：</td>
      <td>[@i18nName (student.person.idType)!/]</td>
      <td class="title">证件号码：</td>
      <td>${(student.person.code)!"<br>"}</td>
    </tr>
    <tr>
      <td class="title">籍贯：</td>
      <td>${((student.person.homeTown?html))!}</td>
      [#if (student.person)??]
      <td class="title">最近维护时间：</td>
      <td>${(student.person.updatedAt?string("yyyy-MM-dd HH:mm:ss"))!}</td>
      [#else]
      <td class="title"></td>
      <td></td>
      [/#if]
      <td class="title"></td>
      <td></td>
    </tr>
  </table>
[/#if]

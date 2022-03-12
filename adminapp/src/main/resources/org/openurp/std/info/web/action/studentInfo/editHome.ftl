[#ftl]
[@b.head]
<link rel="stylesheet" type="text/css" href="${base}/static/scripts/commons/css/common.css">
<script src="${base}/static/scripts/common.js?v=2"></script>
[/@]

[@b.toolbar title='学生家庭信息维护']
     bar.addBackOrClose();
[/@]
[@b.messages slash = "7"/]

[#if !((student.person.id)??)]
<div style="color: red">请先配置<span style="font-weight: bold">学生基本信息</span>！</div>
[/#if]
<div class="container">
  [@b.form name="studentForm" action="!saveHome" target="_self"]
    <input type="hidden" name="home.id" value="${(home.id)!}"/>
    <input type="hidden" name="student.id" value="${(student.id)!}"/>

    [#if restriction??]
      [#assign hasHome=false/]

      [#list restriction.metas as meta]
        [#if !hasHome][#assign hasHome = (meta.name == homeMeta)/][/#if]
      [/#list]
    [/#if]


<div class="card card-primary card-outline">
[#--  <div class="card-header">--]
[#--    <h3 class="card-title">学生家庭信息</h3>--]
[#--  </div>--]
  <div class="card-body">
      [@b.fieldset theme="list"]
      [#if hasHome?? && hasHome]
        [@b.textfield label="家庭电话" name="home.phone" value=(home.phone)! maxlength="100" style="width: 200px" /]
        [@b.textarea label="家庭地址" name="home.address" value=(home.address)! maxlength="100" style="width: 200px"/]
        [@b.textfield label="家庭地址邮编" name="home.postcode" value=(home.postcode)! maxlength="6" style="width: 200px"/]
        [@b.textfield label="户籍" name="home.formerAddr" value=(home.formerAddr)! maxlength="100" style="width: 200px"/]
        [@b.textfield label="派出所" name="home.police" value=(home.police)! maxlength="100" style="width: 200px"/]
        [@b.textfield label="派出所电话" name="home.policePhone" value=(home.policePhone)! maxlength="100" style="width: 200px"/]
        [@b.select label="火车站" name="home.railwayStation.id" items=railwayStations empty="..." value=(home.railwayStation.id)! style="width: 200px"/]
      [#else]
    <h6 style="color:red ">没有修改权限,请先配置数据权限</h6>
        [@b.textfield label="家庭电话" name="home.phone" value=(home.phone)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textarea label="家庭地址" name="home.address" value=(home.address)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="家庭地址邮编" name="home.postcode" value=(home.postcode)! maxlength="6" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="户籍" name="home.formerAddr" value=(home.formerAddr)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="派出所" name="home.police" value=(home.police)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.textfield label="派出所电话" name="home.policePhone" value=(home.policePhone)! maxlength="100" style="width: 200px" disabled = "diaabled"/]
        [@b.select label="火车站" name="home.railwayStation.id" items=railwayStations empty="..." value=(home.railwayStation.id)! style="width: 200px" disabled = "diaabled"/]
      [/#if]
      [/@]
  </div>
</div>

    [@b.formfoot theme="list"]
      [@b.submit value="保存"/]
    [/@]
  [/@]
</div> <!--end container-->
[@b.foot/]

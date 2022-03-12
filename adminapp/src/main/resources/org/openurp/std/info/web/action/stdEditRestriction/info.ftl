[#ftl]
[@b.head/]
[@b.toolbar title="学生信息修改权限配置信息"]
  bar.addBack();
[/@]
[@b.tabs]
  [#assign rightMap = {}/]
  [#list stdEditRestrictions?if_exists as stdEditRestriction]
    [#list (stdEditRestriction.metas?sort_by(["meta", "id"]))?if_exists as meta]
      [#assign rights = rightMap[meta.meta.id + "_" + meta.meta.comments?html]?default([])/]
      [#assign rights = rights + [ meta.comments + "(" + meta.name + ")" ]/]
      [#assign rightMap = rightMap + { meta.meta.id + "_" + meta.meta.comments?html: rights }/]
    [/#list]
  [/#list]
  [#list rightMap?keys as tabLabel]
    [@b.tab label=tabLabel?split("_")?last?html]
      [#list rightMap[tabLabel] as right]
      <div style="padding-bottom: 5px">${right}</div>
      [/#list]
      [#--
      [@b.form theme="list" action="!index" title="组名：${(group.name)!}" name="backForm"]
        [#if (propertyMetaMap??)]
          [#list propertyMetaMap?keys as key]
            <li>
            <b>${(key.comments?html)!}：</b>
            <br/>
            <br/>
            [#list propertyMetaMap.get(key)?sort_by("name") as propertyMeta]
              [#if propertyMeta_index !=0]
                ,
              [/#if]
              ${(propertyMeta.comments?html)!}[${(propertyMeta.name?html)!}]
            [/#list]
            </li>
          [/#list]
        [#else]
          没有设置
        [/#if]
      [/@]
       --]
    [/@]
  [/#list]
[/@]
[@b.foot/]

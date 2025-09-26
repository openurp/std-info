[#ftl]
[@b.head/]
[#include "../nav.ftl"/]
  <style>
    .alert-success{
      color: #155724;
      background-color: #d4edda;
      border-color: #c3e6cb;
    }
  </style>
  [#macro displayCounter counter]
    [#if counter?? && counter?size>0]
    ${counter?first}[#if counter[1]>0]<span class="text-muted" style="font-size:0.8em;">(女${counter[1]})</span>[/#if]
    [/#if]
  [/#macro]

  [#macro displayMatrix dx dy dxLabel dyLabel]
    <table class="table table-bordered table-striped table-sm" style="text-align: center;">
      <caption style="text-align: center;caption-side: top;padding-bottom: 0.25rem;">按${dyLabel} ${dxLabel}分布</caption>
      <thead>
        <th width="15%">${dyLabel}</th>
        [#assign grades = matrix.getColumn(dx).values?keys?sort/]
        [#list grades as grade]
        <th>${matrix.getColumn(dx).values.get(grade).name}</th>
        [/#list]
        <td width="10%">合计</td>
      </thead>
      <tbody>
      [#assign lgmatrix = matrix.groupBy(dy+","+dx)/]
      [#assign lmatrix = matrix.groupBy(dy)/]
      [#assign gmatrix = matrix.groupBy(dx)/]
      [#assign rows=0/]
      [#assign dyValues = lgmatrix.getColumn(dy).values/]
      [#list dyValues?keys?sort as k]
      <tr>
        <td>[@b.a href="!index?${dy}.id=${k}"]${dyValues.get(k).name}[/@]</td>
        [#list grades as grade]
        <td>[@displayCounter lgmatrix.getCounter(k,grade)!/]</td>
        [/#list]
        <td>[@displayCounter lmatrix.getCounter(k)! /] </td>
      </tr>
      [#assign rows = rows + 1/]
      [/#list]

     [#if rows>1]
      <tr>
        <td>合计</td>
        [#list grades as g]
        <td>[@displayCounter gmatrix.getCounter(g)! /]</td>
        [/#list]
        <td>[@displayCounter gmatrix.sum /]</td>
      </tr>
      [/#if]
      </tbody>
    </table>
  [/#macro]
  <div class="container">
    [#if level?? || depart?? || stdType?? || eduType?? ||campus?? ]
    <div class="alert alert-success">
      在校学生分布：[#if level??]${level.name}[/#if]
       [#if depart??]${depart.name}[/#if]
       [#if stdType??]${stdType.name}[/#if]
       [#if eduType??]${eduType.name}[/#if]
       [#if campus??]${campus.name}[/#if]
    </div>
    [/#if]

    [@displayMatrix "grade" "level" "年级" "培养层次" /]
    [@displayMatrix "grade" "depart" "年级" "院系" /]
    [@displayMatrix "grade" "stdType" "年级" "学生类别" /]
    [@displayMatrix "grade" "eduType" "年级" "培养类型" /]
    [@displayMatrix "grade" "campus" "年级" "校区" /]
  </div>
[@b.foot/]

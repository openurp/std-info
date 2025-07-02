[#ftl]
[@b.head/]
[#include "../nav.ftl"/]
<div class="container">

  <table class="table table-bordered table-striped table-sm" style="text-align: center;">
    <thead>
      <tr>
        <th width="10%">序号</th>
        <th>入学日期</th>
        <th>人数</th>
        <th></th>
      </tr>
    </thead>

    <tbody>
    [#assign dates = datas?keys?sort?reverse/]
    [#list dates as beginOn]
      <tr>
       <td>${beginOn_index+1}</td>
       <td>${beginOn}</td>
       <td>${datas.get(beginOn)!}</td>
       <td>[@b.a href="!download?beginOn="+beginOn target="_blank"]<i class="fa-solid fa-file-excel"></i>下载[/@]</td>
     </tr>
     [/#list]
    </tbody>
  </table>

</div>

[@b.foot/]

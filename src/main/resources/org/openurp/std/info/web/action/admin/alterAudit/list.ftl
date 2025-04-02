[#ftl]
[@b.head/]
<style>
  .title{
    text-align:right;
  }

  .width15{
    width:15%;
  }
  @media (max-width:991.98px) {
    .table-sm td, .table-sm th{
      padding-right: 0rem;
      padding-left: 0rem;
    }
    .width15{
      width:inherit;
    }
  }
</style>

<div class="container">
  [#assign searchFormName]searchForm${active}[/#assign]
  [@b.form name=searchFormName action="!search"]
    <div class="input-group input-group-sm">
      <input class="form-control form-control-navbar" type="search" name="stdCodeName" value="${Parameters['stdCodeName']!}"
       aria-label="Search" placeholder="学号或姓名" autofocus="autofocus">
      [#list Parameters?keys as k]
       [#if k != 'stdCodeName']
      <input type="hidden" name="${k}" value="${Parameters[k]?html}"/>
      [/#if]
      [/#list]
      <div class="input-group-append">
        <button class="input-group-text" type="submit" onclick="bg.form.submit(document.${searchFormName});return false;">
          <i class="fas fa-search"></i>
        </button>
      </div>
    </div>
  [/@]
  [#if stdAlterApplies?size>0]
    [#list stdAlterApplies as apply]
      [#include "alter-card.ftl"/]
    [/#list]
  [#else]
    <p>没有异动数据</p>
  [/#if]
  <nav aria-label="Page navigation example">
   <ul class="pagination float-right">
     [#if stdAlterApplies.pageIndex > 1]
     <li class="page-item"><a class="page-link" href="#" onclick="listApply(1)">首页</a></li>
     <li class="page-item"><a class="page-link" href="#" onclick="listApply(${stdAlterApplies.pageIndex-1})">${stdAlterApplies.pageIndex-1}</a></li>
     [/#if]
     <li class="page-item active"><a class="page-link" href="#" >${stdAlterApplies.pageIndex}</a></li>
     [#if stdAlterApplies.pageIndex < stdAlterApplies.totalPages]
     <li class="page-item"><a class="page-link" href="#" onclick="listApply(${stdAlterApplies.pageIndex+1})">${stdAlterApplies.pageIndex+1}</a></li>
     <li class="page-item"><a class="page-link" href="#" onclick="listApply(${stdAlterApplies.totalPages})">末页</a></li>
     [/#if]
   </ul>
  </nav>
  <script>
   function listApply(pageIndex){
      bg.form.addInput(document.${searchFormName},"pageIndex",pageIndex);
      bg.form.submit(document.${searchFormName});
   }
  </script>
</div>

[@b.foot/]

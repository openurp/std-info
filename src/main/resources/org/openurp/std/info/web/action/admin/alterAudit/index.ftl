[#ftl]
[@b.head/]
[#include "../alterApply/alter-nav.ftl"/]
<div class="container-fluid">
  <nav class="navbar navbar-default" role="navigation">
    <div class="container-fluid">
      <div class="navbar-header">
        <a class="navbar-brand" href="#"><i class="fas fa-graduation-cap"></i>学籍异动审批</a>
      </div>
    </div>
  </nav>
  [@b.tabs class="nav-tabs nav-tabs-compact"]
    [@b.tab label="待审批"]
      [@b.div href="!search?orderBy=stdAlterApply.applyAt desc"/]
    [/@]
    [@b.tab label="已审批"]
      [@b.div href="!search?active=0&orderBy=stdAlterApply.applyAt desc" /]
    [/@]
  [/@]
</div>
[@b.foot/]

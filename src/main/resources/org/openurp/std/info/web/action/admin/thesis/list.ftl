[@b.grid items=theses var="thesis"]
  [@b.gridbar]
    bar.addItem("导入论文信息",action.method('importForm'));
  [/@]
  [@b.row]
    [@b.boxcol/]
    [@b.col property="std.code"  title="学号" width="100px"/]
    [@b.col property="std.name"  title="姓名" width="100px"/]
    [@b.col property="title" title="题目"]
      <div class="text-ellipsis" title="${(thesis.title)!}">${(thesis.title)!}</div>
    [/@]
    [@b.col property="advisor" title="指导老师" width="80px"/]
    [@b.col property="researchField" title="研究方向" width="100px"]
      <div class="text-ellipsis" title="${(thesis.researchField)!}">${thesis.researchField!}</div>
    [/@]
    [@b.col property="keywords" title="关键词" width="200px"]
      <div class="text-ellipsis" title="${(thesis.keywords)!}">${(thesis.keywords)!}</div>
    [/@]
    [@b.col property="language.name" title="撰写语言" width="60px"/]
    [@b.col property="scoreText" title="成绩" width="60px"/]
  [/@]
[/@]

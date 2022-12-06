[#ftl]
[@b.head/]
[@b.grid items=majorStudents var="majorStudent"]
  [@b.gridbar]
    bar.addItem("${b.text("action.new")}",action.add());
    bar.addItem("${b.text("action.modify")}",action.edit());
    bar.addItem("${b.text("action.delete")}",action.remove("确认删除?"));
    bar.addItem("导入",action.method('importForm'));
  [/@]
  [@b.row]
    [@b.boxcol /]
    [@b.col width="10%" property="std.code" title="学号"/]
    [@b.col width="10%" property="std.name" title="姓名"][@b.a href="!info?id=${majorStudent.id}"]${majorStudent.std.name}[/@][/@]
    [@b.col width="10%" property="code" title="主修学号"/]
    [@b.col width="18%" property="school.name" title="主修学校"/]
    [@b.col width="15%" property="majorName" title="主修专业"/]
    [@b.col width="22%" property="enMajorName" title="主修专业英文名"/]
    [@b.col width="10%" property="majorCategory.name" title="学科门类"/]
  [/@]
  [/@]
[@b.foot/]

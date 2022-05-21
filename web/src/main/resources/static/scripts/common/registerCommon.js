function selectedId(id, form, idName) {
  var modelId = bg.input.getCheckBoxValues(id);
  if (modelId == "" || modelId.indexOf(",") != -1) {
    alert("请选择一项数据进行操作!");
    return false;
  }
  if (null != form) {
    if (null == idName) {
      bg.form.addInput(form, id, modelId);
    } else {
      bg.form.addInput(form, idName, modelId);
    }
  }
  return true;
}

function selectedIds(ids, form, idsName) {
  var modelIds = bg.input.getCheckBoxValues(ids);
  if (modelIds == "") {
    alert("请选择数据进行操作!");
    return false;
  }
  if (null != form) {
    if (null == idsName) {
      bg.form.addInput(form, ids, modelIds);
    } else {
      bg.form.addInput(form, idsName, modelIds);
    }
  }
  return true;
}

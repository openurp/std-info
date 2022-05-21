//jQuery needed
var msg = "";
function setEditable(canEdit) {
  $("input,select").not(":hidden").prop("disabled",true);
  canEdit.prop("disabled",false);
}

function setHintForNotEditable(notEditable) {
  notEditable.after($("<div></div>").css("color","red").html(msg));
}

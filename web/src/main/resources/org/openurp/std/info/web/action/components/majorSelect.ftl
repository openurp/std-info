<script type='text/javascript' src='${base}/dwr/interface/departmentDwrService.js'></script>

<script>
var majorId = "major.id";

function initMajor(departmentId)
  {
    dwr.util.removeAllOptions(majorId);
    dwr.util.addOptions(majorId,[{'id':'','name':'...'}],'id','name');
    if(departmentId!='')
    {
      dwr.engine.setAsync(false);
      departmentDwrService.getMajor(departmentId,null,setMajor);
      dwr.engine.setAsync(true);
    }
  }

  function setMajor(data)
  {
        for(i=0;i<data.length;i++) {
             dwr.util.addOptions(majorId,[{'id':data[i].id,'name':data[i].name+'['+data[i].code+']'}],'id','name');
    }
  }

</script>

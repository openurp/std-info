[#ftl]
[#macro majorSelect id extra...]
    <input id="${id}project" type="hidden" name="${extra['projectId']!'project.id'}" value="${projectContext.project.id}"/>
    <td align="right">${b.text("entity.EducationLevel")}:</td>
    <td>
      <select id="${id}level"  name="${extra['levelId']!'level.id'}" style="width:120px;">
        <option value="">${b.text("filed.choose")}...</option>
      </select>
    </td>

    <td align="right">${b.text("entity.studentType")}:</td>
    <td>
      <select id="${id}stdType" name="${extra['typeId']!'student.stdType.id'}" style="width:120px;">
        <option value="">${b.text("filed.choose")}...</option>
      </select>
    </td>

    <td align="right">${b.text("common.college")}:</td>
    <td>
      <select id="${id}department" name="${extra['departId']}" style="width:120px;">
        <option value="">${b.text("filed.choose")}...</option>
      </select>
    </td>

    <td align="right">${b.text("entity.major")}:</td>
    <td>
      <select id="${id}major" name="${extra['majorId']}" style="width:120px;">
        <option value="">${b.text("filed.choose")}...</option>
      </select>
    </td>
<script src='${base}/dwr/engine.js'></script>
<script src='${base}/static/scripts/dwr/util.js'></script>
  <script src='${base}/dwr/interface/projectMajorDwr.js'></script>
  <script src='${base}/static/scripts/common/majorSelect.js?v=201811'></script>
  <script type="text/javascript">
    var m3s=new Major3Select("${id}project","${id}level",[#if extra['stdTypeId']??]"${id}stdType"[#else]null[/#if],"${id}department",[#if extra['majorId']??]"${id}major"[#else]null[/#if],"",true,true,true,false);
    m3s.displayCode=false;
    m3s.init([ { "id": "${projectContext.project.id}", "name": "" }, "${request.getServletPath()}" ]);
  </script>
[/#macro]

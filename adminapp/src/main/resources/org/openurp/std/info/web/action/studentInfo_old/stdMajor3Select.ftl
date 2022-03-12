<#assign redStatHTML><font color="red">*</font></#assign>
<#macro majorSelect id projects extra...>

    <tr>
       <td class="title">${redStatHTML}项目：</td>
       <td>
        <select id="${id}project" title="项目" name="${extra['projectId']!'project.id'}" style="width:156px;">
          <option value="">${b.text("filed.choose")}...</option>
        </select>
         </td>
       <td class="title">${redStatHTML}${b.text("entity.EducationLevel")}：</td>
       <td>
        <select id="${id}level" title="培养层次" name="${extra['levelId']!'level.id'}" style="width:156px;">
          <option value="">${b.text("filed.choose")}...</option>
        </select>
         </td>
       </tr>
       <tr>
       <td class="title">${redStatHTML}${b.text("entity.studentType")}：</td>
       <td>
            <select id="${id}stdType" title="学生类别" name="${extra['typeId']!'student.stdType.id'}" style="width:156px;">
            <option value="">${b.text("filed.choose")}...</option>
            </select>
         </td>
       <td class="title">${redStatHTML}${b.text("common.college")}：</td>
       <td>
           <select id="${id}department" title="院系" name="student.state.department.id" style="width:156px;">
             <option value="">${b.text("filed.choose")}...</option>
           </select>
         </td>
        </tr>
     <tr>
       <td class="title">${redStatHTML}${b.text("entity.major")}：</td>
       <td>
           <select id="${id}major" title="专业" name="${extra['majorId']}" style="width:156px;">
             <option value="">${b.text("filed.choose")}...</option>
           </select>
         </td>
       <td class="title">${b.text("entity.direction")}：</td>
       <td>
           <select id="${id}direction" name="${extra['directionId']}" style="width:156px;">
             <option value="">${b.text("filed.choose")}...</option>
           </select>
         </td>
        </tr>
<script src='${base}/dwr/interface/projectMajorDwr.js'></script>
<script src='${base}/dwr/engine.js'></script>
<script src='${base}/static/scripts/dwr/util.js'></script>
<script src='${base}/static/scripts/common/majorSelect.js?v=201811'></script>
<script>
    var projectArray = new Array();
    <#list projects as project>
    projectArray[${project_index}]={'id':'${project.id}','name':'${project.name}'};
    </#list>
    var sds = new Major3Select("${id}project","${id}level",<#if extra['stdTypeId']??>"${id}stdType"<#else>null</#if>,"${id}department",<#if extra['majorId']??>"${id}major"<#else>null</#if>,<#if extra['directionId']??>"${id}direction"<#else>null</#if>,true,true,true,true);
    sds.init(projectArray, '${request.getServletPath()}');
</script>
</#macro>

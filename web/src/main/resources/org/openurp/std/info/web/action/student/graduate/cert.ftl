  [#if cert == "degree"]
    [@include_optional path="/org/openurp/std/info/web/components/${student.project.id}/cert_degree_en.ftl"]
      missing /org/openurp/std/info/web/components/${student.project.id}/cert_degree_en.ftl
    [/@]
  [#else]
    [@include_optional path="/org/openurp/std/info/web/components/${student.project.id}/cert_graduate_en.ftl"]
      missing /org/openurp/std/info/web/components/${student.project.id}/cert_graduate_en.ftl
    [/@]
  [/#if]

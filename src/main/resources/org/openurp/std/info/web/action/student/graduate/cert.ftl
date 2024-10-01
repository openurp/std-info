  [#assign profile]/${student.project.school.id}/${student.project.id}[/#assign]
  [#if cert == "degree"]
    [@include_optional path="${profile}/org/openurp/std/info/web/components/cert_degree_en.ftl"]
      missing ${profile}/org/openurp/std/info/web/components/cert_degree_en.ftl
    [/@]
  [#else]
    [@include_optional path="${profile}/org/openurp/std/info/web/components/cert_graduate_en.ftl"]
      missing ${profile}/org/openurp/std/info/web/components/cert_graduate_en.ftl
    [/@]
  [/#if]

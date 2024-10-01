[#ftl/]
[#assign profile]/${student.project.school.id}/${student.project.id}[/#assign]
[@include_optional path="${profile}/org/openurp/std/info/web/components/certificate_en.ftl"]
  missing ${profile}/org/openurp/std/info/web/components/certificate_en.ftl
[/@]

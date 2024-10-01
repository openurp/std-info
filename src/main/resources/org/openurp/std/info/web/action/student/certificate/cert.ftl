[#assign profile]/${student.project.school.id}/${student.project.id}[/#assign]
[#if student.registed]
  [#if lang == "zh"]
    [@include_optional path="${profile}/org/openurp/std/info/web/components/certificate_zh.ftl"]
      missing ${profile}/org/openurp/std/info/web/components/certificate_zh.ftl
    [/@]
  [#else]
    [@include_optional path="${profile}/org/openurp/std/info/web/components/certificate_en.ftl"]
      missing ${profile}/org/openurp/std/info/web/components/certificate_en.ftl
    [/@]
  [/#if]
[#else]
  学生 ${student.name} 学号:${student.code},没有我校学籍，本学籍在读证明不适用。
[/#if]

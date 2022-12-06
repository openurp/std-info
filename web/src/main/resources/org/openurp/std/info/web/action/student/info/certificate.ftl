[#if student.registed]
  [#if lang == "zh"]
    [@include_if_exists path="/org/openurp/std/info/web/components/${student.project.id}/certificate_zh.ftl"]
      missing /org/openurp/std/info/web/components/${student.project.id}/certificate_zh.ftl
    [/@]
  [#else]
    [@include_if_exists path="/org/openurp/std/info/web/components/${student.project.id}/certificate_en.ftl"]
      missing /org/openurp/std/info/web/components/${student.project.id}/certificate_en.ftl
    [/@]
  [/#if]
[#else]
  学生 ${student.name} 学号:${student.code},没有我校学籍，本学籍在读证明不适用。
[/#if]

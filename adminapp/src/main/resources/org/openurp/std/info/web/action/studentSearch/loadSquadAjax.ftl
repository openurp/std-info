[#ftl]
{
  "squades": [ [#list (squades?sort_by("name"))?if_exists as squad]{ "id": "${squad.id}", "code": "${squad.code}", "name": "${squad.name}" }[/#list]],
  "isOver": ${("over" == caption!)?string}
}

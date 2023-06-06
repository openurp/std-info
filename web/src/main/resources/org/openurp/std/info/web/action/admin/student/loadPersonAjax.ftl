[#ftl]
[#if person??]
{
  "person": {
    "id": "${(person.id)!}",
    "formatedName": "${(user.name?js_string)!}",
    "phoneticName": "${(person.phoneticName?js_string)!}",
    "formerName": "${(person.formerName?js_string)!}",
    "gender": { "id": "${(person.gender.id)!}" },
    "birthday": "${(person.birthday?string("yyyy-MM-dd"))!}",
    "idType": { "id": "${(person.idType.id)!}" },
    "country": { "id": "${(person.country.id)!}" },
    "nation": { "id": "${(person.nation.id)!}" },
    "homeTown": "${(person.homeTown?js_string)!}"
  }
}
[#else]
{}
[/#if]

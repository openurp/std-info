[#ftl]
{
  "student": {
    "photo": "${eams.avatar_url(student.user)?js_string}",
    "code": "${student.user.code?js_string}",
    "person": {
      "formatedName": "${student.user.name?js_string}"
    },
    "user": {
      "name": "${student.user.name?js_string}",
      "code": "${student.user.code?js_string}"
    },
    "state": {
      "inschool": "${student.state.inschool?string("是", "否")}"
    },
    "registed": "${student.registed?string("是", "否")}"
  }
}

<!DOCTYPE html>
<html lang="zh_CN">
  <head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta http-equiv="pragma" content="no-cache"/>
    <meta http-equiv="cache-control" content="no-cache"/>
    <meta http-equiv="content-style-type" content="text/css"/>
    <meta http-equiv="content-script-type" content="text/javascript"/>
    <meta http-equiv="expires" content="0"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Login</title>
  </head>
  <body>
    <style>
      .certificate{
         width:290mm;
         height:210mm;
         background-image:url('${base_url}/static/images/certificate_minor_background.jpg');
         margin:auto;
         font-family:宋体;
         font-size:16pt;
         line-height: 3rem;
      }
      .content{
        padding-top: 75mm;
        padding-left: 40mm;
        padding-right: 40mm;
      }
      .sig{
        width: 40mm;
        height: 30mm;
        margin-left: 140mm;
        padding-top: 10mm;
      }
      .president{
        width: 40mm;
        margin-left: 140mm;
      }
      .certificate_no{
        display: inline;
      }
      .print_date{
        display: inline;
        float: right;
      }
      @page {
        size: a4 landscape;
      }
    </style>
    [#macro year y]
      [#local names=["零","一","二","三","四","五","六","七","八","九"]]
      [#list 0..y?length-1 as i]${names[y[i]?number?int]}[/#list][#t/]
    [/#macro]
    <div id="certificates">
      [#list graduates as graduate]
        [#assign std=graduate.std/]
        <div class="certificate">
          <div class="content">
            &nbsp;&nbsp;${std.name}，${std.gender.name}，${std.person.birthday?string('yyyy 年 MM 月 dd 日')}生。<br/>
            ${(majorStudents.get(std).school.name)!"主修学校"} ${(majorStudents.get(std).majorName)!"主修专业"} 专业学生。该生于${std.beginOn?string(" yyyy 年 MM 月 ")}至
            ${graduate.graduateOn?string(" yyyy 年 MM 月 ")}辅修我校 ${(std.major.name)!} 专业。成绩合格，经审核授予辅修专业证书。

            <div class="sig">学校盖章：</div>
            <div class="president">校&nbsp;&nbsp;长：${(president.name)!}</div>
            <div>
              <div class="certificate_no">&nbsp;&nbsp;证书编号：${graduate.certificateNo!}</div>
              [#assign y = graduate.graduateOn?string('yyyy')/]
              [#assign m = graduate.graduateOn?string('MM')/]
              [#assign d = graduate.graduateOn?string('dd')/]
              <div class="print_date">[@year y /] 年 ${hanZi.build(m?number?int)} 月 ${hanZi.build(d?number?int)} 日</div>
            </div>
          </div>
        </div>
         [#if  graduate_has_next]
         <div style='PAGE-BREAK-AFTER: always'></div>
         [/#if]
      [/#list]
    </div>
  </body>
</html>

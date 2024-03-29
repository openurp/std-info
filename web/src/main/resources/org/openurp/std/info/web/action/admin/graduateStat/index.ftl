[#ftl]
[@b.head/]
  [@b.toolbar title="毕业信息统计"/]
<div class="container-fluid">
  <div class="row">
     <div class="col-2" id="accordion">

       <div class="card card-info card-primary card-outline">
         <div class="card-header" id="stat_header_2">
          <h5 class="mb-0">
              <button class="btn btn-link" data-toggle="collapse" data-target="#stat_body_2" aria-expanded="true" aria-controls="stat_body_2" style="padding: 0;">
                毕业统计
              </button>
            </h5>
         </div>
         <div id="stat_body_2" class="collapse show" aria-labelledby="stat_header_2" data-parent="#accordion">
           <div class="card-body" style="padding-top: 0px;">
             <table class="table table-hover table-sm">
               <tbody>
               [#list seasons as season]
                <tr>
                 <td width="100%">[@b.a href="!stat?seasonId="+season.id target="graduateStatDiv"]${season.name}[/@]</td>
                </tr>
                [/#list]
               </tbody>
             </table>
           </div>
         </div>
       </div>

     </div>
     [@b.div id="graduateStatDiv" class="col-10" href="!stat?seasonId="+seasons?first.id/]
  </div>
</div>

[@b.foot/]

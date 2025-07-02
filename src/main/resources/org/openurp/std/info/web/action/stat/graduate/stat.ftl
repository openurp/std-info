
<style>
.stat_report {
  height: 100%;
  font-family: 宋体;
  text-align: center;
}

.stat_report > .title {
  width: 100%;
  padding-top:20px;
  font-weight: bold;
}
.stat_report > table.listTable {
  border-collapse: collapse;
  border-style:solid;
  border-width:1px;
  border-color:#006CB2;
  vertical-align: middle;
  font-style: normal;
  width:90%;
}

.stat_report > table.listTable tr:first-child {
  height: 44px;
  font-weight: bold;
}
.stat_report > table.listTable tr {
  height: 33px;
}
.stat_report > table.listTable tr > td {
  border-style:solid;
  border-width:1px;
  border-color:#006CB2;
  padding: 0px;
}

.stat_report > table.listTable tr > td.department3 {
  font-weight: bold;
  vertical-align: middle;
}
.stat_report > table.listTable tr > td.eduSpan3 {
  font-weight: bold;
  vertical-align: middle;
}
</style>
  <div class="card card-primary card-outline">
    <div class="card-header">
      <h3 class="card-title">毕业人数统计</h3>
    </div>
    <div class="card-body">
    [@b.div href="!graduateStat?seasonId="+Parameters['seasonId']/]
    </div>
  </div>

  <div class="card card-primary card-outline">
    <div class="card-header">
      <h3 class="card-title">学位授予人数统计</h3>
    </div>
    <div class="card-body">
    [@b.div href="!degreeStat?seasonId="+Parameters['seasonId']/]
    </div>
  </div>

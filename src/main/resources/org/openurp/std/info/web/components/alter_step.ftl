<style>
ol {
  list-style: none outside none;
  margin: 0;
  padding: 0;
}

.ui-step {
  color: #b7b7b7;
  padding: 10px 60px;
  margin-bottom: 35px;
  position: relative;
}
.ui-step:after {
  display: block;
  content: "";
  height: 0;
  font-size: 0;
  clear: both;
  overflow: hidden;
  visibility: hidden;
}
.ui-step li {
  float: left;
  position: relative;
}
.ui-step .step-end {
  width: 120px;
  position: absolute;
  top: 0;
  right: -60px;
}
.ui-step-line {
  height: 3px;
  background-color: #e0e0e0;
  box-shadow: inset 0 1px 1px rgba(0,0,0,.2);
  margin-top: 15px;
}
.step-end .ui-step-line { display: none; }
.ui-step-cont {
  width: 200px;
  position: absolute;
  top: 0;
  left: -15px;
  text-align: center;
}
.ui-step-cont-number {
  display: inline-block;
  position: absolute;
  left: 0;
  top: 0;
  width: 30px;
  height: 30px;
  line-height: 30px;
  color: #fff;
  border-radius: 50%;
  border: 2px solid rgba(224,224,224,1);
  font-weight: bold;
  font-size: 16px;
  background-color: #b9b9b9;
  box-shadow: inset 1px 1px 2px rgba(0,0,0,.2);
}
.ui-step-cont-text {
  position: relative;
  top: 34px;
  left: -88px;
  font-size: 12px;
}
.ui-step-3 li { width: 50%; }
.ui-step-4 li { width: 33.3%; }
.ui-step-5 li { width: 25%; }
.ui-step-6 li { width: 20%; }
.ui-step-7 li { width: 16.6%; }
.ui-step-8 li { width: 14.2%; }

.step-done .ui-step-cont-number { background-color: #667ba4; }
.step-done .ui-step-cont-text { color: #667ba4; }
.step-done .ui-step-line { background-color: #4c99e6; }
.step-active .ui-step-cont-number { background-color: #3c8dbc; }
.step-active .ui-step-cont-text { color: #3c8dbc;font-weight: bold; }

.title{
  text-align:right;
}
.textarea-inherit {
  width: 80%; /* 自动适应父布局宽度 */
  overflow: auto;
  word-break: break-all; /* 解决IE中的断行问题 */
}
.width15{
  width:15%;
}
@media (min-width: 768px) {
  .step-description{
    display:none;
  }
  .step-line{
    display:block;
  }
  .timeline-container{
    padding-left:5rem;
  }
}
@media (max-width:991.98px) {
  fieldset.listset li > label.title {
    text-align:left;
  }
  .step-description{
    display:block;
  }
  .step-line{
    display:none;
  }
  .timeline-container{
    padding-left:0rem;
  }
  .table-sm td, .table-sm th{
    padding-right: 0rem;
    padding-left: 0rem;
  }
  .width15{
    width:inherit;
  }
}

</style>
  [#macro displayStep stepNames lastStepName]
  [#assign doneIndex = -1 /]
  <div style="width:90%; margin:5px auto;margin-bottom: 10px;" class="step-line">
    [#assign step_index=0/]
    [#list stepNames as data]
      [#if data == lastStepName]
      [#assign step_index=data_index/]
      [/#if]
    [/#list]
    <ol class="ui-step ui-step-${stepNames?size} ui-step-blue">
        [#list stepNames as data]
        [#assign stepDone = (data_index < step_index || data_index < doneIndex + 1 ) /]
      <li class="[#if data_index==0]step-start[#elseif data_index+1=stepNames?size]step-end[/#if] [#if data_index==step_index] step-active[/#if][#if stepDone] step-done[/#if]">
        <div class="ui-step-line"></div>
        <div class="ui-step-cont">
          <span class="ui-step-cont-number">${data_index+1}</span>
          <span class="ui-step-cont-text">${data}</span>
        </div>
      </li>
      [/#list]
    </ol>
  </div>
  <div class="step-description">
    [#list stepNames as data]
      [#assign stepDone = (data_index < step_index || data_index < doneIndex + 1 ) /]
      <span [#if !stepDone && data_index > 0]class="text-muted"[/#if]>${data_index+1}.${data}</span>
    [/#list]
  </div>
  [/#macro]

  [#function getStepNames(flow)]
    [#assign stepNames=[]/]
    [#list flow.activities as act]
      [#if act.guard??]
      [#assign stepNames=stepNames+['${act.name}<sup>${act.guard}</sup>']/]
      [#else]
      [#assign stepNames=stepNames+['${act.name}']/]
      [/#if]
    [/#list]
    [#return stepNames/]
  [/#function]

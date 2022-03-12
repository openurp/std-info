[#ftl]
[@b.head/]
  [@b.toolbar id="reportBar" title="在籍院系男女生人数统计"]
    bar.addClose();
  [/@]
  [#assign firstWidth = 120/]
  [#assign secondWidth = 40/]
  [#assign is100 = results?size == 0 || results?first.width() lt 10/]
  [#assign preWidth = is100?string(100, 50)?number/]
  [#macro outputDepartNode node, node_index]
    [#if node_index == 0]
    <tr>
      <td width="${firstWidth}px">院系</td>
      <td width="${secondWidth}px">性别</td>
      [@outputTitle node.next(), node.width()/]
    </tr>
    [/#if]
    [#local n = node.next().nodeArraySize()/]
    [#local currNode = node.next()?if_exists/]
    [#-- 下面是nodeArray --]
    [#list 0..(n - 1) as i]
    <tr>
      [#if i == 0]
      <td rowspan="${n}">${node.val().name}</td>
      [/#if]
      <td>${currNode.nodeArrayIndexOf(i).val().name}</td>
      [@outputGenderNode currNode, i/]
    </tr>
    [/#list]
  [/#macro]
  [#macro outputTitle node, length]
<td width="${preWidth}px">${node.val()}</td>[#if node.next()?exists][@outputTitle node.next(), length/][/#if]
  [/#macro]
  [#macro outputGenderNode node, index]
<td>${(node.nodeArrayIndexOf(index).next().val())!}</td>[#if node.next()?exists][@outputGenderNode node.next(), index/][/#if]
  [/#macro]

  [#-- 正文从下面开始 --]
  <table width="${firstWidth + secondWidth + preWidth * results?first.width()}px" align="center" cellpadding="0" cellspacing="0">
    <tr>
      <td style="font-weight: bold; font-size: 18pt; text-align: center; padding-top: 10px; padding-bottom: 10px">在籍学生 院系男女生人数统计</td>
    </tr>
    <tr>
      <td>
        [#if results?size == 0]
        <div style="color: red">没有统计数据！</div>
        [#else]
        <table class="gridtable" style="text-align: center;border:solid 1px">
          [#list results as departNode]
            [@outputDepartNode departNode, departNode_index/]
          [/#list]
        </table>
        [/#if]
      </td>
    </tr>
  </table>
[@b.foot/]

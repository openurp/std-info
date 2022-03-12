[#ftl]
<style>
  table.help, table.help * {
    vertical-align: top;
  }
</style>
[#assign flagHTML]<img src="${base}/static/images/people_out.png" align="absmiddle" width="16px" height="16px"/>[/#assign]
[#assign squadConditionHTML]<span style="color: blue; font-weight: bold">班级条件</span>[/#assign]
<div>
  <table class="help">
    <tr style="font-size: 0pt">
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>1.</td>
      <td colspan="2"><span style="background-color: rgba(255, 255, 0, 0.4)">黄色区域</span>为某班已配置的学生。点击其中的“移出”按钮，被点击的学生将标志为${flagHTML}；若其中标志为${flagHTML}的学生又不想移出了，可点击“取消”按钮恢复。</td>
    </tr>
    <tr>
      <td>2.</td>
      <td colspan="2">点击页面中的“添加”按钮，在弹出与${squadConditionHTML}相符“可配学生”列表的对话框中选择学生，点击“加入班级”后这些所选学生将出现对应班级下方的<span style="background-color: rgba(0, 255, 0, 0.4)">绿色区域</span>；若某些被新添加又不需要了，可点击对应的“取消”。</td>
    </tr>
    <tr>
      <td>3.</td>
      <td colspan="2">${squadConditionHTML}，由项目、培养层次、学生类别、年级、院系、专业、方向和校区字段组成。</td>
    </tr>
    <tr>
      <td></td>
      <td colspan="2">其中，</td>
    </tr>
    <tr>
      <td></td>
      <td>1)</td>
      <td>方向字段的匹配规则如下：若班级和学生任何一方没设值，或两者均未设值，或者两者值一致。</td>
    </tr>
    <tr>
    <tr>
      <td></td>
      <td>2)</td>
      <td>校区字段，同上。</td>
    </tr>
    <tr>
      <td></td>
      <td>3)</td>
      <td>其它字段均须两者一致。</td>
    </tr>
    <tr>
      <td></td>
      <td colspan="2">“可配学生”列表，其学生列表组成部分如下：</td>
    </tr>
    <tr>
      <td></td>
      <td>1)</td>
      <td>非“班级中的学生调配”页面（以下简称“本页面”）上出现兄弟班级（与本班${squadConditionHTML}一致的非本班班级）的学生；</td>
    </tr>
    <tr>
    <tr>
      <td></td>
      <td>2)</td>
      <td>本页面上出现了兄弟班级却被标志${flagHTML}的学生；</td>
    </tr>
    <tr>
      <td></td>
      <td>3)</td>
      <td>有学籍状态但没有分配班级却符合本班${squadConditionHTML}的学生。</td>
    </tr>
    <tr>
      <td>4.</td>
      <td colspan="2">符合${squadConditionHTML}的学生只能加入其中一个班级中。</td>
    </tr>
    <tr>
      <td>5.</td>
      <td colspan="2">最后确认无误后，点击“保存调配”以生效。<span style="color: red; font-weight: bold">注意：一旦“保存调配”，将无法逆操作。</span></td>
    </tr>
  </table>
</div>

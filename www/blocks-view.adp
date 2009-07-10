<master>
  <property name="title">@title;noquote@</property>
  <property name="context">@context;noquote@</property>
  <property name="head">@header_stuff;noquote@
  </property>
  <property name="planner_object_id">@item_id;noquote@</property>

<div class='xowiki-content'>
<div id='wikicmds'>
  <if @edit_link@ not nil><a href="@edit_link@" accesskey='e' title='Diese Seite bearbeiten ...'>#xowiki.edit#</a> &middot; </if>
  <if @delete_link@ not nil><a href="@delete_link@" accesskey='d'>#xowiki.delete#</a></if>
</div>
@content;noquote@
</div>

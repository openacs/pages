<?xml version="1.0"?>

<queryset>

<fullquery name="pages::get_page_name.get_page_name">
      <querytext>
	select name
	from cr_items
	where item_id = :item_id
      </querytext>
</fullquery>

</queryset> 

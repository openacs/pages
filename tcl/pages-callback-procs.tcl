ad_library {
    Pages - Callbacks

    @creation-date Aug 2008
    @author Alvaro Rodriguez
}
::xo::db::require package xowiki

namespace eval ::pages {

  ad_proc -private ::pages::after-mount {
    {-package_id:required}
    {-node_id:required}
  } {
    set community_id [dotlrn_community::get_community_id \
                    -package_id [site_node::get_object_id \
                                -node_id [site_node::get_parent_id -node_id $node_id]]]
    set member_party_id [dotlrn_community::get_rel_segment_id \
                            -community_id $community_id \
                            -rel_type "dotlrn_member_rel"]
    set admin_party_id [dotlrn_community::get_rel_segment_id \
                            -community_id $community_id \
                            -rel_type "dotlrn_admin_rel"]
    permission::set_not_inherit -object_id $package_id
    permission::grant -party_id $member_party_id \
        -object_id $package_id -privilege read
    permission::grant -party_id $admin_party_id \
        -object_id $package_id -privilege read
    permission::grant -party_id $admin_party_id \
        -object_id $package_id -privilege write
  }

}

ad_proc -public -callback search::url -impl ::xowiki::Page {} {

    @author alvaro@viaro.net
    @creation_date Jul-08

    returns a url for a xowiki page to the search package

} {

    set item_id [content::revision::item_id -revision_id $object_id]
    set package_id [acs_object::package_id -object_id $object_id]
    set page_name [pages::get_page_name -item_id $item_id]
    set package_url [apm_package_url_from_id $package_id]

    return "${package_url}$page_name"
}

ad_proc -public -callback search::url -impl ::xowiki::PlainPage {} {

    @author alvaro@viaro.net
    @creation_date Jul-08

    returns a url for a xowiki plain page to the search package

} {

    set item_id [content::revision::item_id -revision_id $object_id]
    set package_id [acs_object::package_id -object_id $object_id]
    set page_name [pages::get_page_name -item_id $item_id]
    set package_url [apm_package_url_from_id $package_id]

    return "${package_url}$page_name"
}

ad_proc -public -callback planner::edit_url -impl ::xowiki::Page {} {

    @author alvaro@viaro.net
    @creation_date Jul-08

    returns a url for a xowiki page to the dotlrn blocks

} {

    set item_id [content::revision::item_id -revision_id $object_id]
    set package_id [acs_object::package_id -object_id $object_id]
    set page_name [pages::get_page_name -item_id $item_id]
    set package_url [apm_package_url_from_id $package_id]

    return "${package_url}$page_name?m=edit"
}

ad_proc -public -callback planner::edit_url -impl ::xowiki::PlainPage {} {

    @author alvaro@viaro.net
    @creation_date Jul-08

    returns a url for a xowiki plain page to the dotlrn blocks

} {

    set item_id [content::revision::item_id -revision_id $object_id]
    set package_id [acs_object::package_id -object_id $object_id]
    set page_name [pages::get_page_name -item_id $item_id]
    set package_url [apm_package_url_from_id $package_id]

    return "${package_url}$page_name?m=edit"
}

ad_proc -public -callback planner::delete_url -impl ::xowiki::Page {} {

    @author alvaro@viaro.net
    @creation_date Jul-08

    returns a url for a xowiki page to the dotlrn blocks

} {

    set item_id [content::revision::item_id -revision_id $object_id]
    set package_id [acs_object::package_id -object_id $object_id]
    set page_name [pages::get_page_name -item_id $item_id]
    set package_url [apm_package_url_from_id $package_id]

    return "${package_url}$page_name?m=delete"
}

ad_proc -public -callback planner::delete_url -impl ::xowiki::PlainPage {} {

    @author alvaro@viaro.net
    @creation_date Jul-08

    returns a url for a xowiki plain page to the dotlrn blocks

} {

    set item_id [content::revision::item_id -revision_id $object_id]
    set package_id [acs_object::package_id -object_id $object_id]
    set page_name [pages::get_page_name -item_id $item_id]
    set package_url [apm_package_url_from_id $package_id]

    return "${package_url}$page_name?m=delete"
}

ad_proc -public -callback planner::insert_object -impl xowiki {} {

    @author alvaro@viaro.net
    @creation_date Jul-2008

    Insert the recently created object into the blocks view objects table

} {
    if { ![empty_string_p $block_id] } {
        set object_index [planner::get_next_object_index -block_id $block_id]
        planner::insert_object_to_block -block_id $block_id -object_index $object_index -object_id $object_id
    }
}

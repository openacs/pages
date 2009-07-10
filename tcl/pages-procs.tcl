ad_library {
    Pages - classess and procs

    @creation-date Aug 2008
    @author Alvaro Rodriguez
    
}
::xo::db::require package xowiki

namespace eval ::blocks {

  ::xo::PackageMgr create ::blocks::Package \
    -package_key "pages" -pretty_name "Pages" \
    -superclass ::xowiki::Package

  Package instproc initialize {} {
    ::xowiki::WikiForm instmixin add BlockWikiForm
    ::xowiki::PlainWikiForm instmixin add BlockPlainWikiForm
    ::xowiki::Page instmixin add BlockPage
    next
  }

  Package instproc destroy {} {
    ::xowiki::WikiForm instmixin delete ::blocks::BlockWikiForm
    ::xowiki::PlainWikiForm instmixin delete ::blocks::BlockPlainWikiForm
    ::xowiki::Page instmixin delete ::blocks::BlockPage
    next
  }

  #
  # BlockPageForm
  #

  Class create BlockWikiForm -superclass ::xowiki::WikiForm \
      -parameter {
        {field_list {item_id name page_order title creator text description nls_language block_id}}
	  {f.name 
	      {name:text(hidden),optional}
	  }
	  {f.block_id
	      {block_id:text(hidden)}
	  }
	  {f.page_order
	      {page_order:text(hidden),optional}
	  }
          {validate {
	      {name {\[::xowiki::validate_name\]} {Another item with this name exists \
						       already in this folder}}}
          }
      }

  BlockWikiForm instproc new_data {} {
    my instvar data
    set item_id [next]
    set block_id [$data set block_id]
    callback -catch -impl "planner" planner::insert_object -block_id $block_id -object_id $item_id
  }

  BlockWikiForm instproc edit_data {} {
    my data_from_form -new 0
    set item_id [next]
    callback -catch -impl "planner" planner::flush_blocks_cache -community_id [dotlrn_community::get_community_id]
    return $item_id
  }

  BlockWikiForm instproc new_request {} {
    my instvar data
    set block_id [[$data package_id] get_parameter block_id 0]
    my var block_id [list $block_id]
    next
  }

  BlockWikiForm instproc edit_request {item_id} {
    my instvar page_instance_form_atts data
    next
    #add something to the block_id parameter to avoid the required field in the submit
    my var block_id [list 0]
  }

  #
  # BlockPlainPageForm
  #

  Class create BlockPlainWikiForm -superclass BlockWikiForm \
      -parameter {
        {f.text "= textarea,cols=80,rows=10"}
      }

  Class create BlockPage -superclass ::xowiki::Page

  BlockPage instproc delete {} {
    next
    callback -catch -impl "planner" planner::flush_blocks_cache -community_id [dotlrn_community::get_community_id]
  }

#  BlockPage instproc render {} {
#      set content [next -update_references]
#      regsub -nocase "<DIV class='content-chunk-footer'>*</div>" $content "" content
#      return $content
#  }

  Package instproc return_page {-adp:required -variables -form} {
    foreach _var $variables {
        upvar $_var [set _var]
    }
    if {[exists_and_not_null item_id]} {
        set content_type [content::item::get_content_type -item_id $item_id]
        if {[exists_and_not_null content] && [string equal $content_type "::xowiki::PlainPage"]} {
            set content [ad_text_to_html -- $content]
        }
    }
    if {[exists_and_not_null form]} {
	upvar form [set form]
    } else {
        set form ""
    }
    if { [string equal $adp "/packages/xowiki/www/edit"] } {
        set adp "/packages/pages/www/edit"
    }

    return [next -adp $adp -variables $variables -form $form]
  }

  #
  # Blocks Policy
  #

  Class create Policy -superclass ::xo::Policy

  Policy policy1 -contains {

    Class Package -array set require_permission {
        reindex             swa
        delete              {{package_id admin}}
        edit-new            {
            {{has_class ::xowiki::Object} id swa} 
            {{has_class ::xowiki::File} id swa} 
            {{has_class ::xowiki::Form} id swa} 
            {{has_class ::xowiki::PodcastItem} id swa} 
            {{has_class ::xowiki::PageTemplate} id swa} 
            {id write}
        }
    }

    Class Page -array set require_permission {
        view               none
        revisions          swa
        diff               swa
        edit               {{package_id write}}
        save-form-data     swa
        make-live-revision swa
        delete-revision    swa
        delete             {{package_id write}}
        create-new        {{package_id write}}
    } -set default_permission {{package_id write}}

  }

}

namespace eval pages {}

    ad_proc -public pages::get_page_name {
        {-item_id:required}
    } {
        Get page name by id
    } {
        set page_name [db_string get_page_name { *SQL* } -default ""]
        return $page_name
    }

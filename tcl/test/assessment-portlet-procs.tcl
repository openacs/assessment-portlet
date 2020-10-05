ad_library {
    Automated tests for the assessment-portlet package.

    @author Héctor Romojaro <hector.romojaro@gmail.com>
    @creation-date 2020-08-19
    @cvs-id $Id$
}

aa_register_case -procs {
        assessment_admin_portlet::link
        assessment_portlet::link
        assessment_admin_portlet::get_pretty_name
        assessment_portlet::get_pretty_name
    } -cats {
        api
        production_safe
    } assessment_portlet_links_names {
        Test diverse link and name procs.
} {
    aa_equals "Assessment admin portlet link"           "[assessment_admin_portlet::link]" ""
    aa_equals "Assessment portlet link"                 "[assessment_portlet::link]" ""
    aa_equals "Assessment admin portlet pretty name"    "[assessment_admin_portlet::get_pretty_name]" "#assessment.Assessment_Administration#"
    aa_equals "Assessment portlet pretty name"          "[assessment_portlet::get_pretty_name]" "#assessment.Assessment#"
}

aa_register_case -procs {
        assessment_portlet::add_self_to_page
        assessment_portlet::remove_self_from_page
        assessment_admin_portlet::add_self_to_page
        assessment_admin_portlet::remove_self_from_page
    } -cats {
        api
    } assessment_portlet_add_remove_from_page {
        Test add/remove portlet procs.
} {
    #
    # Helper proc to check portal elements
    #
    proc portlet_exists_p {portal_id portlet_name} {
        return [db_0or1row portlet_in_portal {
            select 1 from dual where exists (
              select 1
                from portal_element_map pem,
                     portal_pages pp
               where pp.portal_id = :portal_id
                 and pp.page_id = pem.page_id
                 and pem.name = :portlet_name
            )
        }]
    }
    #
    # Start the tests
    #
    aa_run_with_teardown -rollback -test_code {
        #
        # Create a community.
        #
        # As this is running in a transaction, it should be cleaned up
        # automatically.
        #
        set community_id [dotlrn_community::new -community_type dotlrn_community -pretty_name foo]
        if {$community_id ne ""} {
            aa_log "Community created: $community_id"
            set portal_id [dotlrn_community::get_admin_portal_id -community_id $community_id]
            set package_id [dotlrn::instantiate_and_mount $community_id [assessment_portlet::my_package_key]]
            #
            # assessment_portlet
            #
            set portlet_name [assessment_portlet::get_my_name]
            #
            # Add portlet.
            #
            assessment_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id -param_action ""
            aa_true "Portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Remove portlet.
            #
            assessment_portlet::remove_self_from_page -portal_id $portal_id -package_id $package_id
            aa_false "Portlet is in community portal after removal" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Add portlet.
            #
            assessment_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id -param_action ""
            aa_true "Portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # admin_portlet
            #
            set portlet_name [assessment_admin_portlet::get_my_name]
            #
            # Add portlet.
            #
            assessment_admin_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id
            aa_true "Admin portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Remove portlet.
            #
            assessment_admin_portlet::remove_self_from_page -portal_id $portal_id
            aa_false "Admin portlet is in community portal after removal" "[portlet_exists_p $portal_id $portlet_name]"
            #
            # Add portlet.
            #
            assessment_admin_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id
            aa_true "Admin portlet is in community portal after addition" "[portlet_exists_p $portal_id $portlet_name]"
        } else {
            aa_error "Community creation failed"
        }
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

ad_library {

    Procedures to support the assessment portlets

    @creation-date Sept 2004
    @author jopez@galileo.edu
    @cvs_id $Id$

}

namespace eval assessment_portlet {}
namespace eval assessment_admin_portlet {}


#
# assessment namespace
#

ad_proc -private assessment_portlet::get_my_name {
} {
    return "assessment_portlet"
}



ad_proc -private assessment_portlet::my_package_key {
} {
    return "assessment-portlet"
}



ad_proc -public assessment_portlet::get_pretty_name {
} {
    return "[_ assessment.Assessment_porlet]"
}



ad_proc -public assessment_portlet::link {
} {
    return ""
}



ad_proc -public assessment_portlet::add_self_to_page {
    {-portal_id:required}
    {-package_id:required}
    {-param_action:required}
    {-force_region ""}
    {-page_name "" }
} {
    Adds a assessment PE to the given portal.
    
    @param portal_id The page to add self to
    @param package_id The community with the folder
    
    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -value $package_id \
                -force_region $force_region \
		-page_name $page_name \
                -pretty_name [get_pretty_name] \
                -param_action $param_action
           ]
}



ad_proc -public assessment_portlet::remove_self_from_page {
    {-portal_id:required}
    {-package_id:required}
} {
    Removes a assessment PE from the given page or the package_id of the
    assessment package from the portlet if there are others remaining
    
    @param portal_id The page to remove self from
    @param package_id
} {
    portal::remove_element_parameters \
        -portal_id $portal_id \
        -portlet_name [get_my_name] \
        -value $package_id
}



ad_proc -public assessment_portlet::show {
    cf
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "assessment-portlet"
}

#
# assessment admin namespace
#

ad_proc -private assessment_admin_portlet::get_my_name {} {
    return "assessment_admin_portlet"
}


ad_proc -public assessment_admin_portlet::get_pretty_name {} {
    return "Assessment Administration"
}



ad_proc -private assessment_admin_portlet::my_package_key {} {
    return "assessment-portlet"
}



ad_proc -public assessment_admin_portlet::link {} {
    return ""
}



ad_proc -public assessment_admin_portlet::add_self_to_page {
    {-portal_id:required}
    {-page_name ""}
    {-package_id:required}
} {
    Adds a assessment admin PE to the given portal

    @param portal_id The page to add self to
    @param package_id The package_id of the assessment package

    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -key package_id \
                -value $package_id
           ]
}

ad_proc -public assessment_admin_portlet::remove_self_from_page {
    {-portal_id:required}
} {
    Removes a assessment admin PE from the given page
} {
    portal::remove_element \
        -portal_id $portal_id \
        -portlet_name [get_my_name]
}


ad_proc -public assessment_admin_portlet::show {
    cf
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "assessment-admin-portlet"
}

ad_proc -private assessment_portlet::after_install {} {
    Create the datasources needed by the assessment portlet.
} {
    
    db_transaction {
	set ds_id [portal::datasource::new \
		       -name "assessment_portlet" \
		       -description "Assessments Portlet"]

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value t

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl

    }
}

ad_proc -private assessment_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the assessment portlet.
} {
    set spec {
        name "assessment_portlet"
	contract_name "portal_datasource"
	owner "assessment-portlet"
        aliases {
	    GetMyName assessment_portlet::get_my_name
	    GetPrettyName  assessment_portlet::get_pretty_name
	    Link assessment_portlet::link
	    AddSelfToPage assessment_portlet::add_self_to_page
	    Show assessment_portlet::show
	    Edit assessment_portlet::edit
	    RemoveSelfFromPage assessment_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private assessment_admin_portlet::after_install {} {
    Create the datasources needed by the assessment portlet.
} {

    db_transaction {
	set ds_id [portal::datasource::new \
		       -name "assessment_admin_portlet" \
		       -description "Assessment Admin Portlet"]

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value f

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl
    }

}



ad_proc -private assessment_admin_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the assessment admin portlet.
} {
    set spec {
        name "assessment_admin_portlet"
	contract_name "portal_datasource"
	owner "assessment-portlet"
        aliases {
	    GetMyName assessment_admin_portlet::get_my_name
	    GetPrettyName  assessment_admin_portlet::get_pretty_name
	    Link assessment_admin_portlet::link
	    AddSelfToPage assessment_admin_portlet::add_self_to_page
	    Show assessment_admin_portlet::show
	    Edit assessment_admin_portlet::edit
	    RemoveSelfFromPage assessment_admin_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private assessment_portlet::uninstall {} {
    Assessment Portlet package uninstall proc
} {
    unregister_implementations
    set ds_id [portal::get_datasource_id assessment_portlet]
    db_exec_plsql delete_assessments_ds { *SQL* }
}

ad_proc -private assessment_admin_portlet::uninstall {} {
    Assessment Portlet package uninstall proc
} {
    unregister_implementations
    set ds_id [portal::get_datasource_id assessment_admin_portlet]
    db_exec_plsql delete_admin_ds { *SQL* }
}

ad_proc -private assessment_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "assessment_portlet"
}

ad_proc -private assessment_admin_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "assessment_admin_portlet"
}

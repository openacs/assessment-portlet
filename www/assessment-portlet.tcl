# /assessment-portlet/www/assessment-portlet.tcl

ad_page_contract {
    The display logic for the assessment portlet

    @author jopez@galileo.edu
    @creation-date Oct 2004
    @cvs_id $Id$
} {
    {page_num 0}
} -properties {
}

set user_id [ad_conn user_id]

array set config $cf	
set shaded_p $config(shaded_p)

set list_of_package_ids $config(package_id)
set one_instance_p [ad_decode [llength $list_of_package_ids] 1 1 0]
ns_log notice " ----- [join $list_of_package_ids ","] \n\n\n\n"

foreach package_id $config(package_id) {
    db_1row as_package_id {SELECT package_id AS as_package_id FROM apm_packages WHERE package_key = 'assessment' AND package_id = :package_id}
} 

set admin_p 0
array set package_admin_p [list]
foreach package_id $config(package_id) {
    set package_admin_p($package_id) [permission::permission_p -object_id $package_id -privilege admin]
    if { $package_admin_p($package_id) } {
        set admin_p 1
    }
}

template::list::create \
    -name assessments \
    -multirow assessments \
    -pass_properties { as_package_id } \
    -key assessment_id \
    -elements {
	title {
	    label {[_ assessment.Assessment]}
	    link_url_eval {[site_node::get_url_from_object_id -object_id $as_package_id]assessment?[export_vars {assessment_id}]}
	    link_html { title {description} }
	    
	}
	session {
	    label {[_ assessment.Sessions]}
	    link_url_eval {[site_node::get_url_from_object_id -object_id $as_package_id]sessions?[export_vars {assessment_id}]}
	}
    } \
    -main_class {
	narrow
    }

db_multirow -extend { session } assessments asssessment_id_name_definition {} {
    set session {Sessions}
}

ad_return_template




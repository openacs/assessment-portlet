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

set admin_p 0
array set package_admin_p [list]
foreach package_id $config(package_id) {
    set package_admin_p($package_id) [permission::permission_p -object_id $package_id -privilege admin]
    if { $package_admin_p($package_id) } {
        set admin_p 1
    }
}

set base_url "[ad_conn package_url]assessment/"

template::list::create \
    -name assessments \
    -multirow assessments \
    -pass_properties { base_url } \
    -key assessment_id \
    -elements {
	title {
	    label {Assessment}
	    link_url_eval {[export_vars -base "$base_url" {assessment_id}]}
	    link_html { title {description} }
	    
	}
	session {
	    label {assessment.Sessions}
	    link_url_eval {[export_vars -base "$base_url" {assessment_id}]}
	}
    } \
    -main_class {
	narrow
    }

db_multirow -extend { session } assessments asssessment_id_name_definition {} {
    set session {Sessions}
}

ad_return_template




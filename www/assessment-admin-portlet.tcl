# /assessment-portlet/www/assessment-admin-portlet.tcl

ad_page_contract {
    The display logic for the assessment admin portlet

    @author jopez@galileo.edu
    @creation-date 2004-10-06
    @cvs-id $Id$
} -properties {
    
}

array set config $cf
set user_id [ad_conn user_id]
set list_of_package_ids $config(package_id)

if {[llength $list_of_package_ids] > 1} {
    # We have a problem!
    return -code error "[_ assessment-portlet.error_one_assessment] "
}        

set package_id [lindex $list_of_package_ids 0]        

set url [lindex [site_node::get_url_from_object_id -object_id $package_id] 0]

ad_return_template 

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

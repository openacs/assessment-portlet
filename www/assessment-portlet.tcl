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

set elements [list]
if {!$one_instance_p} {
    set elements [list community_name \
		      [list \
			   label "[_ dotlrn.Community]" \
			   display_template {<if @assessments.community_name@ not nil>@assessments.community_name@</if><else>&nbsp;</else>}]]
}

lappend elements title \
    [list \
	 label "[_ assessment.open_assessments]" \
	 display_template {<a href="@assessments.assessment_url@">@assessments.title@</a>}]


# create a list with all open assessments
template::list::create \
    -name assessments \
    -multirow assessments \
    -key assessment_id \
    -elements $elements \
    -main_class narrow

# get the information of all open assessments
template::multirow create assessments assessment_id title description assessment_url community_url community_name
set old_comm_node_id 0
db_foreach open_asssessments {} {
    if {([empty_string_p $start_time] || $start_time <= $cur_time) && ([empty_string_p $end_time] || $end_time >= $cur_time)} {
	if {$comm_node_id == $old_comm_node_id} {
	    set community_name ""
	}
	set community_url [site_node::get_url -node_id $comm_node_id]
	set assessment_url [site_node::get_url -node_id $as_node_id]
	set old_comm_node_id $comm_node_id

	if {[empty_string_p $password]} {
	    append assessment_url [export_vars -base "assessment" {assessment_id}]
	} else {
	    append assessment_url [export_vars -base "assessment-password" {assessment_id}]
	}

	template::multirow append assessments $assessment_id $title $description $assessment_url $community_url $community_name
    }
}


set elements [list]
if {!$one_instance_p} {
    set elements [list community_name \
		      [list \
			   label "[_ dotlrn.Community]" \
			   display_template {<if @sessions.community_name@ not nil>@sessions.community_name@</if><else>&nbsp;</else>}]]
}

lappend elements title \
    [list \
	 label "[_ assessment.Assessments]"] \

lappend elements session \
    [list \
	 label {[_ assessment.Sessions]} \
	 display_template {<a href="@sessions.session_url@">[_ assessment.Sessions]</a>}]


# create a list with all answered assessments and their sessions
template::list::create \
    -name sessions \
    -multirow sessions \
    -key assessment_id \
    -elements $elements \
    -main_class narrow

# get the information of all assessments store in the database
set old_comm_node_id 0
db_multirow -extend { session_url community_url } sessions answered_asssessments {} {
    if {$comm_node_id == $old_comm_node_id} {
	set community_name ""
    }
    set community_url [site_node::get_url -node_id $comm_node_id]
    set session_url "[site_node::get_url -node_id $as_node_id][export_vars -base sessions {assessment_id}]"
    set old_comm_node_id $comm_node_id
}

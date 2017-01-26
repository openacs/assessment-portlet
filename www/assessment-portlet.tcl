# /assessment-portlet/www/assessment-portlet.tcl

ad_page_contract {
    The display logic for the assessment portlet

    @author jopez@galileo.edu
    @creation-date Oct 2004
    @cvs_id $Id$
} {
    {page_num:naturalnum,notnull 0}
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
         label "[_ assessment.Title]" \
         display_template {<a href="@assessments.assessment_url@">@assessments.title@</a><if @assessments.anonymous_p@ eq "t"><br>(#assessment.anonymous#)</if>}]

lappend elements status {
    label "[_ assessment.Status]"
    display_template {<if @assessments.status@ eq in_progress>#assessment.Incomplete#</if><if @assessments.status@ eq "finished">#assessment.Finished#</if><if @assessments.status@ eq untaken>#assessment.Untaken#</if>}
}
lappend elements take {
    label "[_ acs-kernel.common_Actions]"
    display_template {<if @assessments.status@ eq in_progress><a href="@assessments.assessment_url@">#assessment.Finish#</a></if><else><if @assessments.status@ eq untaken><a href="@assessments.assessment_url@">#assessment.Take#</a></if><else><if @assessments.completed_p@ lt @assessments.number_tries@><a href="@assessments.assessment_url@">#assessment.Retake#</a></if></else></else>}
}
if {[llength $list_of_package_ids]==1} {
    set admin_p [permission::permission_p \
		     -party_id $user_id \
		     -privilege admin \
		     -object_id $list_of_package_ids]
} else {
    set admin_p 0
}

if {$admin_p} {
    set hide 0
} else {
    set hide 1
}

lappend elements session \
    [list \
         label "[_ assessment.Review]" \
	 display_template {<if @assessments.status@ ne "untaken"><a href="@assessments.community_url@assessment/session?assessment_id=@assessments.assessment_id@">[_ assessment.Review]</a></if>}]

lappend elements admin {
    label "[_ acs-kernel.common_Administration]"
    display_template {<if @assessments.admin_p@ true><a href="@assessments.community_url@assessment/asm-admin/one-a?assessment_id=@assessments.assessment_id@">\#acs-kernel.common_Administration\#</a></if>}
}

lappend elements results {
    label "[_ assessment.Results]"
    display_template {<if @assessments.admin_p@ true><a href="@assessments.community_url@assessment/asm-admin/results-users?assessment_id=@assessments.assessment_id@">\#assessment.Results\#</a></if><else></else>}
	}

# create a list with all open assessments
template::list::create \
    -name assessments \
    -multirow assessments \
    -key assessment_id \
    -elements $elements \
    -no_data "\#assessment.No_open_assessments\#"

# get the information of all open assessments
template::multirow create assessments assessment_id title description assessment_url community_url community_name anonymous_p in_progress_p completed_p status number_tries admin_p
set old_comm_node_id 0
db_foreach open_asssessments {} {
	if {$comm_node_id == $old_comm_node_id} {
	    set community_name ""
	}
	set community_url [site_node::get_url -node_id $comm_node_id]
	set assessment_url [site_node::get_url -node_id $as_node_id]
	set old_comm_node_id $comm_node_id

	if {$password eq ""} {
	    append assessment_url [export_vars -base "instructions" {assessment_id}]
	} else {
	    append assessment_url [export_vars -base "assessment-password" {assessment_id}]
	}
    if {$in_progress_p > 0 } {
	set status in_progress
    } elseif {$completed_p >0} {
	set status finished
    } else {
	set status untaken
    }
    template::multirow append assessments $assessment_id $title $description $assessment_url $community_url $community_name $anonymous_p $in_progress_p $completed_p $status $number_tries $admin_p
}


set elements [list]
if {!$one_instance_p} {
    set elements [list community_name \
		      [list \
			   label "[_ dotlrn.Community]" \
			   display_template {<if @sessions.community_name@ not nil>@sessions.community_name@</if><else>&nbsp;</else>}]]
    set package_id_sql ""
} else {
#    set package_id_sql "and cf.package_id in ([join $list_of_package_ids ", "])"
    set package_id_sql ""
}


lappend elements title \
    [list \
	 label "[_ assessment.Title]"]
         

lappend elements session \
    [list \
	 label "[_ assessment.Review]" \
	 display_template {<a href="@sessions.session_url@">[_ assessment.Review]</a>}]

lappend elements admin {
    label "[_ acs-kernel.common_Administration]"
    display_template {<if @sessions.admin_p@ true><a href="@sessions.community_url@assessment/asm-admin/one-a?assessment_id=@sessions.assessment_id@">\#acs-kernel.common_Administration\#</a></if>}
}

lappend elements results {
    label "[_ assessment.Results]"
    display_template {<if @sessions.admin_p@ true><a href="@sessions.community_url@assessment/asm-admin/results-users?assessment_id=@sessions.assessment_id@">\#assessment.Results\#</a></if><else></else>}
	}

# create a list with all answered assessments and their sessions
template::list::create \
    -name sessions \
    -multirow sessions \
    -key assessment_id \
    -elements $elements \
    -no_data "\#assessment.No_answered_assessments\#"

# get the information of all assessments store in the database
set old_comm_node_id 0
db_multirow -extend { session_url community_url } sessions answered_assessments {} {
    if {$comm_node_id == $old_comm_node_id} {
	set community_name ""
    }
    set community_url [site_node::get_url -node_id $comm_node_id]
    set session_url "[site_node::get_url -node_id $as_node_id][export_vars -base session {assessment_id}]"
    set old_comm_node_id $comm_node_id
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

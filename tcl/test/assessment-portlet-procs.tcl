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

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

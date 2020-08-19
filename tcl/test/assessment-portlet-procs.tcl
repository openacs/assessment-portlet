ad_library {
    Automated tests for the assessment-portlet package.

    @author Héctor Romojaro <hector.romojaro@gmail.com>
    @creation-date 2020-08-19
    @cvs-id $Id$
}

aa_register_case -procs {
        assessment_admin_portlet::link
        assessment_portlet::link
    } -cats {
        api
        production_safe
    } assessment_portlet_links {
        Test diverse link procs.
} {
    aa_equals "Assessment admin portlet link" "[assessment_admin_portlet::link]" ""
    aa_equals "Assessment portlet link"       "[assessment_portlet::link]" ""
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

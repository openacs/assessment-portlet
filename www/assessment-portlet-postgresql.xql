<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="assessments">
        <querytext>
	   select cri.item_id as assessment_id, 
            crr.title, 
	    crr.description,
	    acs_object__name(apm_package__parent_id(crf.package_id)) as parent_name,
            (select site_node__url(site_nodes.node_id)
              from site_nodes
             where site_nodes.object_id = crf.package_id) as url,
	    crf.package_id
	   from as_assessments asa, cr_items cri, cr_revisions crr, cr_folders crf
	   where crr.revision_id = asa.assessment_id
	     and crr.revision_id = cri.latest_revision
	     and cri.parent_id = crf.folder_id
	     and crf.package_id in ([join $list_of_package_ids ", "])
	   order by package_id, lower(crr.title)
        </querytext>
    </fullquery>

</queryset>

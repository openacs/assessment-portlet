<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="open_asssessments">
	<querytext>
	select cr.item_id as assessment_id, cr.title, cr.description, a.password,
	       to_char(a.start_time, 'YYYY-MM-DD HH24:MI:SS') as start_time,
	       to_char(a.end_time, 'YYYY-MM-DD HH24:MI:SS') as end_time,
	       to_char(now(), 'YYYY-MM-DD HH24:MI:SS') as cur_time,
	       cf.package_id, p.instance_name as community_name,
	       sc.node_id as comm_node_id, sa.node_id as as_node_id
	from as_assessments a, cr_revisions cr, cr_items ci, cr_folders cf,
	     site_nodes sa, site_nodes sc, apm_packages p,
             (select distinct asm.assessment_id
              from as_assessment_section_map asm, as_item_section_map ism,
                   acs_object_party_privilege_map ppm
              where ism.section_id = asm.section_id
              and ppm.object_id = asm.assessment_id
              and ppm.privilege = 'read'
              and ppm.party_id = :user_id) s
	where a.assessment_id = cr.revision_id
	and cr.revision_id = ci.latest_revision
	and ci.parent_id = cf.folder_id
	and cf.package_id in ([join $list_of_package_ids ", "])
	and sa.object_id = cf.package_id
	and sc.node_id = sa.parent_id
	and p.package_id = sc.object_id
        and s.assessment_id = a.assessment_id
	order by lower(p.instance_name), lower(cr.title)
	</querytext>
</fullquery>

</queryset>

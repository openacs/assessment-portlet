<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="open_asssessments">
	<querytext>
select a.*, cr.item_id as assessment_id, cr.title, cr.description, a.password,
       sc.node_id as comm_node_id, sa.node_id as as_node_id,p.instance_name as community_name
from as_assessments a, cr_revisions cr, cr_items ci, cr_folders cf, site_nodes sa, site_nodes sc, apm_packages p
where a.assessment_id = cr.revision_id
and sysdate < a.end_time
and sysdate > a.start_time
and cr.revision_id = ci.latest_revision
and ci.parent_id = cf.folder_id
and cf.package_id in ([join $list_of_package_ids ", "])
and sa.object_id = cf.package_id
	and sc.node_id = sa.parent_id
	and p.package_id = sc.object_id
and exists (select 1
                   from as_assessment_section_map asm, as_item_section_map ism
                   where asm.assessment_id = a.assessment_id
                   and ism.section_id = asm.section_id)
        and exists (select 1 from acs_object_party_privilege_map ppm
                    where ppm.object_id = a.assessment_id
                    and ppm.privilege = 'read'
                    and ppm.party_id = :user_id)
	order by lower(p.instance_name), lower(cr.title)
	</querytext>
</fullquery>
	
</queryset>

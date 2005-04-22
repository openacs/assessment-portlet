<?xml version="1.0"?>
<queryset>

<fullquery name="answered_asssessments">
	<querytext>
	select cr.item_id as assessment_id, cr.title, cr.description,
	       cf.package_id, p.instance_name as community_name,
	       sc.node_id as comm_node_id, sa.node_id as as_node_id
	from as_assessments a, cr_revisions cr, cr_items ci, cr_folders cf,
	     site_nodes sa, site_nodes sc, apm_packages p
	where a.assessment_id = cr.revision_id
	and cr.revision_id = ci.latest_revision
	and ci.parent_id = cf.folder_id
	and cf.package_id in ([join $list_of_package_ids ", "])
	and sa.object_id = cf.package_id
	and sc.node_id = sa.parent_id
	and p.package_id = sc.object_id
	and exists (select 1
		from as_sessions s
		where s.assessment_id = a.assessment_id
		and s.subject_id = :user_id
		and s.completed_datetime is not null)
	order by lower(p.instance_name), lower(cr.title)
	</querytext>
</fullquery>
	
</queryset>

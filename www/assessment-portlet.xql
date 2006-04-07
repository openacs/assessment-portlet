<?xml version="1.0"?>
<queryset>

<fullquery name="answered_assessments">
	<querytext>
select ass.*, sc.node_id as comm_node_id, sa.node_id as as_node_id, p.instance_name as community_name from 
  (select cr.item_id as assessment_id, cr.title, cr.description, cf.package_id
   from as_assessments a, cr_revisions cr, cr_items ci, cr_folders cf,
      (  select distinct s.assessment_id
         from as_sessions s
         where s.subject_id = :user_id
         and s.completed_datetime is not null) s
         where a.assessment_id = cr.revision_id --
         and cr.item_id = ci.item_id
         and ci.parent_id = cf.folder_id
         and s.assessment_id = a.assessment_id
       ) ass, 
site_nodes sa, site_nodes sc, apm_packages p
where sa.object_id = ass.package_id
and sc.node_id = sa.parent_id
and p.package_id = sc.object_id
order by lower(p.instance_name), lower(ass.title)
	</querytext>
</fullquery>
	
</queryset>

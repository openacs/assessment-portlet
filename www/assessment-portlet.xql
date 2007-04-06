<?xml version="1.0"?>
<queryset>

<fullquery name="answered_assessments">
	<querytext>
select * from (select ass.*, sc.node_id as comm_node_id, sa.node_id as as_node_id, p.instance_name as community_name,
acs_permission__permission_p(ass.assessment_id,:user_id,'admin') as admin_p,
	(select count(*) from as_sessions s1,
         cr_revisions cr1 where
         s1.assessment_id=cr1.revision_id and
         cr1.item_id=ass.assessment_id
	 and s1.subject_id=:user_id
         and completed_datetime is null) as in_progress_p,
	(select count(*) from as_sessions s1,
         cr_revisions cr1 where
         s1.assessment_id=cr1.revision_id
         and cr1.item_id=ass.assessment_id
	 and s1.subject_id=:user_id
         and completed_datetime is not null) as completed_p
	

 from 
  (select cr.item_id as assessment_id, cr.title, cr.description, cf.package_id,
	a1.number_tries, a1.end_time
   from as_assessments a, cr_revisions cr, cr_items ci, cr_folders cf,
      as_assessments a1,
      (  select distinct s.assessment_id
         from as_sessions s
         where s.subject_id = :user_id
         and s.completed_datetime is not null) s
         where a.assessment_id = cr.revision_id --
	and cf.package_id in ([join $list_of_package_ids ", "])
         and cr.item_id = ci.item_id
         and ci.parent_id = cf.folder_id
         and s.assessment_id = a.assessment_id
	and a1.assessment_id = ci.latest_revision
       ) ass, 
site_nodes sa, site_nodes sc, apm_packages p
where sa.object_id = ass.package_id
and sc.node_id = sa.parent_id
and p.package_id = sc.object_id
order by lower(p.instance_name), lower(ass.title)
) q
 where (q.number_tries is not null and q.number_tries >0 and q.completed_p >= q.number_tries) or (q.end_time is not null and q.end_time < current_timestamp)
	</querytext>
</fullquery>
	
</queryset>

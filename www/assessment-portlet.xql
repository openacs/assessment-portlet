<?xml version="1.0"?>

<queryset>

	<fullquery name="asssessment_id_name_definition">
		<querytext>
			select asa.assessment_id, cri.name, crr.title, crr.description
			from as_assessments asa, cr_items cri, cr_revisions crr, cr_folders crf
			where crr.revision_id = asa.assessment_id
			  and crr.item_id = cri.item_id
			  and cri.parent_id = crf.folder_id
			  and crf.package_id in ([join $list_of_package_ids ", "])
			order by lower(cri.name)
		</querytext>
	</fullquery>
	
</queryset>

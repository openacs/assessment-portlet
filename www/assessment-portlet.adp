<if @assessments:rowcount@>
<if @shaded_p@ false>

<multiple name="assessments">

  <if @one_instance_p@ false>@assessments.parent_name@</if>

    <ul>
    <group column="package_id">
      <li>
       <a href="@assessments.url@assessment?assessment_id=@assessments.assessment_id@">@assessments.title@</a>
      </li>
     </group>
    </ul>

</multiple>
</if>
</if>
<else>
  &nbsp;  
</else>

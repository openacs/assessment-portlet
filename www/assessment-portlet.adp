<if @assessments:rowcount@ gt 0 or @sessions:rowcount@ gt 0>
  <if @shaded_p@ false>
    <if @assessments:rowcount@ gt 0>
      <h3>#assessment.Open_Assessments#</h3>
      <listtemplate name="assessments"></listtemplate>
    </if>

    <if @sessions:rowcount@ gt 0>
      <h3>#assessment.Closed_Assessments#</h3>
      <listtemplate name="sessions"></listtemplate>
    </if>
  </if>
</if>
<else>
  &nbsp;  
</else>

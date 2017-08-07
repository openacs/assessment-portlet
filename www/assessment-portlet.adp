<if @shaded_p;literal@ false>
  <if @assessments:rowcount@ gt 0 or @sessions:rowcount@ gt 0>
    <if @assessments:rowcount@ gt 0>
      <strong>#assessment.Open_Assessments#</strong>
      <listtemplate name="assessments"></listtemplate>
    </if>

    <if @sessions:rowcount@ gt 0>
      <strong>#assessment.Closed_Assessments#</strong>
      <listtemplate name="sessions"></listtemplate>
    </if>
  </if>
  <else>
    &nbsp;  
  </else>
</if>
<else>
  #new-portal.when_portlet_shaded#
</else>

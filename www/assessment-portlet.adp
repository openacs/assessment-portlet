<if @shaded_p@ false>
  <if @assessments:rowcount@ gt 0 or @sessions:rowcount@ gt 0>
    <if @assessments:rowcount@ gt 0>
      <b>#assessment.Open_Assessments#</b>
      <listtemplate name="assessments"></listtemplate>
    </if>

    <if @sessions:rowcount@ gt 0>
      <b>#assessment.Closed_Assessments#</b>
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

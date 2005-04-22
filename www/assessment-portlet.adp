<if @assessments:rowcount@ gt 0 or @sessions:rowcount@ gt 0>
  <if @shaded_p@ false>
    <if @assessments:rowcount@ gt 0>
      <listtemplate name="assessments"></listtemplate>
    </if>

    <if @sessions:rowcount@ gt 0>
      <h4>#assessment.answered_assessments#</h4>
      <listtemplate name="sessions"></listtemplate>
    </if>
  </if>
</if>
<else>
  &nbsp;  
</else>

  <if @shaded_p@ ne "t">
      <if @one_instance_p@ true>
          <include src="/packages/assessment/lib/user-assessment" package_id="@list_of_package_ids@" />
      </if>
      <else>
          <list name="list_of_package_ids">
              <include src="/packages/assessment/lib/user-assessment" package_id="@list_of_package_ids:item@" />
          </list>
      </else>
  </if>
  <else>
  &nbsp;
  </else>

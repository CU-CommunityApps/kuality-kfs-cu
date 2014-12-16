And /^I create new Proposal document$/  do
  @proposal = create ProposalObject,
                     initial_organizations: [{
                                             chart_code:              get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
                                             organization_code:       fetch_random_department_organization_code,
                                             primary:                 :set,
                                             active:                  :set
                                         }],
                     initial_project_directors: [{
                                                 principal_name:      get_random_principal_name_for_role('KFS-SYS', 'Contracts & Grants Project Director'),
                                                 primary:             :set,
                                                 active:              :set
                                             }]

end

Then /^I should get (account|organization|project director) exists error$/  do |coll_type|
  case coll_type
    when 'account'
      on AwardPage do |page|
        chart_code = page.old_account_chart_code[0..1]
        account_number = page.old_account_number
        step "I should get an error saying \"Account #{chart_code}-#{account_number} already exists on this Award\""
      end
    when 'organization'
      on OrganizationsTab do |tab|
        chart_code = tab.result_organization_chart_code[0..1]
        organization_code = tab.result_organization_code
        on(AwardPage).errors.should include "Organization #{chart_code}-#{organization_code} already exists on this Award"
        # TODO : following step is not working because $current_page is OrganizationsTab which does not have errors
        #step "I should get an error saying \"Organization #{chart_code}-#{organization_code} already exists on this Award\""
      end
    when 'project director'
      pid = identity_service.getEntityByPrincipalName(on(ProjectDirectorsTab).update_project_director_principal_name.value).getPrincipals().getPrincipal().get(0).getPrincipalId()
      on(AwardPage).errors.should include "Project Director #{pid} already exists on this Award"
      #step "I should get an error saying \"Project Director #{pid} already exists on this Award\""
  end
end


And /^I verify the Grant Number change for the Award Document persists on the Proposal Document$/ do
  visit(MainPage).proposal
  on ProposalLookupPage do |page|
    #searching by Proposal# and Grant# and validating that only one Proposal is returned does validate grant number is on proposal
    page.find_proposal_by_proposal_and_grant @proposal.proposal_number, @award.grant_number

    #should only be two rows in table; header row of column names, single data row that we just searched for
    page.results_table.rows.length.should == 2
  end
end


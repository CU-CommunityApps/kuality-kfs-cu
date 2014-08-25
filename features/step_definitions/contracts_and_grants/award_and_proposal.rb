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

When /^I create a new Award document from the Proposal document$/ do
  @award = create AwardObject,
                  initial_award_accounts: [{
                                              chart_code:               get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
                                              principal_name:           get_random_principal_name_for_role('KFS-SYS', 'Contracts & Grants Project Director'),
                                              account_number:           get_account_of_type('Grant'),
                                              active:                   :set
                                          }]

  @award.pick_proposal @proposal
end

And /^I change the Grant Number for the Award Document$/ do
  on(AwardPage).grant_number.fit  random_alphanums(15, 'AFT')
  @award.grant_number = on(AwardPage).grant_number.value
end

And /^I verify Grant Number change persists on the Award document$/ do
  @award.view_via :inquiry
  on(AwardInquiryPage).grant_number.should == @award.grant_number
end

And /^the Award document is populated by the Proposal document's fields$/ do
  on AwardPage do |page|
    page.agency_number.value.should == @proposal.agency_number
    page.direct_cost_amount.value.to_f.should == @proposal.direct_cost_amount.to_f
    page.indirect_cost_amount.value.to_f.should == @proposal.indirect_cost_amount.to_f
    page.purpose_code.selected_options.first.text.should == @proposal.purpose_code
  end
  on OrganizationsTab do |tab|
    tab.result_organization_code.should == @proposal.organizations.first.organization_code
    tab.result_organization_chart_code.should == @proposal.organizations.first.chart_code
  end
  on(ProjectDirectorsTab).update_project_director_principal_name.value.should == @proposal.project_directors.first.principal_name
end

And /^I lookup an Award$/ do
  visit(MainPage).award
  on AwardLookupPage do |page|
    page.active_yes.set
    page.grant_description.fit 'CON - Contract' # to limit the results?
    page.search
    page.edit_random # This should throw a fail if the item isn't found.
    page.use_new_tab
    page.close_parents
  end
end

And /^I edit a random Award$/ do
  step 'I lookup an Award'
  @award = make AwardObject
  on(AwardPage).description.fit @award.description
  @award.absorb! :old
end

When /^I edit a previously-approved Award$/ do

  visit(MainPage).award
  on AwardLookupPage do |page|
    page.proposal_number.fit @award.proposal_number
    page.grant_number.fit @award.grant_number
    page.search
    page.edit_value_links.first.click
    page.use_new_tab
    page.close_parents
  end
  @award = make AwardObject
  on(AwardPage).description.fit @award.description
  @award.absorb! :old
end

And /^I deactivate the account for the Award Document$/ do
  on(AwardPage).update_account_active_indicator.clear
end

And /^I add an existing (account|organization|project director) to the Award Document$/ do |coll_type|
  # Award must have at least one account.  organization/project director are optional
  case coll_type
    when 'account'
      on AwardPage do |page|
        @award.add_award_account_line({
                                          chart_code:               page.old_account_chart_code,
                                          principal_name:           page.old_account_project_director_principal_name,
                                          account_number:           page.old_account_number,
                                          active:                   :set
                                      })
      end
    when 'organization'
      on OrganizationsTab do |tab|
        if tab.current_organization_count.to_i > 0
          @award.add_organization_line({
                                           chart_code:                  tab.old_organization_chart_code,
                                           organization_code:           tab.old_organization_code,
                                           active:                      :set
                                       })
        else
          # if there is no organization exists, then add 2 identicals
          new_chart_code  = get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
              new_organization_code = fetch_random_department_organization_code,

              @award.add_organization_line({
                                               chart_code:                   new_chart_code,
                                               organization_code:            new_organization_code,
                                               active:                       :set
                                           })
          @award.add_organization_line({
                                           chart_code:                   new_chart_code,
                                           organization_code:            new_organization_code,
                                           active:                       :set
                                       })
        end
      end
    when 'project director'
      on ProjectDirectorsTab do |tab|
        if tab.current_project_director_count.to_i > 0
          @award.add_project_director_line({
                                               principal_name:           tab.old_project_director_principal_name,
                                               active:                   :set
                                           })
        else
          # if there is no project director exists, then add 2 identicals
          new_principal_name = get_random_principal_name_for_role('KFS-SYS', 'Contracts & Grants Project Director')
          @award.add_project_director_line({
                                               principal_name:          new_principal_name,
                                               active:                  :set
                                           })
          @award.add_project_director_line({
                                               principal_name:          new_principal_name,
                                               active:                  :set
                                           })

        end
      end
  end
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

And /^I delete duplicate (account|organization|project director) from the Award document$/ do |coll_type|
  case coll_type
    when 'account'
      on(AwardPage).delete_account(on(AwardPage).current_account_count.to_i - 1)
    when 'organization'
      on(OrganizationsTab).delete_organization(on(OrganizationsTab).current_organization_count.to_i - 1)
    when 'project director'
      on(ProjectDirectorsTab).delete_project_director(on(ProjectDirectorsTab).current_project_director_count.to_i - 1)
  end
end



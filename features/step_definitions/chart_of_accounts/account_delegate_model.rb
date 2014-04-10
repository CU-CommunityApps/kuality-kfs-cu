When /^I (.*) an Account Delegate Model document with an invalid Organization Code$/ do |button|
  @account_delegate_model = create AccountDelegateModelObject, organization_code: 'BSBS', press: button.gsub(' ', '_')
end

And /^I edit an Account Delegate Model$/ do
  visit(MainPage).account_delegate_model
  on AccountDelegateModelLookupPage do |page|
    # TODO: make random select of edit, as currently need all three variables to select edit button
    page.chart_of_accounts_code.fit      get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
#    page.organization_code.fit           '0100'
#    page.account_delegate_model_name.fit '0100 MOD 1'
#    page.active_indicator_both.set
    page.search
    page.edit_random
  end
  @account_delegate_model = make AccountDelegateModelObject
end

Then /^I should return to the Main Menu$/ do
  on(MainPage).account_delegate_model_link.should be_present
end

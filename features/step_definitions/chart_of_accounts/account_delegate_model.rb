When /^I (.*) an Account Delegate Model document with an invalid Organization Code$/ do |button|
  button.gsub!(' ', '_')
  @account_delegate_model = create AccountDelegateModelObject, org_code: '0000', press: button
end

And /^I edit an Account Delegate Model$/ do
  visit(MainPage).account_delegate_model
  on AccountDelegateModelLookupPage do |page|
    # TODO: make random select of edit, as currently need all three variables to select edit button
    page.chart_of_accounts_code.fit      'IT'
    page.organization_code.fit           '0100'
    page.account_delegate_model_name.fit '0100 MOD 1'
    page.active_indicator_both.set
    page.search
    page.edit_random
  end
end

When /^I cancel the Account Delegate Model document/ do
  on(AccountDelegateModelPage).cancel
  on(YesOrNoPage).yes
end

Then /^I should return to the Main Menu$/ do
  on(MainPage).account_delegate_model_link.should be_present
end

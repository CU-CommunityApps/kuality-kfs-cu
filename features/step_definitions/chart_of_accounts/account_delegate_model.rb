
When /^I (.*) an Account Delegate Model document with an invalid Organization Code$/ do |button|
  button.gsub!(' ', '_')
  @account_delegate_model = create AccountDelegateModelObject, org_code: '0000', press: button
end

And(/^I Edit an Account Delegate Model$/) do
  visit(MainPage).account_delegate_model
   @accountDelegateModel = create AccountDelegateModelObject ,chart_of_accounts_code: 'IT', organization_code: '0100', adm_name: '0100 MOD 1'

  on AccountDelegateModelPage do |page|
    page.search
    #TODO:: make random select of edit, as currently need all three variables to select edit button
    page.edit_account_delegate_model(@accountDelegateModel.chart_of_accounts_code, @accountDelegateModel.organization_code, @accountDelegateModel.adm_name ) #:adm_name # or random select
  end
end

When(/^I cancel the eDoc$/) do
  on AccountDelegateModelPage do |page|
    page.cancel
    #TODO:: Check with Kyle about global yes button
    page.yes_account_delegate_model
  end
end

Then(/^I should return to the Main Menu$/) do
  on(MainPage).account_delegate_model_link.should be_present
end

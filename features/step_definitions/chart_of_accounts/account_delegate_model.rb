When(/^I create an Account Delegate Model with an invalid Organization Code$/) do
  @account_delegate_model = create AccountDelegateModelObject, org_code: '0000', press: AccountDelegateModelPage::SUBMIT
end
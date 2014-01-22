When /^I (.*) an Account Delegate Model with an invalid Organization Code$/ do |button|
  button.gsub!(' ', '_')
  @account_delegate_model = create AccountDelegateModelObject, org_code: '0000', press: button
end
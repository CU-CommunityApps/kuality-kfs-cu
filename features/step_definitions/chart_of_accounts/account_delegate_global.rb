And /^I create an Account Delegate Global with multiple account lines$/ do
  @account_delegate_global = create AccountDelegateGlobalObject
end

When /^I (#{AccountDelegateGlobalPage::available_buttons}) an Account Delegate Global document$/ do |button|
  button.gsub!(' ', '_')
  @account_delegate_global = create AccountDelegateGlobalObject, press: button
end

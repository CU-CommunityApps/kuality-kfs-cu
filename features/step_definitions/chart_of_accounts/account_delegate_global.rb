And /^I create an Account Delegate Global with multiple account lines$/ do
  @account_delegate_global = create AccountDelegateGlobalObject
end

When /^I (#{AccountDelegateGlobalPage::available_buttons}) an Account Delegate Global document$/ do |button|
  button.gsub!(' ', '_')
  @account_delegate_global = create AccountDelegateGlobalObject, press: button
end

When /^I (#{AccountDelegateGlobalPage::available_buttons}) the Account Delegate Global document$/ do |button|
  button.gsub!(' ', '_')
  @account_delegate_global.send(button)
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

Then /^the Account Delegate Global document goes to (.*)/ do |doc_status|
  sleep(5)
  @account_delegate_global.view
  on(AccountDelegateGlobalPage).document_status.should == doc_status
end

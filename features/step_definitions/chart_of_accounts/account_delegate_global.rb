And /^I create an Account Delegate Global with multiple account lines$/ do
  @account_delegate_global = create AccountDelegateGlobalObject
end

When /^I submit the Account Delegate Global document$/ do
  @account_delegate_global.submit
end

Then /^the Account Delegate Global document goes to (.*)/ do |doc_status|
  sleep(5)
  @account_delegate_global.view
  on(AccountDelegateGlobalPage).document_status.should == doc_status
end

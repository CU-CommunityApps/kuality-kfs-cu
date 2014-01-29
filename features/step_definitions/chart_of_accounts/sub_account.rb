And /^I (#{SubAccountPage::available_buttons}) a Sub-Account document$/ do |button|
  @sub_account = create SubAccountObject, press: button.gsub(' ', '_')
end

And /^I Create a Sub-Account with Sub-Account Type CS$/ do
  @sub_account = create SubAccountObject, type_code: 'CS', press: :save
end

When /^I tab away from the Account Number field$/ do
  on SubAccountPage do |page|
    page.account_number.select
    page.account_number.send_keys :tab
  end
end

Then /^The Indirect Cost Rate ID field should not be null$/ do
  on(SubAccountPage).icr_identifier.value.should == ''
end

And /^I am logged in as the FO of the Account$/ do
  sleep(1)
  #TODO user service to do this in future
  step 'I am logged in as "nja3"'
  @user_id = 'nja3'
end

And /^The Sub-Account document should be in my action list$/ do
  sleep(5)
  on(ActionList).viewAsUser(@user_id)
  on(ActionList).last if on(ActionList).last_link.exists?
  on(ActionList).result_item(@sub_account.document_id).should exist
end

When(/^I am logged in as a Contract and Grant Processor$/) do
  sleep(1)
  #TODO user service to do this in future
  step 'I am logged in as "drs4"'
  @user_id = 'drs4'
end

And /^I (#{SubAccountPage::available_buttons}) a Sub-Account for blanket approval through action list routing with user "(.*)"$/ do |button, approver_user|
  @sub_account = create SubAccountObject, press: button, account_number: '1258321',
  cost_sharing_chart_of_accounts_code: 'IT - Ithaca Campus', cost_share_account_number: '1254601',
  adhoc_approver_userid: approver_user, sub_account_type_code: 'CS', cost_sharing_account_number: '1254601'
end

And /^I submit the Sub\-Account Document$/ do
  @sub_account.submit
end

And /^The Sub Account document will become (.*)$/ do  |status|
  @sub_account.view
  on(SubAccountPage).document_status.should == status
end

When /^The Sub\-Account Document is in my Action List$/ do
  visit(MainPage).action_list
  on(ActionList).last if on(ActionList).last_link.exists?

  on(ActionList).open_item(@sub_account.document_id)
end

Then /^I can Blanket Approve the Sub\-Account Document$/ do
  @sub_account.blanket_approve
end
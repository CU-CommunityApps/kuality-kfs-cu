And /^I create a Sub-Account$/ do
  @sub_account = create SubAccountObject, press: SubAccountPage::SAVE
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

And /^I create a Sub-Account for 589$/ do
  @sub_account = create SubAccountObject, press: SubAccountPage::SAVE,  account_number: '1258321',
  cost_sharing_chart_of_accounts_code: 'IT - Ithaca Campus', cost_share_account_number: '1254601'
end

And /^I enter Sub\-Account Type (.*)$/ do |sub_account_type_code|
  on SubAccountPage do |page|
    page.sub_account_type_code.fit sub_account_type_code
  end
end

And /^I enter an Adhoc Approver$/ do
  on SubAccountPage do |page|
    page.expand_all
    page.ad_hoc_person.set 'jis45'
  end
end

And /^I submit the Sub\-Account Document$/ do
  @sub_account.submit
end

And /^The Sub Account document will become (.*)$/ do  |status|
  on SubAccountPage do |page|
    page.reload
    sleep 10
    page.reload
    sleep 25
    page.document_status.should == status
  end
end

When /^The Sub\-Account Document is in my Action List$/ do
  visit(MainPage).action_list
  puts @sub_account.document_id.inspect
  on(ActionListInbox).open_item(@sub_account.document_id)
  sleep 20
end

Then /^I can Blanket Approve the Sub\-Account Document$/ do
  @sub_account.blanket_approve
end
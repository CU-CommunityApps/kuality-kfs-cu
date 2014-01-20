And /^I create a Sub-Account$/ do
  @sub_account = create SubAccountObject, press: SubAccountPage::SAVE
end

And /^I Create a Sub-Account with Sub-Account Type CS$/ do
  @sub_account = create SubAccountObject, type_code: 'CS', press: SubAccountPage::SAVE
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

And /^I submit the Sub-Account$/ do
  @sub_account.submit
end


And /^I am logged in as the FO of the Account$/ do
  sleep(1)
  #TODO user service to do this in future
  step 'I am logged in as "nja3"'
end

And /^The Sub-Account document should be in my action list$/ do
  visit(ActionList).last
  search_results_table.result_item(@sub_account.document_id).should exist
end

And /^I approve the document$/ do
  @sub_account.view
  @sub_account.submit
end

When(/^I am logged in as a Contract and Grant Processor$/) do
  sleep(1)
  #TODO user service to do this in future
  step 'I am logged in as "drs4"'
end

Then /^the Sub-Account document goes to (.*)$/ do |doc_status|
  @sub_account.view
  on(SubAccountPage).document_status.should == doc_status
end

And /^I (#{SubAccountPage::available_buttons}) a Sub-Account document$/ do |button|
  button.gsub!(' ', '_')
  @sub_account = create SubAccountObject, press: button
end

When /^I (#{SubAccountPage::available_buttons}) the Sub-Account document$/ do |button|
  button.gsub!(' ', '_')
  on(SubAccountPage).send(button)
  sleep 10 if button == 'blanket_approve'
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
  @user_id = 'nja3'
end

And /^The Sub-Account document should be in my action list$/ do
  on(ActionList).viewAsUser(@user_id)

  if on(ActionList).last_link.exists?
    on(ActionList).last
  end
  on(ActionList).result_item(@sub_account.document_id).should exist
end

And /^I approve the document$/ do
  @sub_account.view
  @sub_account.approve
end

When(/^I am logged in as a Contract and Grant Processor$/) do
  sleep(1)
  #TODO user service to do this in future
  step 'I am logged in as "drs4"'
  @user_id = 'drs4'
end

Then /^the Sub-Account document goes to (.*)$/ do |doc_status|
  @sub_account.view
  on(SubAccountPage).document_status.should == doc_status
end

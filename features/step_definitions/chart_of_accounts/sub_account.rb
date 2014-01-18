And /^I (#{SubAccountPage::available_buttons}) a Sub-Account$/ do |button|
  @sub_account = create SubAccountObject, press: button
end

When /^I (#{SubAccountPage::available_buttons}) the Sub-Account document$/ do |button|
  button.gsub!(' ', '_')
  on(SubAccountPage).send(button)
  sleep 10 if button == 'blanket_approve'
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
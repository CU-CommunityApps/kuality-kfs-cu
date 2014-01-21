When /^I (#{AccountDelegatePage::available_buttons}) an Account Delegate$/ do |button|
  @accountDelegate = create AccountDelegateObject, press: button
end

Then /^the Approval From This Amount and Approval To This Amount fields should be blank$/ do
  on AccountDelegatePage do |page|
    page.approval_from_amount.nil?
    page.approval_to_amount.nil?
  end
end
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
  step 'I am logged in as "' + @account.accountFiscalOfficerUser.principalName + '"'
  @user_id = 'fiscal_officer_principal_name'
end

And /^I am logged in as the FO of the Sub-Account$/ do
  sleep(1)
  account_info = get_kuali_business_object('KFS-COA','Account','accountNumber=' + @sub_account.account_number)
  fiscal_officer_principal_name = account_info['accountFiscalOfficerUser.principalName'][0].to_s
  step "I am logged in as \"#{fiscal_officer_principal_name}\""
  @user_id = fiscal_officer_principal_name
end

And /^The Sub-Account document should be in my action list$/ do
  sleep(5)
  on(ActionList).view_as(@user_id)
  on(ActionList).last if on(ActionList).last_link.exists?
  on(ActionList).result_item(@sub_account.document_id).should exist
end

And /^I (#{SubAccountPage::available_buttons}) a Sub-Account through action list routing with adhoc approver user "(.*)"$/ do |button, approver_user|
  options = {
    account_number:                      '1258321',
    cost_sharing_chart_of_accounts_code: 'IT - Ithaca Campus',
    cost_share_account_number:           '1254601',
    sub_account_type_code:               'CS',
    cost_sharing_account_number:         '1254601',
    adhoc_approver_userid:               approver_user,
    press: button.gsub(' ', '_')
  }

  @sub_account = create SubAccountObject, options
end

When /^the Sub\-Account Document is in my Action List$/ do
  visit(MainPage).action_list
  on(ActionList).last if on(ActionList).last_link.exists?

  on(ActionList).open_item(@sub_account.document_id)
end
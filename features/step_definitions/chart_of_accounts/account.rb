And /^I create an Account$/ do
  @account = create AccountObject, press: AccountPage::SAVE
end

And /^I create an Account with a lower case Sub Fund Program$/ do
  @account = create AccountObject, sub_fnd_group_cd: 'board', press: AccountPage::SAVE
end

When /^I submit the Account$/ do
  @account.submit
end

When /^I blanket approve the Account$/ do
  @account.blanket_approve
  sleep(10)
end

Then /^the Account Maintenance Document goes to (.*)/ do |doc_status|
  @account.view
  on(AccountPage).document_status.should == doc_status
end

When /^I create an account with blank SubFund group Code$/ do
  @account = create AccountObject, sub_fnd_group_cd: '', press: AccountPage::SUBMIT
end

Then /^I should get an error on saving that I left the SubFund Group Code field blank$/ do
  on(AccountPage).errors.should include 'Sub-Fund Group Code (SubFundGrpCd) is a required field.'
end

And /^I copy an Account$/ do
  steps %{
    Given I access Account Lookup
    And   I search for all accounts
  }
  on AccountLookupPage do |page|
    page.copy_random
  end
  on AccountPage do |page|
    page.description.set 'testing copy'
    page.save
  end
end

Then /^the Account Maintenance Document saves with no errors$/  do
  on(AccountPage).document_status.should == 'SAVED'
end

Then /^the Account Maintenance Document has no errors$/  do
  on(AccountPage).document_status.should == 'ENROUTE'
end

And /^I edit an Account$/ do
  visit(MainPage).account
  on AccountLookupPage do |page|
    page.search
    page.edit_random
  end
end

And /^I edit an Account to enter a Sub Fund Program in lower case$/ do
  visit(MainPage).account
  on AccountLookupPage do |page|
    page.subfund_program_code.set 'BOARD'
    page.search
    page.edit_random
  end
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set random_alphanums(40, 'AFT')
    page.subfund_program_code.set 'board'
    page.save
  end
end

When(/^I enter (.*) as an invalid Sub-Fund Program Code$/) do |sub_fund_program_code|
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set random_alphanums(40, 'AFT')
    page.subfund_program_code.set sub_fund_program_code
    page.save
  end
end

Then /^an error in the (.*) tab should say (.*)$/ do |tab, error|
  @error_msg = ''
  on AccountPage do |page|
    case tab
      when 'Account Maintenance'
        @error_msg = page.account_maintenance_errmsg.text
      else
        page.save
    end
  end
  @error_msg.should == error
end


And /^I edit an Account with a Sub-Fund Group Code of (.*)/ do |sub_fund_group_code|
  visit(MainPage).account
  on AccountLookupPage do |page|
    page.sub_fnd_group_cd.set sub_fund_group_code
    page.search
    page.edit_random
  end
end
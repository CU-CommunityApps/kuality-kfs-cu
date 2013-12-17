And /^I create an Account$/ do
  @account = create AccountObject
end

When /^I submit the Account$/ do
  @account.submit
end

Then /^the Account Maintenance Document goes to final$/ do
  @account.view
  on(AccountPage).document_status.should == 'Final'
end

When /^I create an account with blank SubFund group Code$/ do
  @account = create AccountObject, sub_fnd_group_cd: ''
end

Then /^I should get an error on saving that I left the SubFund Group Code field blank$/ do
#  on AccountPage do |page|
#    page.errors.should include 'Sub-Fund Group Code (SubFundGrpCd) is a required field.'
  on(AccountPage).errors.should include 'Sub-Fund Group Code (SubFundGrpCd) is a required field.'
 # end
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
And /^I create an Account$/ do
  @account = create AccountObject
end

When /^I submit the Account$/ do
  @account.submit
end

Given /^I am logged in as a KFS Fiscal Officer$/ do
  visit LoginPage do |page|
    page.username.set 'jguillor'
    page.login
  end
end

Then /^the Account Maintenance Document goes to final$/ do
  @account.view
  on Account do |page|
    page.header_status.should == 'Final'
  end
end
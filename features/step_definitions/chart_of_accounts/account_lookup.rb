

When(/^I am logged in as a KFS Fiscal Officer am logged in as a kfs user$/) do
  visit LoginPage do |page|
    page.username.set 'jguillor'
    page.login
  end
end

When(/^I access acct lookup$/) do
  visit(MainPage).account
end

Then(/^the acct lookup should appear$/) do
  on AccountLookup do |page|
    page.chart_code.should exist
  end
end

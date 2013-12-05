

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

When(/^I enter an account number and search$/) do
  on AccountLookup do |page|
    page.number.set '0142900'
    page.search
  end
end

When(/^The account is found$/) do
  on AccountLookup do |page|
    page.item_row('0142900').should exist
  end
end
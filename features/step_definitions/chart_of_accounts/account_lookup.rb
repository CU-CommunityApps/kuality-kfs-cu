

When(/^I access Account Lookup$/) do
  visit(MainPage).account
end

Then(/^the Account Lookup page should appear$/) do
  on AccountLookup do |page|
    page.chart_code.should exist
  end
end

When(/^I enter an Account Number and search$/) do
  on AccountLookup do |page|
    page.number.set '0142900'
    page.search
  end
end

When(/^The Account is found$/) do
  on AccountLookup do |page|
    page.item_row('0142900').should exist
  end
end
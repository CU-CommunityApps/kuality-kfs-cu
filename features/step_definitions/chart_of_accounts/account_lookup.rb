
When /^I access Account Lookup$/ do
  visit(MainPage).account
end

Then /^the Account Lookup page should appear$/ do
  on AccountLookupPage do |page|
    page.chart_code.should exist
  end
end

When /^I enter an Account Number and search$/ do
  on AccountLookupPage do |page|
    page.number.set '0142900'
    page.search
  end
end

When /^I access Account Lookup$/ do
  visit(MainPage).account
end

When /^I search for all accounts$/ do
  on AccountLookupPage do |page|
    page.search
  end
end

When /^The Account is found$/ do
  on AccountLookupPage do |page|
    page.item_row('0142900').should exist
  end
end

Then /^the Account Lookup page should appear with Cornell custom fields$/ do
  on AccountLookupPage do |page|
    page.responsibility_center_code.should exist
    page.reports_to_org_code.should exist
    page.reports_to_coa_code.should exist
    page.fund_group_code.should exist
    page.subfund_program_code.should exist
    page.appropriation_acct_number.should exist
    page.major_reporting_category_code.should exist
    page.acct_manager_principal_name.should exist
    page.acct_supervisor_principal_name.should exist
  end
end
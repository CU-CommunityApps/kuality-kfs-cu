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

When /^I search for all accounts$/ do
  on(AccountLookupPage).search
end

When /^The Account is found$/ do
  on AccountLookupPage do |page|
    page.item_row('0142900').should exist
  end
end

When /^Accounts should be returned$/ do
  on AccountLookupPage do |page|
    page.results_table.should exist
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

When /^I lookup an Account with (.*)$/ do |field_name|
  on AccountLookupPage do |page|
    case
      when field_name == 'Account Manager Principal Name '
        page.acct_manager_principal_name.set 'nja3' #TODO get from ROLE SERVICE
      when field_name == 'Account Supervisor Principal Name'
        page.acct_supervisor_principal_name.set 'jcs28' #TODO get from ROLE SERVICE
    end
    page.search
  end
end
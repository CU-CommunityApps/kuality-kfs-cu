And /^I create an Account Global edoc$/ do
  @account_global = create AccountGlobalObject
end

And /^I perform a Major Reporting Category Code Lookup$/ do
  on AccountGlobalPage do |page|
    page.major_reporting_code_lookup
  end
  on Lookups do |page|
    page.search
  end
end

Then /^I should see a list of Major Reporting Category Codes$/ do
  on Lookups do |page|
    page.return_value_links.size.should > 0
  end
end

And(/^I create an Account Global maintenance document with multiple accounting lines$/) do
  @account_global = create AccountGlobalObject,
                           add_multiple_accounting_lines: 'yes',
                           search_account_number: '10007*'
end

When(/^I submit the document$/) do
  @account_global.submit
end

Then(/^the document should go to final$/) do
  on(AccountGlobalPage) do |page|
    page.reload
    page.document_status.should == 'FINAL'
  end
end
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

And /^I create an Account Global maintenance document with multiple accounting lines$/ do
  @account_global = create AccountGlobalObject,
                           add_multiple_accounting_lines: 'yes',
                           search_account_number: '10007*'
end

When /^I submit the Account Global maintenance document$/ do
  @account_global.submit
end

And /^I create an Account Global eDoc with an existing Major Reporting Category$/ do
  @account_global = create AccountGlobalObject,
                           major_reporting_category_code: 'FACULTY' # TODO: It would be nice if this could be obtained either through a search or a service, instead of being hard-coded.
end

Then /^The Account Global eDoc will become final$/ do
  on AccountGlobalPage do |page|
    sleep 10
    page.reload
    page.document_status.should == 'FINAL'
  end
end
And /^I (#{AccountGlobalPage::available_buttons}) an Account Global Maintenance document$/ do |button|
  @account_global = create AccountGlobalObject, press: button
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

And /^I (.*) an Account Global Maintenance document with multiple accounting lines$/ do |button|
  @account_global = create AccountGlobalObject,
                           supervisor_principal_name:  '',
                           manager_principal_name: '',
                           org_cd:               '',
                           sub_fnd_group_code:   '',
                           acct_expire_date:     '',
                           postal_code:            '',
                           city:                 '',
                           state:                '',
                           address:              '',
                           contintuation_coa_code: '',
                           contintuation_acct_number: '',
                           income_stream_financial_cost_cd:  '',
                           income_stream_account_number:     '',
                           sufficient_funds_cd:    '',
                           add_multiple_accounting_lines: 'yes',
                           search_account_number: '10007*',
                           press: button
end

When /^I (.*) the Account Global Maintenance document$/ do |button|
  button.gsub!(' ', '_')
  @account_global.send(button)
  sleep 10 if button == 'blanket_approve'
end

Then /^The Account Global Maintenance document will become (.*)/ do |status|
  on AccountGlobalPage do |page|
    sleep 10
    page.reload
    page.document_status.should == status
  end
end

When /^I (.*) a Account Global Maintenance document with a Major Reporting Category Code of (.*)$/ do |button, value_for_field|
  @account_global = create AccountGlobalObject,
                           supervisor_principal_name:  '',
                           manager_principal_name: '',
                           org_cd:               '',
                           sub_fnd_group_code:   '',
                           acct_expire_date:     '',
                           postal_code:            '',
                           city:                 '',
                           state:                '',
                           address:              '',
                           contintuation_coa_code: '',
                           contintuation_acct_number: '',
                           income_stream_financial_cost_cd:  '',
                           income_stream_account_number:     '',
                           sufficient_funds_cd:    '',
                           major_reporting_category_code: "#{value_for_field}",
                           press: button
  # TODO: It would be nice if this could be obtained either through a search or a service, instead of being hard-coded.
  #changed this code to allow for user to enter valid and invalid major reporting category code for 2 different tests
end

When /^I enter a valid Major Reporting Category Code of (.*)$/ do |value_of_field|
  on AccountGlobalPage do |page|
    page.major_reporting_category_code.fit "#{value_of_field}"
  end
end

Then /^account global should show an error that says "(.*?)"$/ do |error|
  on(AccountGlobalPage).errors.should include error
end

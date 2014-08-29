And /^I (.*) an Account Global Maintenance document with blank Fiscal Officer Principal Name, Account Supervisor Principal Name, Account Manager Name, and CFDA fields$/ do |button|
  visit(MainPage).account
  random_account_number = on(AccountLookupPage).get_random_account_number
  @account_global = create AccountGlobalObject, fo_principal_name: '',
                                                supervisor_principal_name: '',
                                                manager_principal_name: '',
                                                cfda_number: '',
                                                income_stream_account_number: random_account_number,
                                                press: button.gsub(' ', '_')
end

And /^I (.*) an Account Global Maintenance document with these fields blank:$/ do |button, fields|
  fields = fields.raw.flatten
  mappings = {
    'Description'                                   => :description,
    'Chart Code'                                    => :new_chart_code,
    'Account Number'                                => :new_number,
    'Account Supervisor Principal Name'             => :supervisor_principal_name,
    'Account Manager Principal Name'                => :manager_principal_name,
    'Organization Code'                             => :organization_code,
    'Sub-Fund Group Code'                           => :sub_fund_group_code,
    'Account Expiration Date'                       => :acct_expire_date,
    'Account Postal Code'                           => :postal_code,
    'Account City Name'                             => :city,
    'Account State Code'                            => :state,
    'Account Street Address'                        => :address,
    'Continuation Chart Of Accounts Code'           => :continuation_coa_code,
    'Continuation Account Number'                   => :continuation_acct_number,
    'Income Stream Chart Of Accounts Code'          => :income_stream_financial_cost_code,
    'Income Stream Account Number'                  => :income_stream_account_number,
    'CFDA Number'                                   => :cfda_number,
    'Higher Education Function Code'                => :higher_ed_funct_code,
    'Account Sufficient Funds Code'                 => :sufficient_funds_code,
    'Transaction Processing Sufficient Funds Check' => :trans_processing_sufficient_funds_code,
    'Labor Benefit Rate Category Code'              => :labor_benefit_rate_category_code
  }
  blank_fields = {
    :description                            => '',
    :new_chart_code                         => '',
    :new_number                             => '',
    :supervisor_principal_name              => '',
    :manager_principal_name                 => '',
    :organization_code                      => '',
    :sub_fund_group_code                    => '',
    :acct_expire_date                       => '',
    :postal_code                            => '',
    :city                                   => '',
    :state                                  => '',
    :address                                => '',
    :continuation_coa_code                  => '',
    :continuation_acct_number               => '',
    :income_stream_financial_cost_code      => '',
    :income_stream_account_number           => '',
    :cfda_number                            => '',
    :higher_ed_funct_code                   => '',
    :sufficient_funds_code                  => '',
    :trans_processing_sufficient_funds_code => '',
    :labor_benefit_rate_category_code       => ''
  }

  visit(MainPage).account
  random_account_number = on(AccountLookupPage).get_random_account_number

  options = {
    income_stream_account_number: random_account_number,
    press: button.gsub(' ', '_')
  }.merge!(blank_fields.keep_if{ |bf| mappings.keep_if{ |m| fields.include?(m) }.values.include?(bf) })

  @account_global = create AccountGlobalObject, options
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
                           organization_code:               '',
                           sub_fund_group_code:   '',
                           acct_expire_date:     '',
                           postal_code:            '',
                           city:                 '',
                           state:                '',
                           address:              '',
                           continuation_coa_code: '',
                           continuation_acct_number: '',
                           income_stream_financial_cost_code:  '',
                           income_stream_account_number:     '',
                           sufficient_funds_code:    '',
                           add_multiple_accounting_lines: 'yes',
                           search_account_number: '10007*',
                           press: button
end

When /^I (.*) an Account Global Maintenance document with a Major Reporting Category Code of (.*)$/ do |button, value_for_field|
  @account_global = create AccountGlobalObject,
                           supervisor_principal_name:  '',
                           manager_principal_name: '',
                           organization_code:               '',
                           sub_fund_group_code:   '',
                           acct_expire_date:     '',
                           postal_code:            '',
                           city:                 '',
                           state:                '',
                           address:              '',
                           continuation_coa_code: '',
                           continuation_acct_number: '',
                           income_stream_financial_cost_code:  '',
                           income_stream_account_number:     '',
                           sufficient_funds_code:    '',
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

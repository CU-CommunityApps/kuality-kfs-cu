And /^I edit an Account to enter a Sub Fund Program in lower case$/ do
  visit(MainPage).account
  on AccountLookupPage do |page|
    page.subfund_program_code.set 'BOARD' #TODO config
    page.search
    page.edit_random
  end
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set random_alphanums(40, 'AFT')
    page.subfund_program_code.set 'board' #TODO config
    page.save
  end
end

When /^I enter a Sub-Fund Program Code of (.*)$/ do |sub_fund_program_code|
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set random_alphanums(40, 'AFT')
    page.subfund_program_code.set sub_fund_program_code
    page.save
  end
end



When /^I enter (.*) as an invalid Major Reporting Category Code$/  do |major_reporting_category_code|
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set random_alphanums(40, 'AFT')
    page.major_reporting_category_code.fit major_reporting_category_code
    page.save
  end
end

When /^I enter (.*) as an invalid Appropriation Account Number$/  do |appropriation_account_number|
  on AccountPage do |page|
    @account = make AccountObject
    page.description.set random_alphanums(40, 'AFT')
    page.appropriation_account_number.fit appropriation_account_number
    page.save
  end
end

When /^I save an Account document with only the ([^"]*) field populated$/ do |field|
  default_fields = {
      description:          random_alphanums(40, 'AFT'),
      chart_code:           get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
      number:               random_alphanums(7),
      name:                 random_alphanums(10),
      organization_code:    '01G0',#TODO config?
      campus_code:          get_aft_parameter_value(ParameterConstants::DEFAULT_CAMPUS_CODE),
      effective_date:       '01/01/2010',
      postal_code:          get_random_postal_code('*'),
      city:                 get_generic_city,
      state:                get_random_state_code,
      address:              get_generic_address_1,
      type_code:            get_aft_parameter_value(ParameterConstants::DEFAULT_CAMPUS_TYPE_CODE),
      sub_fund_group_code:  'ADMSYS',#TODO config?
      higher_ed_funct_code: '4000',#TODO config?
      restricted_status_code:     'U - Unrestricted',#TODO config?
      fo_principal_name:          get_aft_parameter_value(ParameterConstants::DEFAULT_FISCAL_OFFICER),
      supervisor_principal_name:  get_aft_parameter_value(ParameterConstants::DEFAULT_SUPERVISOR),
      manager_principal_name: get_aft_parameter_value(ParameterConstants::DEFAULT_MANAGER),
      budget_record_level_code:   'C - Consolidation',#TODO config?
      sufficient_funds_code:      'C - Consolidation',#TODO config?
      expense_guideline_text:     'expense guideline text',
      income_guideline_txt: 'incomde guideline text',
      purpose_text:         'purpose text',
      labor_benefit_rate_cat_code: 'CC'#TODO config?
  }

  # TODO: Make the Account document creation with a single field step more flexible.
  case field
    when 'Description'
      default_fields.each {|k, _| default_fields[k] = '' unless k.to_s.eql?('description') }
  end

  @account = create AccountObject, default_fields.merge({press: :save})
end

When /^I input a lowercase Major Reporting Category Code value$/  do
  major_reporting_category_code = get_kuali_business_object('KFS-COA','MajorReportingCategory','active=Y')['majorReportingCategoryCode'].sample
  on(AccountPage).major_reporting_category_code.fit major_reporting_category_code.downcase
end

And /^I create an Account with an Appropriation Account Number of (.*) and Sub-Fund Program Code of (.*)/ do |appropriation_accountNumber, subfund_program_code|
  @account = create AccountObject
  on AccountPage do |page|
    page.appropriation_account_number.set appropriation_accountNumber
    page.subfund_program_code.set subfund_program_code
    @account.document_id = page.document_id
  end

end

And /^I enter Appropriation Account Number of (.*)/  do |appropriation_account_number|
  on(AccountPage).appropriation_account_number.set appropriation_account_number
end

And /^I clone Account (.*) with the following changes:$/ do |account_number, table|
  unless account_number.empty?
    account_number = account_number == 'nil' ? nil : account_number
    updates = table.rows_hash
    updates.delete_if { |k,v| v.empty? }
    updates['Indirect Cost Recovery Active Indicator'] = updates['Indirect Cost Recovery Active Indicator'].to_sym unless updates['Indirect Cost Recovery Active Indicator'].nil?

    visit(MainPage).account
    on AccountLookupPage do |page|
      page.chart_code.fit     'IT' #TODO config
      page.account_number.fit account_number
      page.search
      page.wait_for_search_results
      page.copy_random
    end
    on AccountPage do |page|
      @document_id = page.document_id
      @account = make AccountObject, description: updates['Description'],
                      name:        updates['Name'],
                      chart_code:  updates['Chart Code'],
                      number:      random_alphanums(7),
                      document_id: page.document_id,
                      indirect_cost_recovery_chart_of_accounts_code: updates['Indirect Cost Recovery Chart Of Accounts Code'],
                      indirect_cost_recovery_account_number:         updates['Indirect Cost Recovery Account Number'],
                      indirect_cost_recovery_account_line_percent:   updates['Indirect Cost Recovery Account Line Percent'],
                      indirect_cost_recovery_active_indicator:       updates['Indirect Cost Recovery Active Indicator'],
                      press: nil
      page.description.fit @account.description
      page.name.fit        @account.name
      page.chart_code.fit  @account.chart_code
      page.number.fit      @account.number
      page.supervisor_principal_name.fit @account.supervisor_principal_name
      page.indirect_cost_recovery_chart_of_accounts_code.fit @account.indirect_cost_recovery_chart_of_accounts_code unless @account.indirect_cost_recovery_chart_of_accounts_code.nil?
      page.indirect_cost_recovery_account_number.fit         @account.indirect_cost_recovery_account_number unless @account.indirect_cost_recovery_account_number.nil?
      page.indirect_cost_recovery_account_line_percent.fit   @account.indirect_cost_recovery_account_line_percent unless @account.indirect_cost_recovery_account_line_percent.nil?
      page.indirect_cost_recovery_active_indicator.fit       @account.indirect_cost_recovery_active_indicator unless @account.indirect_cost_recovery_active_indicator.nil?

      page.blanket_approve
      sleep 5
    end

    @accounts = @accounts.nil? ? [@account] : @accounts + [@account]
  end
end

And /^I find an expired Account$/ do
  visit(MainPage).account
  on AccountLookupPage do |page|
    # FIXME: These values should be set by a service.
    page.chart_code.fit     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    page.account_number.fit '147*'
    page.search
    page.sort_results_by('Account Expiration Date')
    page.sort_results_by('Account Expiration Date') # Need to do this twice to get the expired ones in front

    col_index = page.column_index(:account_expiration_date)
    account_row_index = page.results_table
                            .rows.collect { |row| row[col_index].text if row[col_index].text.split('/').length == 3}[1..page.results_table.rows.length]
                            .collect { |cell| DateTime.strptime(cell, '%m/%d/%Y') < DateTime.now }.index(true) + 1 # Finds the first qualified one.
    account_row_index = rand(account_row_index..page.results_table.rows.length)

    # We're only really interested in these parts
    @account = make AccountObject
    @account.number = page.results_table[account_row_index][page.column_index(:account_number)].text
    @account.chart_code = page.results_table[account_row_index][page.column_index(:chart_code)].text
    @account.account_expiration_date = DateTime.strptime(page.results_table[account_row_index][page.column_index(:account_expiration_date)].text, '%m/%d/%Y')
  end
end

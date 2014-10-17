And /^I create a wildcarded Indirect Cost Recovery Rate of (.*) percent using random institutional allowance object codes$/ do |percent|
  @indirect_cost_recovery_rate = create IndirectCostRecoveryRateObject
  @indirect_cost_recovery_rate.add_wildcarded_icr_rate_for_random_institutional_object_codes percent
end


And /^I create a wildcarded Indirect Cost Recovery Rate of (.*) percent using From Indirect Cost Rate institutional allowance object codes$/ do |percent|
  credit_object_code = ''
  debit_object_code = ''
  @indirect_cost_recovery_rate = create IndirectCostRecoveryRateObject

  @remembered_from_indirect_cost_recovery_rate.indirect_cost_recovery_rate_details.each do |icr_detail|
    case icr_detail.debit_credit_code
      when 'Credit'
        credit_object_code = icr_detail.object_code
      when 'Debit'
        debit_object_code = icr_detail.object_code
    end
  end

  @indirect_cost_recovery_rate.add_wildcarded_icr_rate_for_specified_institutional_object_codes percent, debit_object_code, credit_object_code
end


And /^I remember the Indirect Cost Recovery Rate as the (From|To) Indirect Cost Recovery Rate$/ do |target|
  case target
    when 'From'
      @remembered_from_indirect_cost_recovery_rate = @indirect_cost_recovery_rate
    when 'To'
      @remembered_to_indirect_cost_recovery_rate = @indirect_cost_recovery_rate
  end
end


And /^I add the remembered (From|To) account for a Services Object Code for amount (.*)$/ do |target, amount|
  case target
    when 'From'
      account_number = @remembered_from_account.number
      line_description = 'From wildcard ICR account being used'
      object_code_attributes = get_kuali_business_object('KFS-COA','ObjectCode',"universityFiscalYear=#{get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)}&chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectLevelCode=SVCS&active=true")
      object_code = object_code_attributes['financialObjectCode'][0]
    when 'To'
      account_number = @remembered_to_account.number
      line_description = 'To wildcard ICR account being used'
      object_code_attributes = get_kuali_business_object('KFS-COA','ObjectCode',"universityFiscalYear=#{get_aft_parameter_value(ParameterConstants::CURRENT_FISCAL_YEAR)}&chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectLevelCode=SVCS&active=true")
      object_code = object_code_attributes['financialObjectCode'][0]
  end
  step "I add a #{target} amount of \"#{amount}\" for account \"#{account_number}\" with object code \"#{object_code}\" with a line description of \"#{line_description}\" to the DI Document"
end


Then /^the Indirect Cost Recovery Rates are posted correctly for the current month$/ do
  from_icr_row_found = false
  to_icr_row_found = false

  #Need to compare dates as numeric values, basis to use for the date validations
  today_as_numeric = (Date::strptime(right_now[:date_w_slashes], "%m/%d/%Y")).to_time.to_i

  visit(MainPage).general_ledger_entry
  on GeneralLedgerEntryLookupPage do |page|
    #validate From Account has ICR GL entry
    page.find_gl_entries_by_account @remembered_from_account

    #get the column identifiers once to be used by both from and to validation
    results_table = page.results_table
    object_code_col = results_table.keyed_column_index(:object_code)
    document_type_col = results_table.keyed_column_index(:document_type)
    origin_code_col = results_table.keyed_column_index(:origin_code)
    document_number_col = results_table.keyed_column_index(:document_number)
    amount_col = results_table.keyed_column_index(:transaction_ledger_entry_amount)
    dc_col = results_table.keyed_column_index(:debit_credit_code)
    transaction_date_col = results_table.keyed_column_index(:transaction_date)

    results_table.rest.each do |glerow|
      if glerow[object_code_col].text.strip == '1000'
        if glerow[document_type_col].text.strip == 'ICR'
          if glerow[origin_code_col].text.strip == 'MF' &&
             glerow[amount_col].text.strip == '0.00' &&
             glerow[dc_col].text.strip == 'C' &&
             (Date::strptime((glerow[document_number_col].text.strip), "%Y%m%d")).to_time.to_i <= today_as_numeric &&
             (Date::strptime((glerow[transaction_date_col].text.strip), "%m/%d/%Y")).to_time.to_i <= today_as_numeric
            from_icr_row_found = true
            break
          end #validation step
        end #check-each document type
      end #check-each generated offset row
    end #for-each glerow
    from_icr_row_found.should be true

    #validate To Account has ICR GL entry
    page.find_gl_entries_by_account @remembered_to_account
    results_table = page.results_table
    #do not need to get columns again as they are they same
    results_table.rest.each do |glerow|
      if glerow[object_code_col].text.strip == '1000'
        if glerow[document_type_col].text.strip =='ICR'
          if glerow[origin_code_col].text.strip == 'MF' &&
              glerow[amount_col].text.strip == '10.00' &&
              glerow[dc_col].text.strip == 'C' &&
              (Date::strptime((glerow[document_number_col].text.strip), "%Y%m%d")).to_time.to_i <= today_as_numeric &&
              (Date::strptime((glerow[transaction_date_col].text.strip), "%m/%d/%Y")).to_time.to_i <= today_as_numeric
            to_icr_row_found = true
            break
          end #validation step
        end #check-each document type
      end #check-each generated offset row
    end #for-each glerow
    to_icr_row_found.should be true
  end
end

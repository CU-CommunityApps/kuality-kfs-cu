And /^I create a wild carded Indirect Cost Recovery Rate of (.*) percent using random institutional allowance object codes$/ do |percent|
  @indirect_cost_recovery_rate = create IndirectCostRecoveryRateObject
  @indirect_cost_recovery_rate.create_wildcard_icr_for_random_institutional_object_codes percent
end


# This method presumes that the following global data elements have been created and are populated:
# @from_indirect_cost_rate_debit_object_code, @from_indirect_cost_rate_credit_object_code
And /^I create a wild carded Indirect Cost Recovery Rate of (.*) percent using From Indirect Cost Rate institutional allowance object codes$/ do |percent|
  @indirect_cost_recovery_rate = create IndirectCostRecoveryRateObject
  @indirect_cost_recovery_rate.create_wildcard_icr_for_specified_institutional_object_codes percent, @from_indirect_cost_rate_debit_object_code, @from_indirect_cost_rate_credit_object_code
end


# This method creates the following global data elements:
# @from_indirect_cost_rate, @from_indirect_cost_rate_debit_object_code, @from_indirect_cost_rate_credit_object_code
And /^I remember the Indirect Cost Recovery Rate as a From Indirect Cost Rate$/ do
  @from_indirect_cost_rate = @indirect_cost_recovery_rate.rate_id
  @from_indirect_cost_rate_debit_object_code = @indirect_cost_recovery_rate.debit_object_code
  @from_indirect_cost_rate_credit_object_code = @indirect_cost_recovery_rate.credit_object_code
end


# This method creates the following global data elements:
# @to_indirect_cost_rate, @to_indirect_cost_rate_debit_object_code, @to_indirect_cost_rate_credit_object_code
And /^I remember the Indirect Cost Recovery Rate as a To Indirect Cost Rate$/ do
  @to_indirect_cost_rate = @indirect_cost_recovery_rate.rate_id
  @to_indirect_cost_rate_debit_object_code = @indirect_cost_recovery_rate.debit_object_code
  @to_indirect_cost_rate_credit_object_code = @indirect_cost_recovery_rate.credit_object_code
end


And /^I edit an active CG account modifying the Indirect Cost Rate to the (From|To) Indirect Cost Rate$/ do |target|
  case target
    when 'From'
      #ICR to use for the edit of the account being retrieved, needs to be the From value
      indirect_cost_rate = @from_indirect_cost_rate
      #account number we do NOT want, in this case the To account so subsequent comparisons do not allow same account to be chosen
      remembered_account = @remembered_to_account
    when 'To'
      #ICR to use for the edit of the account being retrieved, needs to be the To value
      indirect_cost_rate = @to_indirect_cost_rate
      #account number we do NOT want, in this case the From account so subsequent comparisons do not allow same account to be chosen
      remembered_account = @remembered_from_account
  end

  #Need to ensure CG account being retrieved does not match existing CG account if it has been populated.
  if remembered_account.nil?
    step 'I find an unexpired CG account that has an unexpired continuation account'
  else
    step "I find an unexpired CG account that has an unexpired continuation account not matching account number #{remembered_account.number}"
  end
  step "I change the Indirect Cost Rate on account #{@account.number} belonging to chart #{@account.chart_code} to #{indirect_cost_rate}"
end


And /^I add the remembered (From|To) account for a Services Object code for amount (.*)$/ do |target, amount|
  case target
    when 'From'
      account_number = @remembered_from_account.number
      line_description = 'From wildcard ICR account being used'
      object_code_attributes = get_kuali_business_object('KFS-COA','ObjectCode',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectLevelCode=SVCS&active=true")
      object_code = object_code_attributes['financialObjectCode'][0]
    when 'To'
      account_number = @remembered_to_account.number
      line_description = 'To wildcard ICR account being used'
      object_code_attributes = get_kuali_business_object('KFS-COA','ObjectCode',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectLevelCode=SVCS&active=true")
      object_code = object_code_attributes['financialObjectCode'][0]
  end
  step "I add a #{target} amount of \"#{amount}\" for account \"#{account_number}\" with object code \"#{object_code}\" with a line description of \"#{line_description}\" to the DI Document"
end


Then /^ICR rates are posted correctly for current month$/ do
  from_di_row_found = false
  from_icr_row_found = false
  to_di_row_found = false
  to_icr_row_found = false
  today = right_now[:date_w_slashes]

  visit(MainPage).general_ledger_entry
  on GeneralLedgerEntryLookupPage do |page|
    #validate From Account has two GL entries
    page.find_gl_entries_by_account @remembered_from_account

    #get the column identifiers once to be used by both from and to validation
    object_code_col = page.results_table.keyed_column_index(:object_code)
    document_type_col = page.results_table.keyed_column_index(:document_type)
    origin_code_col = page.results_table.keyed_column_index(:origin_code)
    document_number_col = page.results_table.keyed_column_index(:document_number)
    amount_col = page.results_table.keyed_column_index(:transaction_ledger_entry_amount)
    dc_col = page.results_table.keyed_column_index(:debit_credit_code)
    transaction_date_col = page.results_table.keyed_column_index(:transaction_date)

    page.results_table.rest.each do |glerow|

      if glerow[object_code_col].text.strip == '1000'
        if glerow[document_type_col].text.strip == 'DI'
          if glerow[origin_code_col].text.strip == '01' &&
             glerow[document_number_col].text.strip == @remembered_document_id &&
             glerow[amount_col].text.strip == '100.00' &&
             glerow[dc_col].text.strip == 'D' &&
             glerow[transaction_date_col].text.strip <= today
            from_di_row_found = true
          end
        elsif glerow[document_type_col].text.strip == 'ICR'
          if glerow[origin_code_col].text.strip == 'MF' &&
             glerow[amount_col].text.strip == '0.00' &&
             glerow[dc_col].text.strip == 'C' &&
             glerow[transaction_date_col].text.strip <= today
            from_icr_row_found = true
          end
        end #check-each document type
      end #check-each generated offset row
    end #for-each glerow
    from_di_row_found.should be true
    from_icr_row_found.should be true

    #validate To Account has two GL entries
    page.find_gl_entries_by_account @remembered_to_account
    page.results_table.rest.each do |glerow|

      if glerow[object_code_col].text.strip == '1000'
        if glerow[document_type_col].text.strip == 'DI'
          if glerow[origin_code_col].text.strip == '01' &&
              glerow[document_number_col].text.strip == @remembered_document_id &&
              glerow[amount_col].text.strip == '100.00' &&
              glerow[dc_col].text.strip == 'C' &&
              glerow[transaction_date_col].text.strip <= today
            to_di_row_found = true
          end
        elsif glerow[document_type_col].text.strip =='ICR'
          if glerow[origin_code_col].text.strip == 'MF' &&
              glerow[amount_col].text.strip == '10.00' &&
              glerow[dc_col].text.strip == 'C' &&
              glerow[transaction_date_col].text.strip <= today
            to_icr_row_found = true
          end
        end #check-each document type
      end #check-each generated offset row
    end #for-each glerow
    to_di_row_found.should be true
    to_icr_row_found.should be true
  end
end

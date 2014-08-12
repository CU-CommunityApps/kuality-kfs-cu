When /^I start an empty Benefit Expense Transfer document$/ do
  @benefit_expense_transfer = create BenefitExpenseTransferObject
end

Given /^I select employee (\d+)$/ do|emp|
  on SalaryExpenseTransferPage do |page|
    page.employee_id.fit ''
    page.search_empl_id
  end
  on PersonLookup do |search|
    search.employee_id.fit emp
    search.search
    search.return_value(emp)
  end
end

And /^I search and retrieve Ledger Balance entry$/ do
  #search for ledger balance
  on(SalaryExpenseTransferPage) do |page|
    page.import_search
  end
  # retrieve first positive balance_month
  on LedgerBalanceLookupPage do |lblookup|
    #look back to previous fiscal when there is no labor data in current fiscal year for the test
    if lblookup.no_results_found?
      @fiscal_year = lblookup.fiscal_year.value.to_i - 1
      lblookup.fiscal_year.set @fiscal_year
      lblookup.search
    end
    #TODO Change to select first month with a positive balance.  Currently, first month regardless of balance is being selected.
    lblookup.check_first_month
    lblookup.return_selected
  end
end

And /^I copy (.*) source account to target account$/ do |document|
  target_page = page_class_for(document)
  on(target_page).copy_all_source_accounting_lines    #nkk4 keep accounting lines in sync
end

And /^I change (.*) target account number to '(.*)'$/ do |document, account_number|
  target_page = page_class_for(document)
  on(target_page).update_target_account_number.fit account_number
end

And /^I transfer the Salary to another Account in my Organization$/ do |table|
  arguments = table.rows_hash
  @to_account = arguments['To Account']

  # do not continue, required parameters not sent
  fail ArgumentError, 'Required parameter "To Account" was not specified.' if @to_account.nil?

  step "I change Salary Expense Transfer target account number to '#@to_account'"
end

And /^I transfer the Salary between accounts with different Account Types$/ do |table|
  arguments = table.rows_hash
  @to_account_different_types = arguments['To Account']

  # do not continue, required parameters not sent
  fail ArgumentError, 'Required parameter To Account was not specified.' if @to_account_different_types.nil?

  step "I change Salary Expense Transfer target account number to '#@to_account_different_types'"
end

And /^I transfer the Salary to an Account with a different Rate but the same Account Type and Organization$/ do |table|
  # fedrate (FD) vs nonfedrate (NF)
  arguments = table.rows_hash
  @to_account_different_rates = arguments['To Account']

  # do not continue, required parameters not sent
  fail ArgumentError, 'Required parameter To Account was not specified.' if @to_account_different_rates.nil?

  step "I change Salary Expense Transfer target account number to '#@to_account_different_rates'"
end


And /^I change target sub account number to '(.*)'$/ do |sub_account_number|
  on(BenefitExpenseTransferPage).update_target_sub_account_code.fit sub_account_number
end

Given /^I start an empty Salary Expense Transfer document$/ do
  @salary_expense_transfer = create SalaryExpenseTransferObject
end


Given  /^I create a Salary Expense Transfer with following:$/ do |table|
  arguments = table.rows_hash
  @user_principal = arguments['User Name']
  @employee_id = arguments['Employee']

  # do not continue, required parameters not sent
  fail ArgumentError, 'One or more required parameters were not specified.'if @user_principal.nil? || @employee_id.nil?

  step 'I am User #@user_principal who is a Salary Transfer Initiator'
  step 'I populate Salary Expense Transfer document for employee'

  #value required for validation on different panel at end of test
  @salary_expense_transfer.remembered_employee_id = @employee_id
end


Given /^I create a Salary Expense Transfer as a Labor Distribution Manager:$/ do |table|
  arguments = table.rows_hash
  @employee_id = arguments['Employee']

  # do not continue, required parameters not sent
  fail ArgumentError, 'One or more required parameters were not specified.'if @employee_id.nil?

  step 'I am logged in as a Labor Distribution Manager'
  step 'I populate Salary Expense Transfer document for employee'

  #value required for validation on different panel at end of test
  @salary_expense_transfer.remembered_employee_id = @employee_id
end

Given /^I populate Salary Expense Transfer document for employee$/ do
  step "I start an empty Salary Expense Transfer document"
  step "I select employee #{@employee_id}"
  step "I search and retrieve Ledger Balance entry"
  step "I copy Salary Expense Transfer source account to target account"
end

Given  /^I create a Benefit Expense Transfer with following:$/ do |table|
  arguments = table.rows_hash
  steps %Q{ Given I Login as a Benefit Transfer Initiator
            And   I start an empty Benefit Expense Transfer document
  }
  if !arguments['From Account'].nil?
    step "I set transfer from account number to '#{arguments['From Account']}' on Benefit Expense Transfer document"
  end
  steps %Q{ And   I search and retrieve Ledger Balance entry
            And   I copy Benefit Expense Transfer source account to target account
  }

  if !arguments['To Account'].nil?
    step "I change Benefit Expense Transfer target account number to '#{arguments['To Account']}'"
  end
  steps %Q{ And   I submit the Benefit Expense Transfer document
            And   the Benefit Expense Transfer document goes to ENROUTE
            And   I route the Benefit Expense Transfer document to final
            Then  the Benefit Expense Transfer document goes to FINAL
      }

end

And /^I set transfer from account number to '(.*)' on Benefit Expense Transfer document$/ do |account_number|
  on(BenefitExpenseTransferPage).account_number.fit account_number
end

Then /^I run the nightly Labor batch process$/ do
  steps %Q{
    Given I am logged in as a KFS Operations
    And I run the Labor Enterprise Feed Process
    And I run the Labor Nightly Out Process
    And I run the Labor Scrubber Process
    And I run the Labor Poster Process
    And I run the Labor Balancing Job
    And I run the Labor Feed Job
    And I run the Labor Clear Pending Entries Job
   }

  # GL nightly is deferred; See QA-830
  #step "I run the GL Nightly Processes"
end

And /^I run the GL Nightly Processes$/ do
  # generate output files batch jobs
  steps %Q{
    And   I generate the ACH XML File
    And   I generate the Check XML File
    And   I generate the Cancelled Check XML File
    And   I send EMAIL Notices to ACH Payees
    And   I process Cancels and Paids
    And   I generate the GL Files from PDP
    And   I populate the ACH Bank Table
    And   I clear out PDP Temporary Tables
 }

end

Then /^the labor ledger pending entry for employee is empty$/ do
  employee_id = ""
  if @salary_expense_transfer == nil || @salary_expense_transfer.remembered_employee_id == nil
    #get default employee_id data value since test being run did not set remembered value
    employee_id = get_aft_parameter_value(ParameterConstants::DEFAULT_ST_EMPL_ID)
  else
    #get employee_id used earlier in the test
    employee_id = @salary_expense_transfer.remembered_employee_id
  end
  visit(MainPage).labor_ledger_pending_entry
  on LaborLedgerPendingEntryLookupPage do |page|
    page.fiscal_year.fit ''
    page.empl_id.fit employee_id
    page.search
    page.wait_for_search_results
    page.frm.divs(id: 'view_div')[0].text.should include 'No values match this search.'
  end

end

And /^a Salary Expense Transfer initiator outside the organization cannot view the document$/ do |table|
  arguments = table.rows_hash
  @user_outside_organization = arguments['User Name']

  # do not continue, required parameters not sent
  fail ArgumentError, 'Required parameter User Name was not specified.' if @user_outside_organization.nil?

  step "I am logged in as \"#{@user_outside_organization}\""
  step "I open the document with ID #{@remembered_document_id}"
  step "I should get an Authorization Exception Report error"
end

And /^a Salary Expense Transfer initiator inside the organization can view the document$/ do |table|
  arguments = table.rows_hash
  @user_inside_organization = arguments['User Name']

  # do not continue, required parameters not send
  fail ArgumentError, 'Required parameter User Name was not specified.' if @user_inside_organization.nil?

  step "I am logged in as \"#{@user_inside_organization}\""
  step "I open the document with ID #{@remembered_document_id}"
end

And /^I update the Salary Expense Transfer document with the following:$/ do |table|
  arguments = table.rows_hash
  labor_object_code = arguments['Labor Object Code']

  on(SalaryExpenseTransferPage).update_target_object_code.fit labor_object_code
end


# Verifying the transfer between salary accounts and benefits accounts, between fiscal period, and balance type.
# For the salary transfer:
# 1. From account will credit actuals (AC balance type) for account and object
#    To account will debit actuals (AC balance type) for the account and object code
#
# 2. From account will debit A2 balance type for account and object (fiscal period assigned when posted, blank in
#    pending entries tab) and credit A2 balance type for fiscal periods selected in test (returned value);
#
#    To account will credit A2 balance type for account, object (no FP in PE tab) and debit A2 balance type
#    for fiscal period selected in test (returned value)
#
# 3. The associated benefit accounts will appear and post in the same manner as #1 and #2 described above
#
And /^the Labor Ledger Pending entries verify for the accounting lines on the (.*) document$/ do |document|
  on(page_class_for(document)).expand_all
  on page_class_for(document) do |page|

    #items for labor ledger pending entries table
    llpe_running_count = 0
    llpe_num_rows = page.llpe_results_table.rows.length-1
    account_number_col = page.llpe_results_table.keyed_column_index(:account_number)
    object_code_col = page.llpe_results_table.keyed_column_index(:object)
    period_col = page.llpe_results_table.keyed_column_index(:period)
    balance_type_col = page.llpe_results_table.keyed_column_index(:balance_type)
    amount_col = page.llpe_results_table.keyed_column_index(:amount)
    dc_col = page.llpe_results_table.keyed_column_index(:debit_credit_code)

    # FROM ACCOUNTING LINES
    for row in 0..(page.accounting_lines_row_count :source)-1
      line = @salary_expense_transfer.pull_specified_accounting_line(:source, row, page)
      fringe_detail = @salary_expense_transfer.get_fringe_benefit_detail(line[:fringe_benefit_inquiry])
      page.close_children   #only way to get Fringe Benefit Inquiry to close

      # Account Lookup as webservice call to get labor benefit rate category code on the account
      account_info = get_kuali_business_object('KFS-COA','Account',"closed=N&accountNumber=#{line[:account_number]}")

      # Labor Object Code Benefits Lookup as webservice call to get labor benefits type code
      labor_benefit_type_info = get_kuali_business_object('KFS-LD','PositionObjectBenefit',"universityFiscalYear=#{line[:payroll_end_date_fiscal_year]}&chartOfAccountsCode=#{line[:chart_code]}&financialObjectCode=#{line[:object_code]}")

      # Labor Benefits Calculation Lookup as webservice call using labor benefit rate category code and
      # labor benefits type code to get labor benefit object code, labor account code offset, and position fringe benefit percent
      labor_calc_info = get_kuali_business_object('KFS-LD','BenefitsCalculation',"universityFiscalYear=#{line[:payroll_end_date_fiscal_year]}&chartOfAccountsCode=#{line[:chart_code]}&positionBenefitTypeCode=#{labor_benefit_type_info['financialObjectBenefitsTypeCode'][0]}&laborBenefitRateCategoryCode=#{account_info['laborBenefitRateCategoryCode'][0]}")

      # Determine what the benefits amount should be based on the percentage just retrieved.
      benefit_amount = @salary_expense_transfer.calculate_benefit_amount((line[:amount]).to_f, (labor_calc_info['positionFringeBenefitPercent'][0]).to_f)

      #ensure all flags being used are initialized/reset between accounting rows
      all_llpe_rows_found = false
      credit_actuals_valid = false
      debit_a21_blank_valid = false
      credit_a21_period_valid = false
      benefit_credit_actuals_valid = false
      benefit_debit_a21_blank_valid = false
      benefit_credit_a21_period_vld = false

      page.llpe_results_table.rest.each do |llperow|
        unless all_llpe_rows_found
          if @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                             line[:account_number], line[:object_code], line[:amount], @period_unassigned, @actuals_balance_type, @credit_code)
            credit_actuals_valid = true

          elsif @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                                line[:account_number], line[:object_code], line[:amount], @period_unassigned, @labor_balance_typed, @debit_code)
            debit_a21_blank_valid = true

          elsif @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                                line[:account_number], line[:object_code], line[:amount], line[:payroll_end_date_fiscal_period_code], @labor_balance_typed, @credit_code)
            credit_a21_period_valid = true

          elsif @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                                line[:account_number], labor_calc_info['positionFringeBenefitObjectCode'][0], benefit_amount, @period_unassigned, @actuals_balance_type, @credit_code)
            benefit_credit_actuals_valid = true

          elsif @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                                line[:account_number], labor_calc_info['positionFringeBenefitObjectCode'][0], benefit_amount, @period_unassigned, @labor_balance_typed, @debit_code)
            benefit_debit_a21_blank_valid = true

          elsif @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                                line[:account_number], labor_calc_info['positionFringeBenefitObjectCode'][0], benefit_amount, line[:payroll_end_date_fiscal_period_code], @labor_balance_typed, @credit_code)
            benefit_credit_a21_period_vld = true
          end
        end
      end #loop of llpe table
      all_llpe_rows_found = credit_actuals_valid && debit_a21_blank_valid && credit_a21_period_valid && benefit_credit_actuals_valid && benefit_debit_a21_blank_valid && benefit_credit_a21_period_vld
      all_llpe_rows_found.should be true
      llpe_running_count += 6
    end #for-loop from accounting lines

    # To ACCOUNTING LINES
    for row in 0..(page.accounting_lines_row_count :target)-1
      line = @salary_expense_transfer.pull_specified_accounting_line(:target, row, page)
      fringe_detail = @salary_expense_transfer.get_fringe_benefit_detail(line[:fringe_benefit_inquiry])
      page.close_children   #only way to get Fringe Benefit Inquiry to close

      # Account Lookup as webservice call to get labor benefit rate category code on the account
      account_info = get_kuali_business_object('KFS-COA','Account',"closed=N&accountNumber=#{line[:account_number]}")

      # Labor Object Code Benefits Lookup as webservice call to get labor benefits type code
      labor_benefit_type_info = get_kuali_business_object('KFS-LD','PositionObjectBenefit',"universityFiscalYear=#{line[:payroll_end_date_fiscal_year]}&chartOfAccountsCode=#{line[:chart_code]}&financialObjectCode=#{line[:object_code]}")

      # Labor Benefits Calculation Lookup as webservice call using labor benefit rate category code and
      # labor benefits type code to get labor benefit object code, labor account code offset, and position fringe benefit percent
      labor_calc_info = get_kuali_business_object('KFS-LD','BenefitsCalculation',"universityFiscalYear=#{line[:payroll_end_date_fiscal_year]}&chartOfAccountsCode=#{line[:chart_code]}&positionBenefitTypeCode=#{labor_benefit_type_info['financialObjectBenefitsTypeCode'][0]}&laborBenefitRateCategoryCode=#{account_info['laborBenefitRateCategoryCode'][0]}")

      # Determine what the benefits amount should be based on the percentage just retrieved.
      benefit_amount = @salary_expense_transfer.calculate_benefit_amount((line[:amount]).to_f, (labor_calc_info['positionFringeBenefitPercent'][0]).to_f)

      #ensure all flags being used are initialized/reset between accounting rows
      t_all_llpe_rows_found = false
      t_debit_actuals_blank_valid = false
      t_credit_a21_blank_valid = false
      t_debit_a21_period_valid = false
      t_benefit_debit_actual_valid = false
      t_benefit_credit_a21_blank_valid = false
      t_benefit_debit_a21_period_valid = false

      page.llpe_results_table.rest.each do |llperow|
        unless all_llpe_rows_found
          if @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                             line[:account_number], line[:object_code], line[:amount], @period_unassigned, @actuals_balance_type, @debit_code)
            t_debit_actuals_blank_valid = true

          elsif @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                                line[:account_number], line[:object_code], line[:amount], @period_unassigned, @labor_balance_typed, @credit_code)
            t_credit_a21_blank_valid = true

          elsif @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                                line[:account_number], line[:object_code], line[:amount], line[:payroll_end_date_fiscal_period_code], @labor_balance_typed , @debit_code)
            t_debit_a21_period_valid = true

          elsif @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                                line[:account_number], labor_calc_info['positionFringeBenefitObjectCode'][0], benefit_amount, @period_unassigned, @actuals_balance_type, @debit_code)
            t_benefit_debit_actual_valid = true

          elsif @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                                line[:account_number], labor_calc_info['positionFringeBenefitObjectCode'][0], benefit_amount, @period_unassigned, @labor_balance_typed, @credit_code)
            t_benefit_credit_a21_blank_valid = true

          elsif @salary_expense_transfer.llpe_line_matches_accounting_line_data(llperow[account_number_col].text.strip, llperow[object_code_col].text.strip, llperow[amount_col].text.strip, llperow[period_col].text.strip, llperow[balance_type_col].text.strip, llperow[dc_col].text.strip,
                                                                                line[:account_number], labor_calc_info['positionFringeBenefitObjectCode'][0], benefit_amount, line[:payroll_end_date_fiscal_period_code], @labor_balance_typed , @debit_code)
            t_benefit_debit_a21_period_valid = true
          end
        end
      end #loop of llpe table
      t_all_llpe_rows_found = t_debit_actuals_blank_valid && t_credit_a21_blank_valid && t_debit_a21_period_valid && t_benefit_debit_actual_valid && t_benefit_credit_a21_blank_valid && t_benefit_debit_a21_period_valid
      all_llpe_rows_found.should be true
      llpe_running_count += 6
    end #for-loop to accounting lines
    all_llpe_rows_found.should == llpe_num_rows
  end #page loop


  Then /^Salary Expense Transfer document LLPE line matches accounting line$/ do |table|
    arguments = table.rows_hash
    llpe_account = arguments['LLPE Account']
    llpe_object = arguments['LLPE Object']
    llpe_amount = arguments['LLPE Amount']
    llpe_period = arguments['LLPE Account']
    llpe_balance_type = arguments['LLPE Balance Type']
    llpe_debit_credit_code = arguments['LLPE Debit Credit Code']
    account = arguments['Account']
    object = arguments['Object']
    amount = arguments['Amount']
    period = arguments['Period']
    balance_type = arguments['Balance Type']
    debit_credit_code = arguments['Debit Credit Code']

    #return true only when all input parameters match;
    # period values could be zero length strings; amounts could be floats; rest should be string values
    if (llpe_account == account) && (llpe_object == object) && (llpe_amount.to_s == amount.to_s) &&
        (llpe_balance_type == balance_type) && (llpe_debit_credit_code == debit_credit_code) &&
        ( (llpe_period.empty? && period.empty?) || (!llpe_period.empty? && !period.empty? && llpe_period == period)  )
      return true
    else
      return false
    end
  end

end

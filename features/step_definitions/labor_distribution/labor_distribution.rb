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

#TODO MUST FIX - benefits tests broken
And /^I search and retrieve Ledger Balance entry$/ do
  @salary_expense_transfer.search_for_employee
  @salary_expense_transfer.retrieve_first_positive_balance_month
end

And /^I copy (.*) source account to target account$/ do |document|
  target_page = page_class_for(document)
  # works but only copies first line not all if there are more than one     on(target_page).copy_source_accounting_line
  on(target_page).copy_all_source_accounting_lines
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

  step "And I change Salary Expense Transfer target account number to '#@to_account'"
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

  step "I am User #@user_principal who is a Salary Transfer Initiator"
  populate_st_for_employee
end


Given /^I create a Salary Expense Transfer as a Labor Distribution Manager:$/ do |table|
  arguments = table.rows_hash
  @employee_id = arguments['Employee']

  # do not continue, required parameters not sent
  fail ArgumentError, 'One or more required parameters were not specified.'if @employee_id.nil?

  step "I am logged in as a Labor Distribution Manager"
  populate_st_for_employee
end

def populate_st_for_employee
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

Then /^the labor ledger pending entry for employee '(.*)' is empty$/ do |empl_id|
  visit(MainPage).labor_ledger_pending_entry
  on LaborLedgerPendingEntryLookupPage do |page|
    page.fiscal_year.fit ''
    page.empl_id.fit empl_id
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

And /^I edit object code and replace with a different labor object code$/ do |table|
  arguments = table.rows_hash
  labor_object_code = arguments['Labor Object Code']

  target_page = page_class_for("Salary Expense Transfer")
  on(target_page).update_target_object_code.fit labor_object_code
end


And /^the Labor Ledger Pending entries verify for the accounting lines on the (.*) document$/ do |document|
  doc_object = get(snake_case(document))
  on(page_class_for(document)).expand_all
  on page_class_for(document) do |page|

  #TODO constants used for verification, put in parameters table and lookup
  actuals_balance_type = "AC"
  labor_balance_type = "A2"
  debit_code = "D"
  credit_code = "C"
  blank = ""

  # Verifying the transfer between salary accounts and benefits accounts, between fiscal period, and balance type.
  # For the salary transfer:
  # 1. From account will credit actuals (AC balance type) for account and object
  #    To account will debit actuals (AC balance type) for the account and object code.
  # 2. From account will debit A2 balance type for account and object (fiscal period assigned when posted, blank in
  #    pending entries tab) and credit A2 balance type for fiscal periods selected in test (returned value);
  #    To account will credit A2 balance type for account, object (no FP in PE tab) and debit A2 balance type
  #    for fiscal period selected in test (returned value)
  # 3. The associated benefit accounts will appear and post in the same manner as #1 and #2 described above
  # flags for condition #1 described above
  from_reg_credit_actuals_period_empty_found = false
  to_reg_acct_debit_actuals_period_empty_found = false
  # flags for condition #2 described above
  from_reg_debit_labor_period_empty_found = false
  from_reg_credit_labor_period_chosen_found = false
  to_reg_credit_labor_period_empty_found = false
  to_reg_debit_labor_period_chosen_found = false
  # flags for condition #3 described above
  from_ben_credit_actuals_period_empty_found = false
  to_ben_acct_debit_actuals_period_empty_found = false
  from_ben_debit_labor_period_empty_found = false
  from_ben_credit_labor_period_chosen_found = false
  to_ben_credit_labor_period_empty_found = false
  to_ben_debit_labor_period_chosen_found = false


  # FROM ACCOUNTING LINES
  for row in 0..(page.accounting_lines_row_count :source)-1
    from_line = @salary_expense_transfer.pull_specified_accounting_line(:source, row, page)
    fringe_detail = @salary_expense_transfer.get_fringe_benefit_detail(from_line[:fringe_benefit_inquiry])
    page.close_children   #only way to get Fringe Benefit Inquiry to close

    # get labor benefit rate category code on account
    from_labor_benefit_rate_category_code = "CC"
    # #TODO dynamically determine
    acct_num = from_line[:account_number]
    data = "closed=N&accountNumber=#{from_line[:account_number].to_s}"
    account_info = get_kuali_business_object('KFS-COA','Account',data)
    account_info = get_kuali_business_object('KFS-COA','Account','accountNumber=7543814')
    award_account_number = account_info['accountNumber'][0]    # lbrcc = account_info['laborBenefitRateCategoryCode']

    # use Labor Object Code Benefits Lookup to get labor benefits type code (account => FY, chart code, )
    from_labor_benefit_type_code = @salary_expense_transfer.lookup_labor_benefits_type_code(from_line[:chart_code], from_line[:object_code])


    # use Labor Benefits Calculation Lookup
    # @fiscal_year, from_line[:chart_code], from_labor_benefit_type_code, from_labor_benefit_category_rate_code



  end #for-loop

    # TO ACCOUNTING LINES
    for row in 0..(page.accounting_lines_row_count :target)-1
      target_chart = (page.update_chart_code :target; row).to_s
      target_acct = (page.update_account_number :target; row).to_s
      target_sub_acct = (page.sub_account_number :target; row).to_s
      target_obj = (page.object_code :target; row).to_s
      target_posn = page.position_number_value :target; row
      target_fy = page.payroll_end_date_fiscal_year_value :target; row
      target_fy_per = page.payroll_end_date_fiscal_period_code_value :target; row
#      target_hours = page.payroll_total_hours :target; row
#      target_ben_view = page.fringe_benefit_view_value :target; row
#      target_amt = page.salary_expense_amount :target; row
      a = "b"
    end




    # LLPE RESULTS TABLE
    llpe_num_rows = page.llpe_results_table.rows.length-1
    chart_col = page.llpe_results_table.keyed_column_index(:chart)
    account_number_col = page.llpe_results_table.keyed_column_index(:account_number)
    object_code_col = page.llpe_results_table.keyed_column_index(:object)
    period_col = page.llpe_results_table.keyed_column_index(:period)
    balance_type_col = page.llpe_results_table.keyed_column_index(:balance_type)
    amount_col = page.llpe_results_table.keyed_column_index(:amount)
    dc_col = page.llpe_results_table.keyed_column_index(:debit_credit_code)
    page.llpe_results_table.rest.each do |row|
      llpe_chart = row[chart_col].text
      llpe_account_number = row[account_number_col].text
      llpe_object_code = row[object_code_col].text
      llpe_period = row[period_col].text
      llpe_balance_type = row[balance_type_col].text
      llpe_amount = row[amount_col].text
      llpe_debit_credit = row[dc_col].text
    end

  end #page loop
  stop_point = 1
end

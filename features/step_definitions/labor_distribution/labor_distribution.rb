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

###########################################################################################
# Verifying the salary expense transfer between accounts by comparing data (account, object, period, balance type, amount,
# debit/credit code) associated with the From and To accounts based on the following rules.
#
# For the salary transfer:
# 1. From account will credit actuals (AC balance type) for account and object
#    To account will debit actuals (AC balance type) for the account and object code
#
# 2. From account will debit A2 balance type for account and object (fiscal period assigned when posted, blank in
#    pending entries tab) and credit A2 balance type for fiscal periods selected in test (returned value);
#
#    To account will credit A2 balance type for account, object (no fiscal period in labor ledger pending entries tab)
#    and debit A2 balance type for fiscal period selected in test (returned value)
#
# 3. Do not use the Fringe Benefit ==> View link (Fringe Benefit Inquiry page) for the object code or amount.
#
#    Obtain the Labor Benefit Rate Category Code via an Account Lookup.
#
#    Obtain the Labor Benefits Type Code via a Maintenance ==> Labor Object Code Benefits Lookup.
#
#    Use the Labor Benefit Rate Category Code and Labor Benefits Type Code on the
#    Maintenance ==> Labor Benefits Calculation Lookup to obtain the Labor Benefit Object Code and
#    Position Fringe Benefit Percent (both referred to below)
#
#    Use From or To amount times Position Fringe Benefit Percent to determine LLPE benefit amount (referred to below).
#
#    Use parameter obtained from parameter lookup for namespace="KFS-LD - Labor Distribution",
#    component="Salary Expense Transfer", parameter name ="BENEFIT_CLEARING_ACCOUNT_NUMBER"
#    for clearing account (referred to below).
#
#
#    Any time calculated benefit amount is ZERO:
#      From account will not have any benefit labor ledger pending entries
#      To account will not have any benefit labor ledger pending entries
#
#    Any time the fringe amounts vary either object code or amount:
#      Clearing account will debit actuals (AC balance type) for From account Labor Benefit Object Code
#      when calculated benefit amount is non-zero (fiscal period blank)
#      Clearing account will credit actuals (AC balance type) for To account Labor Benefit Object Code
#      when calculated benefit amount is non-zero (fiscal period blank)
#      Clearing account will debit actuals (AC balance type) for To account Labor Benefit Object Code
#      when calculated benefit amount is zero (fiscal period blank)
#
#    Any time calculated benefit amount is NON-ZERO:
#      From account will credit actuals (AC balance type) for account, its Labor Benefit Object Code value,
#      its calculated benefit amount, and blank period.
#      To account will debit actuals (AC balance type) for account, its Labor Benefit Object Code value,
#      its calculated benefit amount, and blank period.
#
#      From account will debit A2 balance type for account, its Labor Benefit Object Code value, its calculated
#      benefit amount, and blank period; and credit A2 balance type for its Labor Benefit Object Code value, its
#      calculated benefit amount, and fiscal periods selected in test.
#
#      To account will credit A2 balance type for account, its Labor Benefit Object Code value, its calculated
#      benefit amount, and blank period; and debit A2 balance type for its Labor Benefit Object Code value, its
#      calculated benefit amount, and fiscal periods selected in test.
###########################################################################################
And /^the Labor Ledger Pending entries verify for the accounting lines on the (.*) document$/ do |document|
  on(page_class_for(document)).expand_all
  on page_class_for(document) do |page|

    #data from the LLPE results table to be used for validation comparison [Array][Hash]
    llpe_results_data = @salary_expense_transfer.get_llpe_results_data(page)
    llpe_results_data.size.should == page.llpe_results_table.rows.length-1

    # get accounting lines from the page into a local variable, we are going to be adding more attributes pertaining
    # to each accounting line to its hash later on in this verification process so we do not want to muck with the
    # actual global accounting line object
    st_accounting_lines = @salary_expense_transfer.pull_all_accounting_lines(page)
    st_accounting_lines = @salary_expense_transfer.determine_additional_llpe_attributes(st_accounting_lines, :source)
    st_accounting_lines = @salary_expense_transfer.determine_additional_llpe_attributes(st_accounting_lines, :target)

    # now generate all LLPE lines that would be expected based on the accounting line labor and benefits attributes
    expected_llpe_lines = @salary_expense_transfer.generate_expected_llpe_data(st_accounting_lines)

    #now verify array of expected_llpe_lines are in the llpe_results_data array
    llpe_results_data.length.should ==  expected_llpe_lines.length
    expected_llpe_lines.each_with_index do |expected_line, expected_index|
      found = false
      llpe_results_data.each_with_index do |results_line, result_index|

        if @salary_expense_transfer.llpe_line_matches_accounting_line_data(llpe_results_data[result_index][:account_number],
                                                                           llpe_results_data[result_index][:object],
                                                                           llpe_results_data[result_index][:period],
                                                                           llpe_results_data[result_index][:balance_type],
                                                                           llpe_results_data[result_index][:amount],
                                                                           llpe_results_data[result_index][:debit_credit_code],
                                                                           expected_llpe_lines[expected_index][:account_number],
                                                                           expected_llpe_lines[expected_index][:object],
                                                                           expected_llpe_lines[expected_index][:period],
                                                                           expected_llpe_lines[expected_index][:balance_type],
                                                                           expected_llpe_lines[expected_index][:amount],
                                                                           expected_llpe_lines[expected_index][:debit_credit_code])
          found = true
          break
        end
      end
      found.should be true
    end
  end #page loop

end

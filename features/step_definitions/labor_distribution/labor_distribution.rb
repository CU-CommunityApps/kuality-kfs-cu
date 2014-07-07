When /^I start an empty Benefit Expense Transfer document$/ do
  @benefit_expense_transfer = create BenefitExpenseTransferObject
end

Given(/^And I select employee (\d+)$/) do|emp|
  on SalaryExpenseTransferPage do |page|
    page.empl_id.fit ''
    page.search_empl_id
  end
  on PersonLookup do |search|
    search.employee_id.fit emp
    search.search
    search.return_value(emp)
  end

end

And /^I search and retrieve Ledger Balance entry$/ do
  on(LaborDistributionPage) do |ldlookup|
    #look back to previous fiscal year at start of new fiscal year because we do not have labor data yet
    if "#{Date::MONTHNAMES[Date.today.month]}" == "July"
      previous_fiscal_year = ldlookup.fiscal_year.value.to_i - 1
      ldlookup.fiscal_year.set previous_fiscal_year
    end
    ldlookup.import_search
  end
  on LedgerBalanceLookupPage do |lblookup|
    #TODO Change to select first month with a positive balance.  Currently, first month regardless of balance is being selected.
    lblookup.check_first_month
    lblookup.return_selected
  end
end

And /^I copy source account to target account$/ do
  on(BenefitExpenseTransferPage).copy_source_accounting_line
end

And /^I change target account number to '(.*)'$/ do |account_number|
  on(BenefitExpenseTransferPage).update_target_account_number.fit account_number
end

And /^I transfer the Salary to another Account in my Organization$/ do |table|
  arguments = table.rows_hash
  @to_account = arguments['To Account']

  # do not continue, required parameters not sent
  if @to_account.nil?
    fail(ArgumentError.new('Required parameter To Account was not specified.'))
  end
  acct_gerkin = "I change target account number to '" + @to_account + "'"
  step acct_gerkin
end

And /^I transfer the Salary between accounts with different Account Types$/ do |table|
  arguments = table.rows_hash
  @to_account_different_types = arguments['To Account']

  # do not continue, required parameters not sent
  if @to_account_different_types.nil?
    fail(ArgumentError.new('Required parameter To Account was not specified.'))
  end
  acct_gerkin = "I change target account number to '" + @to_account_different_types + "'"
  step acct_gerkin
end

And /^I transfer the Salary to an Account with a different Rate but the same Account Type and Organization$/ do |table|
  # fedrate (FD) vs nonfedrate (NF)
  arguments = table.rows_hash
  @to_account = arguments['To Account']

  # do not continue, required parameters not sent
  if @to_account.nil?
    fail(ArgumentError.new('Required parameter To Account was not specified.'))
  end
  acct_gerkin = "I change target account number to '" + @to_account + "'"
  step acct_gerkin
end


And /^I change target sub account number to '(.*)'$/ do |sub_account_number|
  on(BenefitExpenseTransferPage).update_target_sub_account_code.fit sub_account_number
end

Given(/^And I start an empty Salary Expense Transfer document$/) do
  @salary_expense_transfer = create SalaryExpenseTransferObject
end


Given  /^I CREATE A SALARY EXPENSE TRANSFER with following:$/ do |table|
  arguments = table.rows_hash
  @user_principal = arguments['User Name']
  @empl_id = arguments['Employee']

  # do not continue, required parameters not sent
  if @user_principal.nil? || @empl_id.nil?
    fail(ArgumentError.new('One or more required parameters were not specified.'))
  end

  login_gerkin = 'Given I am User ' + @user_principal + ' who is a Salary Transfer Initiator'
  steps login_gerkin

  step "And I start an empty Salary Expense Transfer document"
  employee_gerkin = 'And I select employee ' + @empl_id
  step employee_gerkin

  steps %Q{ And   I search and retrieve Ledger Balance entry
            And   I copy source account to target account
  }
end

Given  /^I CREATE A BENEFIT EXPENSE TRANSFER with following:$/ do |table|
  arguments = table.rows_hash
  steps %Q{ Given I Login as a Benefit Transfer Initiator
            And   I start an empty Benefit Expense Transfer document
  }
  if !arguments['From Account'].nil?
    step "I set transfer from account number to '#{arguments['From Account']}' on Benefit Expense Transfer document"
  end
  steps %Q{ And   I search and retrieve Ledger Balance entry
            And   I copy source account to target account
  }

  if !arguments['To Account'].nil?
    step "I change target account number to '#{arguments['To Account']}'"
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

Then /^I RUN THE NIGHTLY LABOR BATCH PROCESSES$/ do
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
  if @user_outside_organization.nil?
    fail(ArgumentError.new('Required parameter User Name was not specified.'))
  end

  step "I am logged in as \"#{@user_outside_organization}\""
  visit(MainPage).doc_search
  on DocumentSearch do |page|
    page.document_id_field.set @remembered_document_id
    page.search
    page.open_item(@remembered_document_id)
  end
  step "I should get an Authorization Exception Report error"
end

And /^a Salary Expense Transfer initiator inside the organization can view the document$/ do |table|
  arguments = table.rows_hash
  @user_inside_organization = arguments['User Name']

  # do not continue, required parameters not sent
  if @user_inside_organization.nil?
    fail(ArgumentError.new('Required parameter User Name was not specified.'))
  end

  step "I am logged in as \"#{@user_inside_organization}\""
  visit(MainPage).doc_search
  on DocumentSearch do |page|
    page.document_id_field.set @remembered_document_id
    page.search
    page.open_item(@remembered_document_id)
  end
end
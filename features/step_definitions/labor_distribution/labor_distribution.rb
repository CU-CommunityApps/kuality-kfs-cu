When /^I start an empty Benefit Expense Transfer document$/ do
  @benefit_expense_transfer = create BenefitExpenseTransferObject
end

And /^I select employee '(.*)'$/ do |emp|
  on SalaryExpenseTransferPage do |page|
    page.empl_id.fit ''
    page.search_empl_id
  end
  on PersonLookup do |search|
    search.principal_name.fit emp
    search.search
    search.return_value(emp)
  end

end

And /^I search and retrieve Ledger Balance entry$/ do

  on(LaborDistributionPage).import_search
  on LedgerBalanceLookupPage do |lblookup|
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

And /^I change target sub account number to '(.*)'$/ do |sub_account_number|
  on(BenefitExpenseTransferPage).update_target_sub_account_code.fit sub_account_number
end

When /^I start an empty Salary Expense Transfer document$/ do
  @salary_expense_transfer = create SalaryExpenseTransferObject
end

Given  /^I CREATE A SALARY EXPENSE TRANSFER with following:$/ do |table|
  arguments = table.rows_hash
  user_name = arguments['Employee']
  to_account_number = arguments['To Account']
  steps %Q{ Given I Login as a Salary Transfer Initiator
            And   I start an empty Salary Expense Transfer document
  }
  if !arguments['Employee'].nil?
      step "I select employee '#{user_name}'"
  end
  steps %Q{ And   I search and retrieve Ledger Balance entry
            And   I copy source account to target account
  }
  if !arguments['To Account'].nil?
     step "I change target account number to '#{to_account_number}'"
  end
  steps %Q{ And   I submit the Salary Expense Transfer document
            And   the Salary Expense Transfer document goes to ENROUTE
            And   I route the Salary Expense Transfer document to FINAL by clicking approve for each request
            Then  the Salary Expense Transfer document goes to FINAL
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
            And   I route the Benefit Expense Transfer document to FINAL by clicking approve for each request
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
When /^I start an empty Benefit Expense Transfer document$/ do
  @benefit_expense_transfer = create BenefitExpenseTransferObject
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


Then /^I RUN THE NIGHTLY LABOR BATCH PROCESSES $/ do
  steps %Q{
    Given I am logged in as a KFS Operations
    And I run the Labor Enterprise Feed Process
    And I run the Labor Nightly Out Process
    And I run the Labor Scrubber Process
    And I run the Labor Poster Process
    And I run the Labor Balancing Job
    And I run the Labor Feed Job
    And I run the Labor Clear Pending Entries Job   }

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
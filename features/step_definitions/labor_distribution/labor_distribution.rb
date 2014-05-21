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


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
    #lblookup.month_box('August').click
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
   }
  x = 0 # force it out after 10, in  case something goes wrong
  while on(SalaryExpenseTransferPage).document_status != 'FINAL' && x < 10
    x += 1
    step "I switch to the user with the next Pending Action in the Route Log for the Salary Expense Transfer document"
    step "I view the Salary Expense Transfer document"
    step "I approve the Salary Expense Transfer document"
    step "the Salary Expense Transfer document goes to one of the following statuses:", table(%{
        | ENROUTE   |
        | FINAL     |
      })
  end
  step   "the Salary Expense Transfer document goes to FINAL"

end
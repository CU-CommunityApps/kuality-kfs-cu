When /^I start an empty Distribution Of Income And Expense document$/ do
  @distribution_of_income_and_expense = create DistributionOfIncomeAndExpenseObject, initial_lines: []
end

And /^I change the DI from Account to one not owned by the current user$/ do
  @distribution_of_income_and_expense.accounting_lines['source'.to_sym][0].edit account_number: "A763900"
end

And /^I change the DI from Account to one owned by the current user$/ do
  @distribution_of_income_and_expense.accounting_lines['source'.to_sym][0].edit account_number: "1753302"
end

And /^I add a (from|to) amount of "(.*)" for account "(.*)" with object code "(.*)" with a line description of "(.*)" to the DI document$/  do |target, amount, account_number, object_code, line_desc|
  on DistributionOfIncomeAndExpensePage do |page|
    case target
      when 'from'
        @distribution_of_income_and_expense.add_source_line({
                                               account_number:   account_number,
                                               object:           object_code,
                                               amount:   amount,
                                               line_description: line_desc
                                           })
      when 'to'
        @distribution_of_income_and_expense.add_target_line({
                                               account_number:   account_number,
                                               object:           object_code,
                                               amount:   amount,
                                               line_description: line_desc
                                           })
    end
  end
end
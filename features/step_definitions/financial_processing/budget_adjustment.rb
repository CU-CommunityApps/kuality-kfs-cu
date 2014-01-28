And /^I create a Budget Adjustment document$/ do
  @budget_adjustment = create BudgetAdjustmentObject
end

And /^I (#{ObjectCodeGlobalPage::available_buttons}) a Budget Adjustment document$/ do |button|
  button.gsub!(' ', '_')
  @budget_adjustment = create BudgetAdjustmentObject, press: button
end

And /^I add a from amount of (.*) for account (.*) with object code (.*)$/  do |amount, account_number, object_code|
  on BudgetAdjustmentPage do |page|
    page.from_current_amount.fit amount
    page.from_account_number.fit account_number
    page.from_object_code.fit object_code
    page.add_from_accounting_line
  end
end

And /^I add a to amount of (.*) for account (.*) with object code (.*)$/ do |amount, account_number, object_code|
  on BudgetAdjustmentPage do |page|
    page.to_current_amount.fit amount
    page.to_account_number.fit account_number
    page.to_object_code.fit object_code
    page.add_to_accounting_line
  end
end

Then /^budget adjustment should show an error that says "(.*?)"$/ do |error|
    on(BudgetAdjustmentPage).errors.should include error
end
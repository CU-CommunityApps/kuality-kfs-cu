And /^I create a Budget Adjustment document$/ do
  @budget_adjustment = create BudgetAdjustmentObject
end

And /^I (#{ObjectCodeGlobalPage::available_buttons}) a Budget Adjustment document$/ do |button|
  button.gsub!(' ', '_')
  @budget_adjustment = create BudgetAdjustmentObject, press: button
end

And /^I add a From amount of "(.*)" for account "(.*)" with object code "(.*)" with a line description of "(.*)"$/  do |amount, account_number, object_code, line_desc|
  on BudgetAdjustmentPage do |page|
    page.from_current_amount.fit amount
    page.from_account_number.fit account_number
    page.from_object_code.fit object_code
    page.from_line_description.fit line_desc
    page.add_from_accounting_line
  end
end

And /^I add a To amount of "(.*)" for account "(.*)" with object code "(.*)" with a line description of "(.*)"$/  do |amount, account_number, object_code, line_desc|
  on BudgetAdjustmentPage do |page|
    page.to_current_amount.fit amount
    page.to_account_number.fit account_number
    page.to_object_code.fit object_code
    page.from_line_description.fit line_desc
    page.add_to_accounting_line
  end
end

When /^I submit the Budget Adjustment document$/  do
  on(BudgetAdjustmentPage).submit
end

Then /^budget adjustment should show an error that says "(.*?)"$/ do |error|
    on(BudgetAdjustmentPage).errors.should include error
end


When /^I open the Budget Adjustment document page$/ do
  on(MainPage).budget_adjustment
end

Then /^I verify that Chart Value defaults to IT$/ do
  on BudgetAdjustmentPage do |page|
    page.from_chart_code.value.should == 'IT'
    page.to_chart_code.value.should == 'IT'
  end
end

And /^I submit a balanced Budget Adjustment document$/ do
  @budget_adjustment = create BudgetAdjustmentObject, press: :submit,
                              from_account_number: 'G003704', from_object_code: '4480',
                              from_current_amount: '250.11', from_line_description: random_alphanums(20, 'AFT FROM'),
                              to_account_number: 'G013300', to_object_code: '4480',
                              to_current_amount: '250.11', to_line_description: random_alphanums(20, 'AFT TO')
end

Then /^The document status should be ENROUTE$/ do
  pending # express the regexp above with the code you wish you had
end

And /^I view the Budget Adjustment Document$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I approve the Budget Adjustment document$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^The Budget Adjustment document status should be FINAL$/ do
  pending # express the regexp above with the code you wish you had
end

And /^I view the From Account on the General Ledger Balance with type code CB$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^The From Account Monthly Balance should match the From amount$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I view the To Account on the General Ledger Balance with type code CB$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^The To Account Monthly Balance should match the From amount$/ do
  pending # express the regexp above with the code you wish you had
end
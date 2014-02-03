And /^I create a Budget Adjustment document$/ do
  @budget_adjustment = create BudgetAdjustmentObject
end

And /^I (#{ObjectCodeGlobalPage::available_buttons}) a Budget Adjustment document$/ do |button|
  @budget_adjustment = create BudgetAdjustmentObject, press: button.gsub(' ', '_')
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

And /^I add a to amount of "(.*?)" for account "(.*?)" with object code "(.*?)" with a line description of "(.*?)"$/ do |amount, account_number, object_code, line_desc|
  on BudgetAdjustmentPage do |page|
      page.to_current_amount.fit amount
      page.to_account_number.fit account_number
      page.to_object_code.fit object_code
      page.from_line_description.fit line_desc
      page.add_to_accounting_line
    end
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
  @budget_adjustment = create BudgetAdjustmentObject, press: :save,
                              from_account_number: 'G003704', from_object_code: '4480',
                              from_current_amount: '250.11', from_line_description: random_alphanums(20, 'AFT FROM 1 '),
                              from_base_amount: '125', to_account_number: 'G013300', to_object_code: '4480',
                              to_current_amount: '250.11', to_line_description: random_alphanums(20, 'AFT TO 1 '),
                              to_base_amount: '125', to_chart_code: 'IT'

    on BudgetAdjustmentPage do |page|
      #TODO:: Make data object for adding accounting lines (sounds like better solution)
      @budget_adjustment.adding_a_from_accounting_line(page, 'G003704', '6510', '250.11', random_alphanums(20, 'AFT FROM 2 '), '125')
      @budget_adjustment.adding_a_to_accounting_line(page, 'G013300', '6510', '250.11', random_alphanums(20, 'AFT TO 2 '), '125')

      @press = 'submit'
      page.send(@press)
    end
end

#VIEW url uses the username to create the view page, which needs to be corrected to use general view method
And /^I view my Budget Adjustment document$/ do
  visit(MainPage)
   on DocumentSearch do |page|
     page.doc_search
     page.document_id_field.when_present.fit @budget_adjustment.document_id
     page.search
     page.open_item(@budget_adjustment.document_id)
  end
end

Then /^The Budget Adjustment document status should be (.*)$/ do |doc_status|
  on BudgetAdjustmentPage do |page|
    sleep 10

    page.document_status.should == doc_status
  end
end

And /^I view the From Account on the General Ledger Balance with balance type code of (.*)$/ do |bal_type_code|
  visit(MainPage).general_ledger_balance
  on GeneralLedgerBalanceLookupPage do |page|
    page.chart_code.fit @budget_adjustment.from_chart_code
    page.account_number.fit @budget_adjustment.from_account_number
    page.balance_type_code.fit bal_type_code
    page.search
    page.select_monthly_item(@budget_adjustment.from_object_code, @budget_adjustment.converted_month_number)
 end
 on GeneralLedgerEntryLookupPage do |page|
   page.select_this_link_without_frm(@budget_adjustment.document_id)
 end
end

When /^I view the To Account on the General Ledger Balance with balance type code of (.*)$/ do |bal_type_code|
  visit(MainPage).general_ledger_balance
  on GeneralLedgerBalanceLookupPage do |page|
    page.chart_code.fit @budget_adjustment.to_chart_code
    page.account_number.fit @budget_adjustment.to_account_number
    page.balance_type_code.fit bal_type_code
    page.search
    page.select_monthly_item(@budget_adjustment.to_object_code, @budget_adjustment.converted_month_number)
  end
  on(GeneralLedgerEntryLookupPage).select_this_link_without_frm(@budget_adjustment.document_id)
end

Then /^The From Account Monthly Balance should match the From amount$/ do
  on BudgetAdjustmentPage do |page|
    page.find_from_amount.should == @budget_adjustment.from_current_amount
    page.find_to_amount.should == @budget_adjustment.to_current_amount
    page.find_from_line_description.should == @budget_adjustment.from_line_description
    page.find_to_line_description.should == @budget_adjustment.to_line_description
  end
end

Then /^The To Account Monthly Balance should match the To amount$/ do
  on(BudgetAdjustmentPage).find_to_amount.should == @budget_adjustment.to_current_amount
  end
end

And(/^The line description for the From Account should be displayed$/) do
  on(BudgetAdjustmentPage).find_from_line_description.should == @budget_adjustment.from_line_description
end

And(/^The line description for the To Account should be displayed$/) do
  on(BudgetAdjustmentPage).find_to_line_description.should == @budget_adjustment.to_line_description
end

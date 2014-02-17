When /^I start an empty Budget Adjustment document$/ do
  visit(MainPage).budget_adjustment
  @budget_adjustment = create BudgetAdjustmentObject, press: nil,
                                                      initial_lines: []
end

And /^I start a Budget Adjustment document$/ do
  @budget_adjustment = create BudgetAdjustmentObject, press: nil
end

And /^I create a Budget Adjustment document for file import$/ do
  @budget_adjustment = create BudgetAdjustmentObject, description:    random_alphanums(20, 'AFT Budget Adj '),
                              from_chart_code: nil,
                              from_account_number: nil,
                              from_object_code: nil,
                              from_current_amount: nil,
                              from_file_name: 'BA_test_from.csv',
                              to_file_name: 'BA_test_to.csv',
                              press: nil
end

And /^I (#{BudgetAdjustmentPage::available_buttons}) a Budget Adjustment document$/ do |button|
  button.gsub!(' ', '_')
  @budget_adjustment = create BudgetAdjustmentObject, press: button
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

And /^I add a (from|to) amount of "(.*)" for account "(.*)" with object code "(.*)" with a line description of "(.*)"$/  do |target, amount, account_number, object_code, line_desc|
  on BudgetAdjustmentPage do |page|
    case target
      when 'from'
        @budget_adjustment.add_source_line({
                                              account_number:   account_number,
                                              object:           object_code,
                                              current_amount:   amount,
                                              line_description: line_desc
                                            })
      when 'to'
        @budget_adjustment.add_target_line({
                                             account_number:   account_number,
                                             object:           object_code,
                                             current_amount:   amount,
                                             line_description: line_desc
                                           })
    end
  end
end

When /^I open the Budget Adjustment document page$/ do
  on(MainPage).budget_adjustment
end

Then /^I verify that Chart Value defaults to IT$/ do
  on BudgetAdjustmentPage do |page|
    page.source_chart_code.value.should == 'IT'
    page.target_chart_code.value.should == 'IT'
  end
end

And /^I (#{BudgetAdjustmentPage::available_buttons}) a balanced Budget Adjustment document$/ do |button|
  button.gsub!(' ', '_')
  @budget_adjustment = create BudgetAdjustmentObject,
                              press: nil, # We should add the accounting lines before submitting, eh?
                              initial_lines: [
                                  {
                                      type:             :source,
                                      account_number:   'G003704',
                                      object:           '4480',
                                      current_amount:   '250.11',
                                      base_amount:      '125',
                                      line_description: random_alphanums(20, 'AFT FROM 1 '),
                                  },
                                  {
                                      type:             :target,
                                      account_number:   'G013300',
                                      object:           '4480',
                                      current_amount:   '250.11',
                                      base_amount:      '125',
                                      line_description: random_alphanums(20, 'AFT TO 1 '),
                                      chart_code:       'IT'
                                  }
                              ]

    on BudgetAdjustmentPage do |page|
      #TODO:: Make data object for adding accounting lines (sounds like better solution)
      #@budget_adjustment.adding_a_from_accounting_line(page, 'G003704', '6510', '250.11', random_alphanums(20, 'AFT FROM 2 '), '125')
      @budget_adjustment.add_source_line({
                                         account_number:   'G003704',
                                         object:           '6510',
                                         current_amount:   '250.11',
                                         line_description: random_alphanums(20, 'AFT TO 2 '),
                                         base_amount:      '125'
                                        })
      #@budget_adjustment.adding_a_to_accounting_line(page, 'G013300', '6510', '250.11', random_alphanums(20, 'AFT TO 2 '), '125')
      @budget_adjustment.add_target_line({
                                           account_number:   'G013300',
                                           object:           '6510',
                                           current_amount:   '250.11',
                                           line_description: random_alphanums(20, 'AFT TO 2 '),
                                           base_amount:      '125'
                                     })

      page.send(button)
    end
end

And /^I view the From Account on the General Ledger Balance with balance type code of (.*)$/ do |bal_type_code|
  visit(MainPage).general_ledger_balance
  on GeneralLedgerBalanceLookupPage do |page|
    page.chart_code.fit        @budget_adjustment.accounting_lines[:source][0].chart_code
    page.account_number.fit    @budget_adjustment.accounting_lines[:source][0].account_number
    page.balance_type_code.fit bal_type_code
    page.including_pending_ledger_entry_all.set
    page.search
    page.select_monthly_item(@budget_adjustment.accounting_lines[:source][0].object, BudgetAdjustmentObject::fiscal_period_conversion(right_now[:MON]))
 end
 on(GeneralLedgerEntryLookupPage) do |page|
   page.sort_results_by('Transaction Date')
   page.sort_results_by('Transaction Date')
   page.select_this_link_without_frm(@budget_adjustment.document_id)
 end
end

When /^I view the To Account on the General Ledger Balance with balance type code of (.*)$/ do |bal_type_code|
  visit(MainPage).general_ledger_balance
  on GeneralLedgerBalanceLookupPage do |page|
    page.chart_code.fit        @budget_adjustment.accounting_lines[:target][0].chart_code
    page.account_number.fit    @budget_adjustment.accounting_lines[:target][0].account_number
    page.balance_type_code.fit bal_type_code
    page.including_pending_ledger_entry_all.set
    page.search
    page.select_monthly_item(@budget_adjustment.accounting_lines[:target][0].object, BudgetAdjustmentObject::fiscal_period_conversion(right_now[:MON]))
  end
  on(GeneralLedgerEntryLookupPage) do |page|
    page.sort_results_by('Transaction Date')
    page.sort_results_by('Transaction Date')
    page.select_this_link_without_frm(@budget_adjustment.document_id)
  end
end

Then /^The From Account Monthly Balance should match the From amount$/ do
  on BudgetAdjustmentPage do |page|
    page.find_source_amount.should == @budget_adjustment.accounting_lines[:source][0].current_amount
    page.find_target_amount.should == @budget_adjustment.accounting_lines[:target][0].current_amount
    page.find_source_line_description.should == @budget_adjustment.accounting_lines[:source][0].line_description
    page.find_target_line_description.should == @budget_adjustment.accounting_lines[:target][0].line_description
  end
end

Then /^The To Account Monthly Balance should match the To amount$/ do
  on(BudgetAdjustmentPage).find_target_amount.should == @budget_adjustment.accounting_lines[:target][0].current_amount
end

And(/^The line description for the From Account should be displayed$/) do
  on(BudgetAdjustmentPage).find_source_line_description.should == @budget_adjustment.accounting_lines[:source][0].line_description
end

And(/^The line description for the To Account should be displayed$/) do
  on(BudgetAdjustmentPage).find_target_line_description.should == @budget_adjustment.accounting_lines[:target][0].line_description
end

And /^I upload From Accounting Lines containing Base Budget amounts$/ do
  on BudgetAdjustmentPage do |page|
    page.import_lines_from
    page.account_line_from_file_name.set($file_folder+@budget_adjustment.from_file_name)
    page.add_from_import
  end
end

And /^I upload To Accounting Lines containing Base Budget amounts$/ do
  on BudgetAdjustmentPage do |page|
    page.import_lines_to
    page.account_line_to_file_name.set($file_folder+@budget_adjustment.to_file_name)
    page.add_to_import
  end
end

Then /^The GLPE contains 4 Balance Type BB transactions$/ do
  visit(MainPage).general_ledger_pending_entry
  on GeneralLedgerPendingEntryLookupPage do |page|
    page.balance_type_code.fit 'BB'
    page.document_number.fit @budget_adjustment.document_id
    page.search

    page.item_row('LINE 1 FROM').should exist
    page.item_row('LINE 2 FROM').should exist
    page.item_row('LINE 1 TO').should exist
    page.item_row('LINE 2 TO').should exist
  end
end
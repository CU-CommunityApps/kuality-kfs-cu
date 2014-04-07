When /^I start an empty Budget Adjustment document$/ do
  visit(MainPage).budget_adjustment
  @budget_adjustment = create BudgetAdjustmentObject, press: nil,
                                                      initial_lines: []
end

And /^I start a Budget Adjustment document$/ do
  @budget_adjustment = create BudgetAdjustmentObject, press: nil
end

And /^I create a Budget Adjustment document for file import$/ do  # ME!
  @budget_adjustment = create BudgetAdjustmentObject, press: nil,
                                                      description: random_alphanums(20, 'AFT Budget Adj '),
                                                      initial_lines: [{
                                                                        type: :source,
                                                                        file_name: 'BA_test_from.csv'
                                                                      },
                                                                      {
                                                                        type: :target,
                                                                        file_name: 'BA_test_to.csv'
                                                                      }]
end

And /^I (#{BudgetAdjustmentPage::available_buttons}) a Budget Adjustment document$/ do |button|
  button.gsub!(' ', '_')
  @budget_adjustment = create BudgetAdjustmentObject, press: button
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

And /^I add a (From|To) amount of "(.*)" for account "(.*)" with object code "(.*)" with a line description of "(.*)"$/  do |target, amount, account_number, object_code, line_desc|
  on BudgetAdjustmentPage do |page|
    case target
      when 'From'
        @budget_adjustment.add_source_line({
                                              account_number:   account_number,
                                              object:           object_code,
                                              current_amount:   amount,
                                              line_description: line_desc
                                            })
      when 'To'
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
    page.source_chart_code.value.should == get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    page.target_chart_code.value.should == get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
  end
end

And /^I (#{BudgetAdjustmentPage::available_buttons}) a balanced Budget Adjustment document$/ do |button|
  button.gsub!(' ', '_')
  @budget_adjustment = create BudgetAdjustmentObject,
                              press: nil,
                              initial_lines: [
                                  {
                                      type:             :source,
                                      account_number:   'G003704',
                                      object:           '4480',
                                      current_amount:   '250.11',
                                      line_description: random_alphanums(20, 'AFT FROM 1 '),
                                  },
                                  {
                                      type:             :target,
                                      account_number:   'G013300',
                                      object:           '4480',
                                      current_amount:   '250.11',
                                      line_description: random_alphanums(20, 'AFT TO 1 '),
                                      chart_code:       get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
                                  }
                              ]

    on BudgetAdjustmentPage do |page|
      @budget_adjustment.add_source_line({
                                         account_number:   'G003704',
                                         object:           '6510',
                                         current_amount:   '250.11',
                                         line_description: random_alphanums(20, 'AFT TO 2 '),
                                        })
      @budget_adjustment.add_target_line({
                                           account_number:   'G013300',
                                           object:           '6510',
                                           current_amount:   '250.11',
                                           line_description: random_alphanums(20, 'AFT TO 2 '),
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
    page.select_monthly_item(@budget_adjustment.accounting_lines[:source][0].object, fiscal_period_conversion(right_now[:MON]))
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
    page.select_monthly_item(@budget_adjustment.accounting_lines[:target][0].object, fiscal_period_conversion(right_now[:MON]))
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

And /^The line description for the From Account should be displayed$/ do
  on(BudgetAdjustmentPage).find_source_line_description.should == @budget_adjustment.accounting_lines[:source][0].line_description
end

And /^The line description for the To Account should be displayed$/ do
  on(BudgetAdjustmentPage).find_target_line_description.should == @budget_adjustment.accounting_lines[:target][0].line_description
end


And /^I upload (To|From) Accounting Lines containing Base Budget amounts$/ do |type|
  on BudgetAdjustmentPage do
    case type
      when 'To'
        @budget_adjustment.accounting_lines[:target][0].import_lines
      when 'From'
        @budget_adjustment.accounting_lines[:source][0].import_lines
    end
  end
end

Then /^The GLPE contains 4 Balance Type (.*) transactions for the (.*) document$/ do |type_code, document|
  visit(MainPage).general_ledger_pending_entry
  on GeneralLedgerPendingEntryLookupPage do |page|
    page.balance_type_code.fit type_code.upcase
    page.document_number.fit @budget_adjustment.document_id
    page.search

    page.item_row('LINE 1 FROM').should exist
    page.item_row('LINE 2 FROM').should exist
    page.item_row('LINE 1 TO').should exist
    page.item_row('LINE 2 TO').should exist
  end
end

Then /^the Route Log displays a (From|To) Fiscal Officer$/ do |fo_type|
  on(KFSBasePage) do |page|
    page.expand_all

    annotation_col = page.pnd_act_req_table.keyed_column_index(:annotation)
    ro_col = page.pnd_act_req_table.keyed_column_index(:requested_of)
    first_fo_row = page.pnd_act_req_table
                       .column(annotation_col)
                       .index{ |c| c.exists? && c.visible? && c.text.match(/Fiscal Officer/) }
    page.pnd_act_req_table[first_fo_row][ro_col].should exist
    found_fo_cell = page.pnd_act_req_table[first_fo_row][ro_col]

    # We need to find the netid by following the link in the FO cell.
    found_fo_cell.links.first.click
    page.use_new_tab
    fiscal_officer = on(PersonPage).get_user
    page.close_children

    case fo_type
      when 'From'
        @from_fiscal_officer = fiscal_officer
      when 'To'
        @to_fiscal_officer = fiscal_officer
    end
  end
end

When /^I am logged in as the (From|To) Fiscal Officer$/ do |fo_type|
  case fo_type
    when 'From'
      step "I am logged in as \"#{@from_fiscal_officer}\""
    when 'To'
      step "I am logged in as \"#{@to_fiscal_officer}\""
  end
end
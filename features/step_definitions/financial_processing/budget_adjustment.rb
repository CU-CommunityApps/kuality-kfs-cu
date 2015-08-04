And /^I (#{BudgetAdjustmentPage::available_buttons}) a balanced Budget Adjustment document with accounting lines$/ do |button|
  button.gsub!(' ', '_')
  @budget_adjustment = create BudgetAdjustmentObject,
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
                                      chart_code:       get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
                                  }
                              ]
  @from_fiscal_officer = 'djj1'
  @to_fiscal_officer = 'sag3'
  on BudgetAdjustmentPage do |page|
      @budget_adjustment.add_source_line({
                                         account_number:   'G003704',
                                         object:           '6510',
                                         current_amount:   '250.11',
                                         line_description: random_alphanums(20, 'AFT TO 2 '),
                                         base_amount:      '125'
                                        })
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

And /^I capture the (CB|BB) balance amount on the GLB for:$/ do  |balance_type_code, table|
  updates = table.rows_hash

  visit(MainPage).general_ledger_balance

  on GeneralLedgerBalanceLookupPage do |page|
    page.chart_code.fit updates['chart code']
    page.account_number.fit updates['account number']
    page.object_code.fit updates['object code']
    page.balance_type_code.fit updates['balance type code']
    page.search

    case balance_type_code
      when 'CB'
        @cb_start_amount = page.get_cell_value_by_index(10)
      when 'BB'
        @bb_start_amount = page.get_cell_value_by_index(10)
      else
        puts 'This is not a handled Balance Type Code'
    end
  end
end

Then /^The BA Template (Current|Base) Amount equals the General Ledger Balance for (CB|BB)$/ do |amount_type, balance_type|
  on GeneralLedgerEntryLookupPage do |page|
    case balance_type
      when 'CB'
        page.table(id: 'row').text.should include(@source_account_data[:current_amount])
      when 'BB'
        page.table(id: 'row').text.should include(@source_account_data[:base_amount])
    end
  end
end
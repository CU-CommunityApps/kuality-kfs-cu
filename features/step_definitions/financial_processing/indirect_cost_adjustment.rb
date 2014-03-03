When /^I start an empty Indirect Cost Adjustment document$/ do
  @indirect_cost_adjustment = create IndirectCostAdjustmentObject
end

And /^I enter a Grant Accounting Line and a Receipt Accounting Line$/ do
  on IndirectCostAdjustmentPage do |page|
    @indirect_cost_adjustment.add_source_line({
                                                            account_number:   '1278003',
                                                            amount:           '2100'
                                                        })
    @indirect_cost_adjustment.add_target_line({
                                                            account_number:   'GACLOSE',
                                                            amount:           '2100 '
                                                        })
  end
end
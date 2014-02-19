When /^I start an empty Auxiliary Voucher document$/ do
  @auxiliary_voucher = create AuxiliaryVoucherObject, initial_lines: []
end

When /^I create an AV document with that Object Code$/ do
  @auxiliary_voucher = create AuxiliaryVoucherObject, initial_lines: []
  on AuxiliaryVoucherPage do |page|
    @auxiliary_voucher.add_source_line({
                                           account_number:   '1000819',
                                           object:           @lookup_object_code,
                                           credit:           '100',
                                           line_description: 'AV sample line'
                                       })
  end

end
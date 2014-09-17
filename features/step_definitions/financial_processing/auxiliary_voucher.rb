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

And /^I add credit and debit accounting lines with two different sub funds$/ do
  on AuxiliaryVoucherPage do |page|
    @auxiliary_voucher.add_source_line({
                                           account_number:   'A012000',
                                           object:           '6540',
                                           credit:           '100',
                                           line_description: 'AV sample credit line'
                                       })
    @auxiliary_voucher.add_source_line({
                                           account_number:   'G254700',
                                           object:           '6540',
                                           debit:            '100',
                                           line_description: 'AV sample debit line'
                                       })
  end
end
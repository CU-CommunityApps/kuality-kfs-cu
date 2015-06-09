When /^I create an AV document with that Object Code$/ do
  @auxiliary_voucher = create AuxiliaryVoucherObject, initial_lines: []
  on AuxiliaryVoucherPage do |page|
    @auxiliary_voucher.add_source_line({
                                           account_number:   get_random_account_number,
                                           object:           @lookup_object_code,
                                           credit:           '100',
                                           line_description: 'AV sample line'
                                       })
  end

end

And /^I add credit and debit accounting lines with two different sub funds$/ do
  source_account = get_random_account
  target_account = get_random_account
  # Keep looking for a target account that has a sub fund different from the source account
  while (KFSDataObject.split_code_description_at_first_hyphen(target_account['subFundGroup.codeAndDescription'][0])).eql?(split_code_description_at_first_hyphen(source_account['subFundGroup.codeAndDescription'][0]))
    target_account = get_random_account
  end

  object_code = get_random_object_code #using the same object code value for both source and target accounting lines

  on AuxiliaryVoucherPage do |page|
    @auxiliary_voucher.add_source_line({
                                           account_number:   source_account['accountNumber'][0],
                                           object:           object_code,
                                           credit:           '100',
                                           line_description: 'AV sample credit line'
                                       })
    @auxiliary_voucher.add_source_line({
                                           account_number:   target_account['accountNumber'][0],
                                           object:           object_code,
                                           debit:            '100',
                                           line_description: 'AV sample debit line'
                                       })
  end
end

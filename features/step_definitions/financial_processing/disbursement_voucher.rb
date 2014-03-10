When /^I start an empty Disbursement Voucher document$/ do
  default_fields = {
      payee_id:        nil, # not populating payment info when 'initialize'
      press:           :save
  }
  @disbursement_voucher = create DisbursementVoucherObject, default_fields
end

And /^I search for Disbursement Voucher with Retiree (\w+) and Reason Code (\w)$/ do |net_id, reason_code|
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  @disbursement_voucher.payee_id = net_id
  @disbursement_voucher.vendor_payee = false
  @disbursement_voucher.payee_lookup

end

And /^I retrieve only One Result$/ do
  @disbursement_voucher.num_result_rows.should == 2 # header+value rows
end

And /^I add accounting line with AccountNumber '(\w+)', ObjectCode '(\w+)', Amount '(\w+)' to test$/ do |account_number,object,amount|
  # TODO : not sure if the description of this step is ok ?
  @disbursement_voucher.check_amount = amount
  @disbursement_voucher.change_default_check_amount
  @disbursement_voucher.add_source_line({
                                            account_number: account_number,
                                            object: object,
                                            amount: amount
                                        })

end


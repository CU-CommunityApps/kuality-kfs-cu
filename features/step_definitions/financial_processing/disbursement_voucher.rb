When /^I start an empty Disbursement Voucher document$/ do
  @disbursement_voucher = create DisbursementVoucherObject
end

When /^I start an empty Disbursement Voucher document with Payment to Vendor (.*)$/ do |vendor_number|
  @disbursement_voucher = create DisbursementVoucherObject, payee_id: vendor_number
end


And /^I add the only payee with Retiree (\w+) and Reason Code (\w+) to the Disbursement Voucher$/ do |net_id, reason_code|
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  @disbursement_voucher.payee_id = net_id
  @disbursement_voucher.vendor_payee = false
  on (PaymentInformationTab) {|tab| @disbursement_voucher.fill_in_payment_info(tab)}
end

And /^I add an Accounting Line to the Disbursement Voucher with the following fields:$/ do |table|
  accounting_line_info = table.rows_hash
  accounting_line_info.delete_if { |k,v| v.empty? }
  @disbursement_voucher.check_amount = accounting_line_info['Amount']
  @disbursement_voucher.change_default_check_amount
  @disbursement_voucher.add_source_line({
                                            account_number: accounting_line_info['Number'],
                                            object: accounting_line_info['Object Code'],
                                            amount: accounting_line_info['Amount']
                                        })

end


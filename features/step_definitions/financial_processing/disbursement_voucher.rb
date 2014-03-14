When /^I start an empty Disbursement Voucher document$/ do
  @disbursement_voucher = create DisbursementVoucherObject
end

When /^I start an empty Disbursement Voucher document with Payment to Vendor (.*)$/ do |vendor_number|
  @disbursement_voucher = create DisbursementVoucherObject, payee_id: vendor_number
end


And /^I add the only payee with Payee Id (\w+) and Reason Code (\w+) to the Disbursement Voucher$/ do |net_id, reason_code|
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  on (PaymentInformationTab) do |tab|
    on(PaymentInformationTab).payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit @disbursement_voucher.payment_reason_code
      plookup.netid.fit               net_id
      plookup.search
      plookup.results_table.rows.length.should == 2 # header and value
      plookup.return_value(net_id)
    end
    @disbursement_voucher.fill_in_payment_info(tab)
  end
end

And /^I add an Accounting Line to the Disbursement Voucher with the following fields:$/ do |table|
  accounting_line_info = table.rows_hash
  accounting_line_info.delete_if { |k,v| v.empty? }
  @disbursement_voucher.check_amount = accounting_line_info['Amount']
  @disbursement_voucher.change_default_check_amount
  @disbursement_voucher.add_source_line({
                                            account_number: accounting_line_info['Number'],
                                            object: accounting_line_info['Object Code'],
                                            amount: accounting_line_info['Amount'],
                                            line_description: accounting_line_info['Description']
                                        })

end

And /^I search for the payee with Terminated Employee (\w+) and Reason Code (\w+) for Disbursement Voucher document with no result found$/ do |net_id, reason_code|
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  on(PaymentInformationTab).payee_search
  on PayeeLookup do |plookup|
    plookup.payment_reason_code.fit @disbursement_voucher.payment_reason_code
    plookup.netid.fit               net_id
    plookup.search
    plookup.frm.divs(id: 'lookup')[0].parent.text.should include 'No values match this search'
  end
end

And /^I copy a Disbursement Voucher document with Tax Address to persist$/ do
  # save original address for comparison.  The address fields are readonly
  @old_address_1 = on(PaymentInformationTab).address_1_value
  @old_address_2 = on(PaymentInformationTab).address_2_value
  @old_city = on(PaymentInformationTab).city_value
  @old_state = on(PaymentInformationTab).state_value
  @old_country = on(PaymentInformationTab).country_value
  @old_postal_code = on(PaymentInformationTab).postal_code_value

  get("disbursement_voucher").send("copy_current_document")

  # validate the Tax Address is copied over
  @old_address_1.should == on(PaymentInformationTab).address_1.value
  @old_address_2.strip.should == on(PaymentInformationTab).address_2.value.strip # 'strip' in case address_2 is empty which will result in " "
  @old_city.should == on(PaymentInformationTab).city.value
  @old_state.should == on(PaymentInformationTab).state.value
  @old_country.should == on(PaymentInformationTab).country.selected_options.first.text
  @old_postal_code.should == on(PaymentInformationTab).postal_code.value
end

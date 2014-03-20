When /^I start an empty Disbursement Voucher document$/ do
  @disbursement_voucher = create DisbursementVoucherObject
end

When /^I start an empty Disbursement Voucher document with Payment to Vendor (\d+-\d+) and Reason Code (\w+)$/ do |vendor_number, reason_code|
  case reason_code
    when 'B'
      payment_reason = 'B - Reimbursement for Out-of-Pocket Expenses'
    when 'N'
      payment_reason = 'N - Travel Payment for a Non-employee'

  end
  @disbursement_voucher = create DisbursementVoucherObject, payee_id: vendor_number, payment_reason_code: payment_reason
end

When /^I start an empty Disbursement Voucher document with Payment to Employee (.*)$/ do |net_id|
  @disbursement_voucher = create DisbursementVoucherObject, payee_id: net_id, vendor_payee: false
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
  on (PaymentInformationTab) {|tab| tab.check_amount.fit accounting_line_info['Amount']}
  @disbursement_voucher.add_source_line({
                                            account_number: accounting_line_info['Number'],
                                            object: accounting_line_info['Object Code'],
                                            amount: accounting_line_info['Amount'],
                                            line_description: accounting_line_info['Description']
                                        })

end

When /^I start an empty Disbursement Voucher document with only the Description field populated$/ do
  # Currently 'description' is included in dataobject's default, so this step is just in case 'description' is not in default.
  @disbursement_voucher = create DisbursementVoucherObject, description: random_alphanums(40, 'AFT')
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

And /^I change the Check Amount for the Disbursement Voucher document to (.*)$/ do |amount|
  on (PaymentInformationTab) {|tab| tab.check_amount.fit amount}
  on (AccountingLine) {|line| line.update_source_amount(0).fit amount}
end


When /^I start an empty Disbursement Voucher document with Payment to a Petty Cash Vendor$/ do
  #TODO : vendor number '41473-0' should be retrieved from service
  @disbursement_voucher = create DisbursementVoucherObject, payee_id: '41473-0', payment_reason_code: 'K - Univ PettyCash Custodian Replenishment'
end

And /^I copy a Disbursement Voucher document with Tax Address to persist$/ do
  # save original address for comparison.  The address fields are readonly
  old_address = []
  on (PaymentInformationTab) { |tab|
    old_address = [tab.address_1_value, tab.address_2_value.strip, tab.city_value, tab.state_value, tab.country_value, tab.postal_code_value]
  }

  get("disbursement_voucher").send("copy_current_document")

  # validate the Tax Address is copied over
  copied_address = []
  on (PaymentInformationTab) { |tab|
    copied_address = [tab.address_1.value, tab.address_2.value.strip, tab.city.value, tab.state.value, tab.country.selected_options.first.text, tab.postal_code.value]
  }

  old_address.should == copied_address
end


Then /^The eMail Address shows up in the Contact Information Tab$/ do
  on(DisbursementVoucherPage).email_address.value.should_not == ''
end

And /^I add a random employee payee to the Disbursement Voucher$/ do
  on (PaymentInformationTab) do |tab|
    tab.payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit 'B - Reimbursement for Out-of-Pocket Expenses'
      plookup.netid.fit               'aa*'
      plookup.search
      plookup.return_random
    end
    @disbursement_voucher.fill_in_payment_info(tab)
  end
end

And /^I add a Pre-Paid Travel Expense$/ do
  on(FinancialProcessingPage).expand_all
  on (PrePaidTravelExpensesTab) do |tab|
    tab.name.fit            'test'
    tab.department_code.fit 'test'
    tab.req_instate.fit     'test'
    tab.amount.fit          '100'
    tab.add_pre_paid_expense
  end
end

And /^I enter the Total Mileage of (\d+\.?\d*) in Travel Tab$/ do |mileage|
  on (DisbursementVoucherPage) {|page| page.car_mileage.fit mileage}
end

And /^the calculated Amount in the Travel Tab should match following Total Amount for each specified Start Date:$/ do |table|

  mileage_date_amount = table.raw.flatten.each_slice(2).to_a
  mileage_date_amount.shift # skip header row
  mileage_date_amount.each do |start_date, total_amount|
    on (DisbursementVoucherPage) do |page|
      page.per_diem_start_date.fit start_date
      page.calc_mileage_amount
      page.car_mileage_reimb_amt.value.should == total_amount
    end
  end
end

And /^I add a random vendor payee to the Disbursement Voucher$/ do
  on (PaymentInformationTab) do |tab|
    tab.payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit 'B - Reimbursement for Out-of-Pocket Expenses'
      plookup.vendor_name.fit         'Academy of Management'
      plookup.search
      plookup.return_random
      sleep 1
      plookup.return_random if $current_page.url.include?('businessObjectClassName=org.kuali.kfs.vnd.businessobject.VendorAddress')
    end
    @disbursement_voucher.fill_in_payment_info(tab)
  end
end

Then /^the copied DV payment address equals the selected address$/ do
  on (PaymentInformationTab) do |tab|
    tab.address_1.value.should == @disbursement_voucher.address_1
    tab.address_2.value.should == @disbursement_voucher.address_2
    tab.city.value.should == @disbursement_voucher.city
    tab.state.value.should == @disbursement_voucher.state
    tab.postal_code.value.should == @disbursement_voucher.postal_code
  end
end

When /^I copy the Disbursement Voucher document$/ do
  on(KFSBasePage) do |document_page|
    document_page.copy_current_document
    @document_id = document_page.document_id
  end
end
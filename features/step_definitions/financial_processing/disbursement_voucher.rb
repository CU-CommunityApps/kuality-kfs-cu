When /^I start an empty Disbursement Voucher document with Payment to Vendor (\d+-\d+) and Reason Code (\w+)$/ do |vendor_number, reason_code|
  case reason_code
    when 'B'
      payment_reason = 'B - Reimbursement for Out-of-Pocket Expenses'
    when 'N'
      payment_reason = 'N - Travel Payment for a Non-employee'
    when 'K'
      payment_reason = 'K - Univ PettyCash Custodian Replenishment'

  end
  @disbursement_voucher = create DisbursementVoucherObject, payee_id: vendor_number, payment_reason_code: payment_reason
end

And /^I search for the payee with Terminated Employee and Reason Code (\w+) for Disbursement Voucher document with no result found$/ do |reason_code|
  net_id = "msw13" # TODO : should get this from web services. Inactive employee with no other affiliation
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

When /^I start an empty Disbursement Voucher document with Payment to a Petty Cash Vendor$/ do
  #TODO : vendor number '41473-0' should be retrieved from service that dynamically obtains a petty cash vendor and not use a hard coded parameter value
  @disbursement_voucher = create DisbursementVoucherObject, payee_id: get_aft_parameter_value(ParameterConstants::DV_PETTY_CASH_VENDOR), payment_reason_code: 'K - Univ PettyCash Custodian Replenishment'
end

And /^I add a random vendor payee to the Disbursement Voucher$/ do
  on (PaymentInformationTab) do |tab|
    tab.payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit 'B - Reimbursement for Out-of-Pocket Expenses' #TODO config
      plookup.vendor_name.fit         'Academy of Management' #TODO LL fix (talk to Kyle)
      plookup.search
      plookup.return_random
      sleep 1
      plookup.return_random unless on(KFSBasePage).header_title.include?('Disbursement Voucher')
    end
    @disbursement_voucher.fill_in_payment_info(tab)
  end
end

And /^I complete the Foreign Draft Tab$/ do
  on PaymentInformationTab do |tab|
    tab.payment_method.fit  'F - Foreign Draft'
    tab.alert.ok if tab.alert.exists? # popup after select 'Foreign draft'
  end
  on DisbursementVoucherPage do |page|
    page.expand_all
    page.foreign_draft_in_foreign_currency.set
    page.currency_type.fit 'Canadian $'
  end
end

Then /^I complete the Nonresident Alien Tax Tab and generate accounting line for Tax$/ do
  on(DisbursementVoucherPage).expand_all
  on NonresidentAlienTaxTab do |tab|
    tab.income_class_code.fit      'R - Royalty'
    tab.federal_income_tax_pct.fit '30'
    tab.state_income_tax_pct.fit   '0'
    tab.postal_country_code.fit    'Canada'
    tab.generate_line
  end
end

And /^I select the added Remit Address$/ do
  on(VendorAddressLookup).return_value(@added_address.address_2)
  on PaymentInformationTab do |tab|
    @disbursement_voucher.fill_in_payment_info(tab)
    tab.payment_method.fit 'F - Foreign Draft'
    tab.alert.ok if tab.alert.exists? # popup after select 'Foreign draft'
  end
end

And /^I change Reason Code to (\w) for Payee search and select$/ do |reason_code|
  case reason_code
    when 'K'
      @disbursement_voucher.payment_reason_code = 'K - Univ PettyCash Custodian Replenishment'
  end
  on PaymentInformationTab do |tab|
    on PayeeLookup do |plookup|
      @disbursement_voucher.payee_id = plookup.vendor_number.value
      plookup.payment_reason_code.fit @disbursement_voucher.payment_reason_code
      plookup.search
      plookup.return_value(@disbursement_voucher.payee_id)
      sleep 1
      plookup.return_random if $current_page.url.include?('businessObjectClassName=org.kuali.kfs.vnd.businessobject.VendorAddress')
    end
    @disbursement_voucher.fill_in_payment_info(tab)
  end
end

And /^I add an? (.*) as payee and Reason Code (\w+) to the Disbursement Voucher$/ do |payee_status, reason_code|
  case payee_status
    when 'Retiree'
      @payee_net_id = "map3" # TODO : should get from web service
    when 'Active Staff, Former Student, and Alumnus'
      @payee_net_id = "nms32" # TODO : should get from web service or parameter
    when 'Active Employee, Former Student, and Alumnus'
      @payee_net_id = "vk76" # TODO : should get from web service or parameter. vk76 is inactive now.
    when 'Inactive Employee and Alumnus'
      @payee_net_id = "rlg3" # TODO : should get from web service or parameter.
  end
  step "I add the only payee with Payee Id #{@payee_net_id} and Reason Code #{reason_code} to the Disbursement Voucher"
end

Then /^the Payee Name should match$/ do
  #payee_name = get_person_name(@payee_net_id)
  payee_name = "Page, Marcia A." # should get this from web services
  on(PaymentInformationTab).payee_name.should == payee_name
end

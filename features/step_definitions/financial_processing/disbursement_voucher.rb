When /^I start an empty Disbursement Voucher document$/ do
  @disbursement_voucher = create DisbursementVoucherObject
end

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
And /^I add Vendor (\d+-\d+) to the Disbursement Voucher document as the Payee using the vendor's (\w+) address$/ do |vendor_number, address_type|
  case address_type
    when 'REMIT'
      @disbursement_voucher.address_type_description = 'RM - REMIT'
  end
  on (PaymentInformationTab) do |tab|
    tab.payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit 'B - Reimbursement for Out-of-Pocket Expenses'
      plookup.vendor_number.fit         vendor_number
      plookup.search
      plookup.return_value(vendor_number)
      on VendorAddressLookup do |valookup|
        valookup.address_type.fit @disbursement_voucher.address_type_description
        valookup.search
        valookup.return_value_links.first.click
      end
    end
    @disbursement_voucher.fill_in_payment_info(tab)
    tab.check_stub_text.fit 'Check pick-up at Department'
  end
end

And /^I fill out the Special Handling tab with the following fields:$/ do |table|
  on(DisbursementVoucherPage).expand_all
  special_handling = table.rows_hash
  special_handling.delete_if { |k,v| v.empty? }
  on (PaymentInformationTab) do |tab|
    tab.other_considerations_special_handling.set
    tab.alert.ok if tab.alert.exists? # click 'special handling' will have a pop up
  end
  on(SpecialHandlingTab) do |tab|
    tab.person_name.fit special_handling['Name']
    tab.address_1.fit special_handling['Address 1']
    tab.address_2.fit special_handling['Address 2']
    tab.city.fit special_handling['City']
    tab.country.fit special_handling['Country']
    tab.postal_code.fit special_handling['Postal Code']
  end
end

And /^I add note '(.*)' to the Disbursement Voucher document$/ do |note_text|
  on DisbursementVoucherPage do |page|
    page.note_text.fit note_text
    page.add_note
  end
end

And /^I uncheck Special Handling on Payment Information tab$/ do
  on (PaymentInformationTab) do |tab|
    tab.other_considerations_special_handling.clear
    on(SpecialHandlingTab) do |tab|
      tab.person_name.value.should == ''
      tab.address_1.value.should == ''
    end
  end
end

And /^the Special Handling is still unchecked on Payment Information tab$/ do
  on (PaymentInformationTab) {|tab| tab.other_considerations_special_handling.set?.should == false}
end

And /^I search and retrieve a DV Payee ID (\w+) with Reason Code (\w)$/ do |net_id, reason_code|
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  on (PaymentInformationTab) do |tab|
    tab.payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit @disbursement_voucher.payment_reason_code
      plookup.netid.fit         net_id
      plookup.search
      plookup.return_value(net_id)
    end
    @disbursement_voucher.fill_in_payment_info(tab)
  end
  on (DisbursementVoucherPage) do |page|
    page.phone_number.fit '607-123-4567' unless !page.phone_number..nil?
  end
end

And /^I add a DV foreign vendor (\d+-\d+) with Reason Code (\w)$/ do |vendor_number, reason_code|
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  on (PaymentInformationTab) do |tab|
    tab.payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit @disbursement_voucher.payment_reason_code
      plookup.vendor_number.fit         vendor_number
      plookup.search
      plookup.return_value(vendor_number)
      sleep 1
      plookup.return_random if $current_page.url.include?('businessObjectClassName=org.kuali.kfs.vnd.businessobject.VendorAddress')
    end
    @disbursement_voucher.fill_in_payment_info(tab)
  end
end

And /^I complete the Foreign Draft Tab$/ do
  on (PaymentInformationTab) do |tab|
    tab.payment_method.fit  'F - Foreign Draft'
    tab.alert.ok if tab.alert.exists? # popup after select 'Foreign draft'
  end
  on (DisbursementVoucherPage) do |page|
    page.expand_all
    page.foreign_draft_in_foreign_currency.set
    page.currency_type.fit 'Canadian $'
  end
end

And /^I change the Check Amount on the Payment Information tab to (.*)$/ do |amount|
  on (PaymentInformationTab) {|tab| tab.check_amount.fit amount}
end

And /^I change the Account (\w+) ?(\w+)? for Accounting Line (\d+) to (\w+) on the (.*)$/ do |account_field, account_field_1, line_number, new_value, document|
  line_idx = line_number.to_i - 1
  case account_field
    when 'Number'
      on (AccountingLine) {|line| line.update_source_account_number(line_idx).fit new_value}
    when 'Amount'
      on (AccountingLine) {|line| line.update_source_amount(line_idx).fit new_value}
    when 'Object'
      on (AccountingLine) {|line| line.update_source_object_code(line_idx).fit new_value}
    when 'Organization'
      on (AccountingLine) {|line| line.update_source_organization_reference_id(line_idx).fit  new_value}
  end

end

Then /^I complete the Nonresident Alien Tax Tab and generate accounting line for Tax$/ do
  on (DisbursementVoucherPage) {|page| page.expand_all}

    on (NonresidentAlienTaxTab) do |tab|
    tab.income_class_code.fit       'R - Royalty'
    tab.federal_income_tax_pct.fit  '30'
    tab.state_income_tax_pct.fit    '0'
    tab.postal_country_code.fit     'Canada'
    tab.generate_line
  end
end

When /^I select Disbursement Voucher document from my Action List$/ do
  visit(MainPage).action_list
  on(ActionList).last if on(ActionList).last_link.exists?
  on(ActionList).open_item(@disbursement_voucher.document_id)
end

And /^I update a random Bank Account to Disbursement Voucher Document$/ do
  on (DisbursementVoucherPage) do |page|
    page.bank_search
    on BankLookupPage do |blookup|
      blookup.search
      blookup.return_random
    end
  end
end

And /^I can NOT update the W-9\/W-8BEN Completed field on the Payment Information tab$/ do
  on (PaymentInformationTab) {|tab| tab.other_considerations_w9_completed.enabled?.should == false}
end

And /^I update the Postal Code on the Payment Information tab to (.*)$/ do |postal_code|
  on (PaymentInformationTab) {|tab| tab.postal_code.fit  postal_code}
end

And /^the Special Handling tab is open$/ do
  on (SpecialHandlingTab) {|tab| tab.close_special_handling.should exist}
end

And /^I search and retrieve Payee '(.*)' with Reason Code (\w)$/ do |vendor_name, reason_code|
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  on (PaymentInformationTab) do |tab|
    tab.payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit @disbursement_voucher.payment_reason_code
      plookup.vendor_name.fit         vendor_name
      plookup.search
      plookup.return_value_links.first.click
      sleep 1
      plookup.return_random if $current_page.url.include?('businessObjectClassName=org.kuali.kfs.vnd.businessobject.VendorAddress')
    end
    @disbursement_voucher.fill_in_payment_info(tab)
  end
end

And /^I search and retrieve DV foreign vendor (\d+-\d+) with Reason Code (\w)$/ do |vendor_number, reason_code|
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  on (PaymentInformationTab) do |tab|
    tab.payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit @disbursement_voucher.payment_reason_code
      plookup.vendor_number.fit         vendor_number
      plookup.search
      plookup.return_value(vendor_number)
    end
  end
end

And /^I select the added Remit Address$/ do
  on VendorAddressLookup do |valookup|
    valookup.return_value(@vendor.address_2)
  end
  on (PaymentInformationTab) do |tab|
    @disbursement_voucher.fill_in_payment_info(tab)
    tab.payment_method.fit  'F - Foreign Draft'
    tab.alert.ok if tab.alert.exists? # popup after select 'Foreign draft'
  end

end

And /^the GLPE contains Taxes withheld amount of (.*)$/ do |tax_amount|
  on (DisbursementVoucherPage) {|page| page.expand_all}
  on (GeneralLedgerPendingEntryTab) do |tab|
    tab.amount_array.should include(tax_amount)
  end
end

And /^I search Account and cancel on Account Lookup$/ do
  on(DisbursementVoucherPage) do |dv_page|
    dv_page.update_account_search(0)
    on AccountLookupPage do |page|
      page.cancel_button
    end
  end
end

And /^the Payee Id still displays on Disbursement Voucher$/ do
  on (PaymentInformationTab) {|tab| tab.payee_id_value.should include (@disbursement_voucher.payee_id)}
end

And /^I search Petty Cash vendor (\d+-\d+) with Reason Code (\w)$/ do |vendor_number, reason_code|
  case reason_code
    when 'B'
      @disbursement_voucher.payment_reason_code = 'B - Reimbursement for Out-of-Pocket Expenses'
  end
  on (PaymentInformationTab) do |tab|
    tab.payee_search
    on PayeeLookup do |plookup|
      plookup.payment_reason_code.fit @disbursement_voucher.payment_reason_code
      plookup.vendor_number.fit         vendor_number
      plookup.search
    end
  end
end

Then /^I should get a Reason Code error saying "([^"]*)"$/ do |error_msg|
  on (PayeeLookup) {|plookup| plookup.left_errmsg_text.should include error_msg}
end

And /^I change Reason Code to (\w) for Payee search and select$/ do |reason_code|
  case reason_code
    when 'K'
      @disbursement_voucher.payment_reason_code = 'K - Univ PettyCash Custodian Replenishment'
  end
  on (PaymentInformationTab) do |tab|
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


And /^I select a vendor payee to the (.*) document$/ do |document|
  if document.eql?('Disbursement Voucher')
    on (PaymentInformationTab) do |tab|
      tab.payee_search
      on PayeeLookup do |plookup|
        plookup.payment_reason_code.fit 'B - Reimbursement for Out-of-Pocket Expenses'
        plookup.vendor_name.fit         '*staple*'
        plookup.search
        plookup.return_value_links.first.click
        sleep 1
        plookup.return_random if $current_page.url.include?('businessObjectClassName=org.kuali.kfs.vnd.businessobject.VendorAddress')
      end
      @disbursement_voucher.fill_in_payment_info(tab)
    end
  end
end

And /^I navigate to Person page$/ do
  on(BasePage).close_extra_windows
  visit(AdministrationPage).person
end

And /^I lookup a user with no Primary Department Code$/ do

  on PersonLookup do |look|
    look.principal_name.fit  'l*'
    look.search
    look.sort_results_by('Primary Department Code')
    look.edit_person 'IT'
  end

end

And /^I assign the DV Initiator role to that user and Clear Cache$/ do

  on(PersonPage) do |page|
    page.expand_all
    @principal_name = page.principal_name.value
    page.description.fit random_alphanums(40, 'AFT')
    page.role_id.fit '100000191'
    page.add_role
    page.role_id.fit '54'
    page.add_role
    page.blanket_approve
  end

  visit(AdministrationPage).cache_admin
  on(CacheAdminPage) do |page|
    page.cache_boxes.each {|check_box| check_box.visible? ? check_box.click : nil }
    page.flush
  end
end

Given /^I am logged in as that user$/ do
  sleep 2  # sometimes this time is needed.
  visit(BackdoorLoginPage).login_as(@principal_name)
  visit(MainPage).disbursement_voucher

end

Then /^I should get a Global error saying "([^"]*)"$/ do |error_msg|
  on (DisbursementVoucherPage) {|page| page.left_errmsg_text.should include error_msg}
end

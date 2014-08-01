Given  /^I (initiate|submit) a Requisition document with the following:$/ do |action, table|

  arguments = table.rows_hash

  step 'I login as a KFS user to create an REQS'

  # TODO : more work here to get all the parameters right
  if arguments['Vendor Type'].nil? || arguments['Vendor Type'] != 'Blank'
    @vendor_number = get_aft_parameter_value('REQS_' + (arguments['Vendor Type'].nil? ? 'NONB2B' : arguments['Vendor Type'].upcase) + '_VENDOR')
  end
  @add_vendor_on_reqs = arguments['Add Vendor On REQS'].nil? ? 'Yes' : arguments['Add Vendor On REQS']
  positive_approve = arguments['Positive Approval'].nil? ? 'Unchecked' : arguments['Positive Approval']
  commodity_code = get_aft_parameter_value("REQS_#{arguments['Commodity Code'].nil? ? 'REGULAR' : arguments['Commodity Code'].upcase}_COMMODITY")
  account_number = get_aft_parameter_value("REQS_#{arguments['Account Type'].nil? ? 'NONGRANT' : arguments['Account Type'].upcase}_ACCOUNT") # from service or parameter
  apo_amount = get_parameter_values('KFS-PURAP', 'AUTOMATIC_PURCHASE_ORDER_DEFAULT_LIMIT_AMOUNT', 'Requisition')[0].to_i
  amount = arguments['Amount']
  @level = arguments['Level'].nil? ? 0 : arguments['Level'].to_i
  @sensitive_commodity = !arguments['Commodity Code'].nil? && arguments['Commodity Code'] == 'Sensitive'
  @commodity_review_routing_check = !arguments['Routing Check'].nil? && arguments['Routing Check'] == 'Commodity'
  @org_review_routing_check = @level > 0 && !arguments['Routing Check'].nil? && arguments['Routing Check'] == 'Base Org'
  item_qty = 1

  if amount.nil? || amount == 'LT APO'
    item_qty = apo_amount/1000 - 1
  else
    if amount == 'GT APO'
      item_qty = apo_amount/1000 + 1
    else
      item_qty = amount.to_i/1000
    end
  end

  # so far it used 6540, 6560, 6570 which are all EX type (Expense Expenditure)
  object_code =  get_aft_parameter_value(ParameterConstants::REQS_EX_OBJECT_CODE)
  object_code = get_aft_parameter_value(ParameterConstants::REQS_CA_OBJECT_CODE) unless arguments['CA System Type'].nil?
  step 'I create the Requisition document with:',
       table(%Q{
         | Vendor Number       | #{@vendor_number}  |
         | Item Quantity       | #{item_qty}        |
         | Item Cost           | 1000               |
         | Item Commodity Code | #{commodity_code}  |
         | Account Number      | #{account_number}  |
         | Object Code         | #{object_code}     |
         | Percent             | 100                |
       })

  if !@vendor_number.nil? && @add_vendor_on_reqs == 'Yes'
    @requisition.add_vendor_to_req(@vendor_number)
  end

  step 'I select the Payment Request Positive Approval Required' if positive_approve == 'Checked'

  unless arguments['CA System Type'].nil?
    step 'I fill in Capital Asset tab on Requisition document with:',
         table(%Q{
                  | CA System Type  | #{arguments['CA System Type']}  |
                  | CA System State | #{arguments['CA System State']} |
                 })
  end

  steps %q{
    When I add an attachment to the Requisition document
    And  I add a file attachment to the Notes and Attachment Tab of the Requisition document
    And  I enter Delivery Instructions and Notes to Vendor

    And  I calculate the Requisition document
    And  I submit the Requisition document
    Then the Requisition document goes to ENROUTE
  }

  case action
    when 'initiate'
      steps %q{
        And  I switch to the user with the next Pending Action in the Route Log to approve Requisition document to Final
        Then the Requisition document goes to FINAL
    }
    when 'submit'
    warn 'Submitting Requisition document not taking to final'
  end
end

And /^users outside the Route Log can not search and retrieve the REQS$/ do
  step "I am logged in as \"mrw258\"" # TODO : need a better way to figure out who can't view REQS
  visit(MainPage).requisitions
  on DocumentSearch do |page|
    page.document_id.fit @requisition.document_id
    #page.document_id.fit '5358712'
    page.search
    sleep 2
    unless page.lookup_div.parent.text.include?('No values match this search.')
      # if search found, then can not open
      page.open_item(@requisition.document_id)
      step 'I should get an Authorization Exception Report error'
    end
  end

end

And /^I extract the Requisition document to SciQuest$/ do
  step 'I am logged in as a Purchasing Processor'
  step 'I retrieve the Requisition document'
  step 'I check Related Documents Tab on Requisition Document'

  if !@auto_gen_po.nil? && !@auto_gen_po
    step 'I assign Contract Manager and approve Purchase Order Document to FINAL'
  end

  sleep 10 # We'll give a little time for this to process to SciQuest

  step 'I am logged in as the Initiator of the Requisition document'
  step 'I visit the "e-SHOP" page'
  step 'I view the Purchase Order document via e-SHOP'
  step 'the Document Status displayed \'Completed\''
  step 'the Delivery Instructions displayed equals what came from the PO'
  step 'the Attachments for Supplier came from the PO'

end

And /^I assign Contract Manager and approve Purchase Order Document to FINAL$/ do

  step 'I am logged in as a Purchasing Processor'
  step 'I submit a Contract Manager Assignment of \'10\' for the Requisition'
  step 'I am logged in as a PURAP Contract Manager'
  step 'I retrieve the Requisition document'
  step 'the View Related Documents Tab PO Status displays'
  step 'the Purchase Order Number is unmasked'

  step "I Complete Selecting Vendor #{@vendor_number}" unless @add_vendor_on_reqs == 'Yes'

  step 'I enter a Vendor Choice of \'Lowest Price\''
  step 'I calculate and verify the GLPE tab'
  step 'I add a random Delivery Phone number to the Purchase Order document'
  step 'I submit the Purchase Order document'

  step 'the Purchase Order document goes to one of the following statuses:',
       table('
              | ENROUTE   |
              | FINAL     |
            ')

  step 'I switch to the user with the next Pending Action in the Route Log to approve Purchase Order document to Final'
  step 'the Purchase Order document goes to FINAL'
  step 'in Pending Action Requests an FYI is sent to FO and Initiator'
  step 'the Purchase Order Doc Status is Open'

end

When /^I initiate a Payment Request document$/ do
  step 'I login as a Accounts Payable Processor to create a PREQ'
  step 'I fill out the PREQ initiation page and continue'
  step 'I change the Remit To Address'
  step 'I enter the Qty Invoiced and calculate'
  step 'I enter a Pay Date'
  step 'I attach an Invoice Image to the Payment Request document'
  step 'I calculate the Payment Request document'
  step 'I submit the Payment Request document and confirm any questions'
  step 'the Payment Request document goes to ENROUTE'
  step 'I route the Payment Request document to final'
  step 'the Payment Request Doc Status is Department-Approved'
  step 'the Payment Request document\'s GLPE tab shows the Requisition document submissions'
end

Then /^I format and process the check with PDP$/ do
  #purap batch
  step 'I am logged in as a KFS Operations'
  step 'I run Auto Approve PREQ'
  step 'I extract Electronic Invoices'
  step 'I extract Regular PREQS to PDP for Payment'
  step 'I extract Immediate PREQS to PDP for Payment'
  step 'I close POS wtih Zero Balanecs'
  step 'I load PREQ into PDP'

  # format checks
  step 'I Login as a PDP Format Disbursement Processor'
  step 'I format Disbursement'

  # generate output files batch jobs
  step 'I generate the ACH XML File'
  step 'I generate the Check XML File'
  step 'I generate the Cancelled Check XML File'
  step 'I send EMAIL Notices to ACH Payees'
  step 'I process Cancels and Paids'
  step 'I generate the GL Files from PDP'
  step 'I populate the ACH Bank Table'
  step 'I clear out PDP Temporary Tables'
end


And /^I format Disbursement$/ do
  visit(MaintenancePage).format_checks_ach
  on FormatDisbursementPage do |page|
    page.payment_date.set right_now[:date_w_slashes]
    page.all_payment_type.set
    page.all_payment_distribution.set
    page.customer_boxes.each { |check_box| check_box.checked? ? nil : check_box.click }
    page.begin_format
    sleep 20
  end
end

And /^I select continue on Format Disbursement Summary$/ do
  on(FormatDisbursementSummaryPage).continue_format
  # this will take a while
  sleep 60
end

And /^a Format Summary Lookup displays$/ do
  # TODO : not sure what to check
  # on FormatSummaryLookupPage do |page|
  #
  # end
  pending 'not sure what to check!'
end

Then /^the (.*) document routes to the correct individuals based on the org review levels$/ do |document|
  reqs_org_reviewers_level_1 = Array.new
  reqs_org_reviewers_level_2 = Array.new
  po_reviewer_5m = ''

  if @level == 1
    reqs_org_reviewers_level_1 = get_principal_name_for_role('KFS-SYS', 'ORG 0100 Level 1 Review')
  elsif @level >= 2
    reqs_org_reviewers_level_2 = get_principal_name_for_role('KFS-SYS', 'ORG 0100 Level 2 Review')
  end

  if document == 'Purchase Order'

    @base_org_review_level.should == @level
    po_reviewer_500k = get_aft_parameter_value('PO_BASE_ORG_REVIEW_500K')
    po_reviewer_5m = get_aft_parameter_value('PO_BASE_ORG_REVIEW_5M')
    po_reviewer_100k = get_principal_name_for_group('3000106')

    case @level
      when 1
        (@org_review_users & po_reviewer_100k).length.should >= 1
      when 2
        (@org_review_users & po_reviewer_100k).length.should >= 1
        @org_review_users.should include po_reviewer_500k
      when 3
        (@org_review_users & po_reviewer_100k).length.should >= 1
        @org_review_users.should include po_reviewer_500k
        @org_review_users.should include po_reviewer_5m
      else
        pending "Warning: Level not handled for Purchase Order, the level was #{@level}"
    end
  elsif document == 'Requisition' || document == 'Payment Request'
    case @level
     when 1
       (@org_review_users & reqs_org_reviewers_level_1).length.should >= 1
     when 2
       (@org_review_users & reqs_org_reviewers_level_2).length.should >= 1
     when 3
       (@org_review_users & reqs_org_reviewers_level_2).length.should >= 1
      else
        pending "Warning: Level not handled for the Requisition, the level was #{@level}"
    end
  end

end

And /^I validate Commodity Review Routing for (.*) document$/ do |document|
  # TODO : may need for POA in the future.
  if document == 'Purchase Order'
    @commodity_review_users.length.should == 0
  elsif document == 'Requisition'
    # TODO : reviewers should come from groupservice when it is ready
    reqs_animal_reviewers = get_principal_name_for_group('3000083')
    if @sensitive_commodity
      (@commodity_review_users & reqs_animal_reviewers).length.should >= 1
    else
      @commodity_review_users.length.should == 0
    end
  end
end

And /^the POA Routes to the FO$/ do
  @fo_users.length.should >= 1
end

And /^I amend the Purchase Order$/ do
  on(PurchaseOrderPage).amend_po
  on AmendPOReasonPage do |page|
    page.reason.fit random_alphanums(40, 'AFT-amendreason')
    page.amend
  end
  sleep 3
  @purchase_order_amendment = create PurchaseOrderAmendmentObject
end

When /^I initiate a Purchase Order Amendment document$/ do
  step 'I initiate a Purchase Order Amendment document with the following:', table(%q{| Default |  |})
end

And /^I submit a Purchase Order Amendment document$/ do
  step 'I submit a Purchase Order Amendment document with the following:',
       table('| All | Default |')
end


When /^I (initiate|submit) a Purchase Order Amendment document with the following:$/ do |action, table|
  arguments = table.rows_hash

  step "I am logged in as \"#{@requisition.initiator}\""
  step 'I view the Purchase Order document'
  step 'I amend the Purchase Order'

  if !arguments['Item Quantity'].nil? && arguments['Item Quantity'].to_f > 0
    @poa_item_amount = arguments['Item Quantity'].to_f * arguments['Item Cost'].to_f
    step 'I add an item to Purchase Order Amendment with:',
         table(%Q{
           | Item Quantity       | #{arguments['Item Quantity']}                                      |
           | Item Cost           | #{arguments['Item Cost']}                                          |
           | Item Commodity Code | #{@requisition.items.first.commodity_code}                         |
           | Account Number      | #{@requisition.items.first.accounting_lines.first.account_number}  |
           | Object Code         | #{@requisition.items.first.accounting_lines.first.object_code}     |
           | Percent             | 100                                                                |
         })
    step 'I calculate and verify the GLPE tab with no entries'
  else
    step 'I calculate and verify the GLPE tab'
  end

  step 'I submit the Purchase Order Amendment document'
  step 'the Purchase Order Amendment document goes to ENROUTE'

  case action
    when 'initiate'
      step 'I switch to the user with the next Pending Action in the Route Log to approve Purchase Order Amendment document to Final'
      step 'the Purchase Order Amendment document goes to FINAL'
    when 'submit'
      warn 'Just submitting Purchase Order Amendment document, not taking POA document to final'
  end

end

And /^I check Related Documents Tab on Requisition Document$/ do
  on RequisitionPage do |page|
    page.show_related_documents
    if page.view_related_doc.length > 1
      @auto_gen_po = true
      page.close_related_documents
      step 'the View Related Documents Tab PO Status displays'
    else
      @auto_gen_po = false
    end
  end
end

And /^I add an item to Purchase Order Amendment with:$/ do |table|
  arguments = table.rows_hash
  on PurchaseOrderAmendmentPage do |page|
    page.item_quantity.fit       arguments['Item Quantity']
    page.item_commodity_code.fit arguments['Item Commodity Code']
    page.item_description.fit    random_alphanums(15, 'AFT Item')
    page.item_unit_cost.fit      arguments['Item Cost']
    page.item_uom.fit            @requisition.items.first.uom
    page.item_add

    #Add Accounting line
    page.expand_all
    page.account_number(1).fit arguments['Account Number']
    page.object_code(1).fit    arguments['Object Code']
    page.percent(1).fit        arguments['Percent']
    page.add_account(1)
  end

end

And /^I calculate and verify the GLPE tab with no entries$/ do
  on PurchaseOrderAmendmentPage do |page|
    page.calculate
    #page.show_glpe

    page.glpe_results_table.text.should include( 'There are currently no General Ledger Pending Entries ' <<
                                                 'associated with this Transaction Processing document.' )
  end
end

Then /^the Purchase Order Amendment document's GLPE tab shows the new item amount$/ do
  on PurchaseOrderAmendmentPage do |page|
    page.show_glpe

    page.glpe_results_table.rows.length.should == 3
    page.glpe_results_table.text.should include @requisition.items.first.accounting_lines.first.account_number
    page.glpe_results_table[1][11].text.to_f.should == @poa_item_amount
    page.glpe_results_table[2][11].text.to_f.should == @poa_item_amount
  end
end

Then /^Award Review is not in the Requisition document workflow history$/ do
  root_action_requests =  get_root_action_requests(@requisition.document_id).getRootActionRequest().to_a
  root_action_requests.each do |root_action|
    root_action.annotation.should_not include 'Contracts' unless root_action.annotation.nil?
  end

end

And /^I fill in Capital Asset tab on Requisition document with:$/ do |table|
  system_params = table.rows_hash
  on RequisitionPage do |page|
    page.expand_all
    page.system_type.fit system_params['CA System Type']
    page.system_state.fit system_params['CA System State']
    page.select
  end

  case system_params['CA System State']
    when 'New System'
      case system_params['CA System Type']
        when 'One System'
          on RequisitionPage do |page|
            page.model_number.fit '2014 Bella Model'
            page.transaction_type_code.fit 'New'
            page.asset_system_description.fit random_alphanums(40, 'AFT CA desc')
            page.asset_number.fit '1'
            page.same_as_vendor
          end
        when 'Individual Assets'
          on RequisitionPage do |page|
            page.model_number.fit '2014 Bella Model'
            page.transaction_type_code.fit 'New'
            page.same_as_vendor
          end
        when 'Multiple Systems'
          on RequisitionPage do |page|
            page.transaction_type_code.fit 'New'
            page.asset_system_description.fit random_alphanums(40, 'AFT CA desc')
          end
      end
    when 'Modify Existing System'
      on RequisitionPage do |page|
        page.add_asset_number.fit @asset_number
        page.add_asset
        page.transaction_type_code.fit 'Modify existing'
      end
  end
end

Then /^I run the nightly Capital Asset jobs$/ do
  step 'I am logged in as a KFS Operations'
  step 'I collect the Capital Asset Documents'
  step 'I create the Plant Fund Entries'
  step 'I move the Plant Fund Entries to Posted Entries'
  step 'I clear Pending Entries'
  step 'I create entries for CAB'
end

And /^I lookup a Capital Asset to process$/ do
  visit(MainPage).capital_asset_builder_ap_transactions
  on CabPurapLookupPage do |page|
    page.preq_number.fit @preq_id
    page.search
    page.process @preq_id
  end
end

And /^I select and create asset$/ do
  on PurapTransactionPage do |page|
    page.line_item_checkbox.set
    page.create_asset
    page.use_new_tab
    page.close_parents
  end
  @asset_global = create AssetGlobalObject
end

And /^I complete the Asset Information Detail tab$/ do
  on AssetGlobalPage do |page|
    page.asset_type_code.fit '019'
    page.manufacturer.fit 'Jones Landscaping' if page.manufacturer.value.strip.empty?
  end
end

And /^I complete the existing Asset Location Information$/ do
  on AssetGlobalPage do |page|
    page.asset_campus.fit 'IT'
    page.asset_building_code.fit '7000'
    page.asset_building_room_number.fit 'XXXXXXXX'
    @asset_number = page.asset_number
  end
end


And /^I build a Capital Asset from AP transaction$/ do
  step 'I Login as an Asset Processor'
  step 'I lookup a Capital Asset to process'
  step 'I select and create asset'
  step 'I complete the Asset Information Detail tab'
  step 'I complete the existing Asset Location Information'
  step 'I submit the Asset Global document'
  step 'the Asset Global document goes to FINAL'
end


And /^I modify existing Capital Asset from AP transaction and apply payment$/ do
  step 'I Login as an Asset Processor'
  step 'I lookup a Capital Asset to process'
  step 'I select and apply payment'
  step 'I submit the Asset Manual Payment document'
  step 'the Asset Manual Payment document goes to FINAL'
end

And /^I select and apply payment$/ do
  on PurapTransactionPage do |page|
    #page.split_qty.fit '1'
    page.line_item_checkbox.set
    page.apply_payment
    page.use_new_tab
    page.close_parents
  end
  @asset_manual_payment = create AssetManualPaymentObject
end

And /^I add a random address to the Delivery tab on the Requisition document$/ do
  @requisition.add_random_building_address
end

And /^I set the added account percent to 50$/ do
  on RequisitionPage do |page|
    page.expand_all
    page.added_percent.fit '50'
    page.added_amount.set ' '
  end
end

And /^I add a random Requestor Phone number to the Requisition document$/ do
  @requisition.edit requestor_phone: random_phone_number
end

And /^I add these Accounting Lines to Item \#(\d+) on the (.*) document:$/ do |il, document, supplied|
  # table is a supplied.hashes.keys # => [:chart_code, :account_number, :object, :amount]
  il = il.to_i
  il -= 1

  on ItemsTab do |tab|
    tab.item_accounting_lines_section(il).should exist
    tab.show_item_accounting_lines unless tab.item_accounting_lines_shown?
  end

  supplied.hashes.each do |supplied_line|
    new_line = {
      chart_code:                supplied_line[:chart_code] == 'Default' ? get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE) : supplied_line[:chart_code],
      account_number:            supplied_line[:account_number][0].match(/[0-9]/m) ? supplied_line[:account_number] : get_account_of_type(supplied_line[:account_number]),
      sub_account_code:          supplied_line[:sub_account_code],
      object_code:               supplied_line[:object_code].length > 5 ? get_object_type_of_type(supplied_line[:object_code]) : supplied_line[:object_code],
      sub_object_code:           supplied_line[:sub_object_code],
      project_code:              supplied_line[:project_code],
      organization_reference_id: supplied_line[:organization_reference_id],
      line_description:          supplied_line[:line_description],
      percent:                   supplied_line[:percent],
      amount:                    supplied_line[:amount]
    }
    new_line.delete_if { |k, v| v.nil? }
    document_object_for(document).items[il].add_accounting_line new_line
  end
end
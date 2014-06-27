And /^I create the Requisition document with:$/  do |table|
  updates = table.rows_hash

  @requisition = create RequisitionObject,
                        payment_request_positive_approval_required: updates['payment request'],
                        vendor_number:    updates['Vendor Number'],
                        initial_item_lines: [{
                          quantity:       updates['Item Quantity'],
                          unit_cost:      updates['Item Cost'],
                          commodity_code: updates['Item Commodity Code'],
                          catalog_number: updates['Item Catalog Number'],
                          description:    updates['Item Description'].nil? ? random_alphanums(15, 'AFT') : updates['Item Description'],
                          initial_accounting_lines: [{
                                                      account_number: updates['Account Number'],
                                                      object_code:    updates['Object Code'],
                                                      percent:        updates['Percent']
                                                     }]
                        }]
end

And /^I create the Requisition document with an Award Account and items that total less than the dollar threshold Requiring Award Review$/ do
  account_info = get_kuali_business_object('KFS-COA','Account','subFundGroupCode=APFEDL&closed=N&contractsAndGrantsAccountResponsibilityId=5&accountExpirationDate=NULL')
  award_account_number = account_info['accountNumber'][0]
  cost_from_param = get_parameter_values('KFS-PURAP', 'DOLLAR_THRESHOLD_REQUIRING_AWARD_REVIEW', 'Requisition')[0].to_i
  cost_from_param = cost_from_param - 1
  step 'I create the Requisition document with:',
       table(%Q{
         | Vendor Number       | 4471-0                  |
         | Item Quantity       | 1                       |
         | Item Cost           | #{cost_from_param}      |
         | Item Commodity Code | 12142203                |
         | Account Number      | #{award_account_number} |
         | Object Code         | 6570                    |
         | Percent             | 100                     |
       })
end

And /^I add an item to the Requisition document with:$/ do |table|
  add_item = table.rows_hash

  @requisition.add_item_line({
    quantity:  add_item['Item Quantity'],
    unit_cost: add_item['Item Cost'],
    commodity_code: add_item['Item Commodity Code'],
    catalog_number: add_item['Item Catalog Number'],
    uom: add_item['Item Unit of Measure'],
    description: (add_item['Item Description'].nil? ? random_alphanums(15, 'AFT') : add_item['Item Description']),
    initial_accounting_lines: [{
                                account_number: add_item['Account Number'],
                                object_code:    add_item['Object Code'],
                                percent:        add_item['Percent']
                               }]
  })
end

And /^I calculate my Requisition document$/ do
  on(RequisitionPage).calculate
  #need to let calculate process, no other way to verify calculate is completed
  sleep 3
end

And /^the Requisition status is '(.*)'$/ do |req_status|
  on(RequisitionPage).requisition_status.should include req_status
end

And /^I view the (.*) document on my action list$/ do |document|
  visit(MainPage).action_list
  on ActionList do |page|
    #sort the date
    # if previous user already clicked this sort, then action list for next user will be sorted with 'Date created'.  So, add this 'unless' check
    page.sort_results_by('Date Created') unless page.result_item(document_object_for(document).document_id).exists?
    page.result_item(document_object_for(document).document_id).wait_until_present
    page.open_item(document_object_for(document).document_id)
  end
  if document.eql?('Requisition')
    on RequisitionPage do |page|
      @requisition_id = page.requisition_id
      @requisition_initiator = page.initiator
    end
  end

end

And /^I view the Requisition document from the Requisitions search$/ do
  visit(MainPage).requisitions
  on DocumentSearch do |page|
    page.requisition_num
    page.search
    page.open_item(@requisition.document_id)
  end
end

And /^I (submit|close|cancel) a Contract Manager Assignment of '(\d+)' for the Requisition$/ do |btn, contract_manager_number|
  visit(MainPage).contract_manager_assignment
  on ContractManagerAssignmentPage do |page|
    page.set_contract_manager(@requisition_id, contract_manager_number)
    page.send(btn)
  end
  sleep 5
end

And /^I retrieve the Requisition document$/ do
  visit(MainPage).requisitions  #remember "S" is for search
  on DocumentSearch do |page|
    page.document_type.set 'REQS'
    page.requisition_num.fit @requisition_id
    page.search
    page.open_item(@requisition.document_id)
  end
end

And /^the View Related Documents Tab PO Status displays$/ do
  on RequisitionPage do |page|
    page.show_related_documents
    page.show_purchase_order
    @purchase_order_number = page.purchase_order_number
    # verify unmasked and 'UNAPPROVED'
    page.purchase_order_number.should_not include '*****' # unmasked
    if !@auto_gen_po.nil? && !@auto_gen_po
      page.po_unapprove.should include 'UNAPPROVED'
    end
    page.purchase_order_number_link

    sleep 10
    @purchase_order = create PurchaseOrderObject
  end
end

And /^the Purchase Order Number is unmasked$/ do
  on(PurchaseOrderPage).po_number.should_not include '****'
end

And /^I Select the PO$/ do
  pending # express the regexp above with the code you wish you had
end

And /^I Complete Selecting Vendor (.*)$/ do |vendor_number|
  on(PurchaseOrderPage).vendor_search
  on VendorLookupPage do |vlookup|
    vlookup.vendor_number.fit vendor_number
    vlookup.search
    vlookup.return_value(vendor_number)
  end
end

And /^I Complete Selecting a Foreign Vendor$/ do
  on(PurchaseOrderPage).vendor_search
  on VendorLookupPage do |vlookup|
    vendor_number = '39210-0' # TODO : this vendor number should be from a parameter
    vlookup.vendor_number.fit vendor_number
    vlookup.search
    vlookup.return_value(vendor_number)
  end
end

And /^I enter a Vendor Choice$/ do
  on(PurchaseOrderPage).vendor_choice.fit 'Lowest Price'
end

And /^I calculate and verify the GLPE with amount (.*)$/ do |amount|
  on PurchaseOrderPage do |page|
    page.expand_all
    page.calculate
  end
  # TODO : not sure what to verify about GLPE
  on (GeneralLedgerPendingEntryTab) do |gtab|
    idx = gtab.glpe_tables.length - 1
    glpe_table = gtab.glpe_tables[idx]
    glpe_table[1][11].text.should include amount
    glpe_table[2][11].text.should include amount
    if glpe_table[1][12].text.eql?('D')
      glpe_table[2][12].text.should == 'C'
    else
      if glpe_table[1][12].text.eql?('C')
        glpe_table[2][12].text.should == 'D'
      end
    end
  end
end

And /^I submit the PO eDoc Status is$/ do
  pending # express the regexp above with the code you wish you had
end



And /^The PO eDoc Status is$/ do
  pending # express the regexp above with the code you wish you had
end


And(/^the (.*) Doc Status is (.*)/) do |document, doc_status|
  on(KFSBasePage).app_doc_status.should == doc_status
end

And /^I Complete Selecting a Vendor (.*)$/ do |vendor_number|
  on(PurchaseOrderPage).vendor_search
  on VendorLookupPage do |vlookup|
    vlookup.vendor_number.fit vendor_number
    vlookup.search
    vlookup.return_value(vendor_number)
  end
end

And /^I enter a Vendor Choice of '(.*)'$/ do  |choice|
  on(PurchaseOrderPage).vendor_choice.fit choice
end

And /^I calculate and verify the GLPE tab$/ do
  on PurchaseOrderPage do |page|
    page.calculate
    page.show_glpe

    page.glpe_results_table.text.include? @requisition.items.first.accounting_lines.first.object_code
    page.glpe_results_table.text.include? @requisition.items.first.accounting_lines.first.account_number
    # credit object code should be 3110 (depends on parm)

  end
end

Then /^in Pending Action Requests an FYI is sent to FO and Initiator$/ do
  on PurchaseOrderPage do |page|
    # TODO : it looks like there is no reload button when open PO with final status.  so comment it out for now.  need further check
    #Watir::Wait::TimeoutError: timed out after 30 seconds, waiting for {:class=>"globalbuttons", :title=>"reload", :tag_name=>"button"} to become present    page.reload # Sometimes the pending table doesn't show up immediately.
    #page.headerinfo_table.wait_until_present
    page.expand_all
    page.refresh_route_log # Sometimes the pending table doesn't show up immediately.
    page.show_pending_action_requests if page.pending_action_requests_hidden?
    fyi_initiator = 0
    fyi_fo = 0
    (1..page.pnd_act_req_table.rows.length - 2).each do |i|
      if page.pnd_act_req_table[i][1].text.include?('FYI')
        if page.pnd_act_req_table[i][4].text.include? 'Fiscal Officer'
          fyi_fo += 1
        else
          if page.pnd_act_req_table[i][4].text.include? 'Initiator'
            fyi_initiator += 1
           end
        end
      end
    end
    fyi_initiator.should >= 1
    fyi_fo.should >= 1
  end
end

And /^the Purchase Order document status is '(.*)'$/  do  |status|
  on PurchaseOrderPage do |page|
    sleep 5
    page.reload
    page.document_status.should == status
  end
end

And /^the Purchase Order Doc Status equals '(.*)'$/ do |po_doc_status|
  #this is a different field from the document status field
  on(PurchaseOrderPage).po_doc_status.should == po_doc_status
end

And /^The Requisition status is '(.*)'$/ do |doc_status|
  on RequisitionPage do |page|
    sleep 5
    page.reload unless page.reload_button.nil?
    page.document_status == doc_status
  end
end

And /^I select the purchase order '(\d+)' with the doc id '(\d+)'$/ do |req_num, doc_id|
  on DocumentSearch do |page|
    page.requisition_number.set req_num.to_s
    page.search
    page.result_item(doc_id.to_s).when_present.click
    sleep 5
  end
end

And /^I fill out the PREQ initiation page and continue$/ do
  visit(MainPage).payment_request
  on PaymentRequestInitiationPage do |page|
    page.purchase_order.fit        @purchase_order_number
    page.invoice_date.fit          yesterday[:date_w_slashes]
    page.invoice_number.fit        rand(100000)
    page.vendor_invoice_amount.fit @requisition.items.first.quantity.delete(',').to_f * @requisition.items.first.unit_cost.to_i
    page.continue
  end
  on(YesOrNoPage) { |yonp| yonp.yes if yonp.yes_button.exists? }
  sleep 10
  @payment_request = create PaymentRequestObject
end

And  /^I change the Remit To Address$/ do
  on(PaymentRequestPage) { |p| p.vendor_address_1.fit "Apt1#{p.vendor_address_1.value}" }
end

And  /^I enter the Qty Invoiced and calculate$/ do
  on PaymentRequestPage do |page|
    @preq_id = page.preq_id
    page.item_qty_invoiced.fit @requisition.items.first.quantity # same as REQS item qty
    page.item_calculate
  end
end

And  /^I enter a Pay Date$/ do
  on(PaymentRequestPage).pay_date.fit right_now[:date_w_slashes]
end


And /^I attach an Invoice Image to the (.*) document$/ do |document|
  document_object_for(document).notes_and_attachments_tab
                               .add note_text:      'Testing note text.',
                                    file:           'vendor_attachment_test.png',
                                    type:           'Invoice Image'
end

And /^I calculate PREQ$/ do
  on PaymentRequestPage do |page|
    page.expand_all
    page.calculate
  end
end


And /^I view the Purchase Order document via e-SHOP$/ do
  on ShopCatalogPage do |page|
    # TODO: When we do the split in the following comment, this block can be on EShopPage
    page.order_doc
    page.po_doc_search

    # TODO: This block should be split once we've defined a proper EShopDocSearchPage object
    page.search_doc_type.fit 'Purchase Orders'
    page.po_id.fit      @purchase_order_number
    page.date_range.fit 'Today'
    sleep 2
    page.go_button.click
  end
end

And /^the Document Status displayed '(\w+)'$/ do |doc_status|
  on ShopCatalogPage do |page|
    page.return_po_value(@purchase_order_number)
    page.doc_summary[1].text.should include  "Workflow  #{doc_status}"
  end
end

And /^the Delivery Instructions displayed equals what came from the PO$/ do
  on ShopCatalogPage do |page|
    page.doc_po_link
    page.doc_summary[1].text.should match /Note to Supplier.*#{@requisition.vendor_notes}/m
    page.doc_summary[3].text.should match /Delivery Instructions.*#{@requisition.delivery_instructions}/m
  end
end

And /^the Attachments for Supplier came from the PO$/ do
  on ShopCatalogPage do |page|
    page.attachments_link
    page.search_results.should exist
    page.search_results[1].text[0..16].should == @requisition.notes_and_attachments_tab.first.file[0..16] # Longer file names are cut and an ellipse is added to the end
  end
end

And  /^I select the Payment Request Positive Approval Required$/ do
  on(RequisitionPage).payment_request_positive_approval_required.set
end

Then /^I update the Tax Tab$/ do
  on PaymentRequestPage do |page|
    page.income_class_code.fit   'A - Honoraria, Prize'
    page.federal_tax_pct.fit     '0'
    page.state_tax_pct.fit       '0'
    page.postal_country_code.fit 'Canada'
  end
end

And /^I verified the GLPE on Payment Request page with the following:$/ do |table|
  on(PaymentRequestPage).expand_all
  glpe_entry = table.raw.flatten.each_slice(7).to_a
  glpe_entry.shift # skip header row
  glpe_entry.each do |line,account_number,object_code,balance_type,object_type,amount,dorc|
    on GeneralLedgerPendingEntryTab do |gtab|
      idx = gtab.glpe_tables.length - 1
      glpe_table = gtab.glpe_tables[idx]
      seq = line.to_i
      glpe_table[seq][3].text.should == account_number
      glpe_table[seq][5].text.should == object_code
      glpe_table[seq][9].text.should == balance_type
      glpe_table[seq][10].text.should == object_type
      glpe_table[seq][11].text.should == amount
      glpe_table[seq][12].text.strip.should == dorc
    end
  end
end

And /^I add an Attachment to the Requisition document$/ do
  pending 'THIS STEP DOES NOT USE NOTES AND ATTACHMENTS CORRECTLY.'
  on RequisitionPage do |page|
    page.note_text.fit random_alphanums(40, 'AFT-NoteText')
    page.send_to_vendor.fit 'Yes'
    page.attach_notes_file.set($file_folder+@requisition.attachment_file_name) # FIXME: This doesn't use Notes and Attachments correctly at all

    page.add_note
    page.attach_notes_file_1.should exist #verify that note is indeed added
  end
end

And /^I enter Delivery Instructions and Notes to Vendor$/ do
  on RequisitionPage do |page|
    page.vendor_notes.fit random_alphanums(40, 'AFT-ToVendorNote')
    page.delivery_instructions.fit random_alphanums(40, 'AFT-DelvInst')
    @requisition.delivery_instructions = page.delivery_instructions.value
    @requisition.vendor_notes = page.vendor_notes.value
  end
end

When /^I visit the "(.*)" page$/  do   |go_to_page|
  on(MainPage).send(go_to_page.downcase.gsub(' ', '_').gsub('-', '_'))
end

And /^I enter Payment Information for recurring payment type (.*)$/ do |recurring_payment_type|
  unless recurring_payment_type.empty?
    on RequisitionPage do |page|
      page.recurring_payment_type.fit recurring_payment_type
      page.payment_from_date.fit      right_now[:date_w_slashes]
      page.payment_to_date.fit        next_year[:date_w_slashes]
    end
  end
end

  Then /^the Payment Request document's GLPE tab shows the Requisition document submissions$/ do
    on PaymentRequestPage do |page|
      page.show_glpe

      page.glpe_results_table.text.include? @requisition.items.first.accounting_lines.first.object_code
      page.glpe_results_table.text.include? @requisition.items.first.accounting_lines.first.account_number
      # credit object code should be 3110 (depends on parm)
    end
  end

And /^I Complete Selecting an External Vendor$/ do
  on(PurchaseOrderPage).vendor_search
  on VendorLookupPage do |vlookup|
    vendor_number = '27015-0' # TODO : this vendor number should be from a parameter
    vlookup.vendor_number.fit vendor_number
    vlookup.search
    vlookup.return_value(vendor_number)
  end
end

# started QA-853 work
And /^I create an empty Requisition document$/  do
  @requisition = create RequisitionObject
end

Then /^I switch to the user with the next Pending Action in the Route Log to approve (.*) document to Final$/ do |document|

  # TODO : Should we collect the app doc status to make sure that this process did go thru all the route nodes ?
  x = 0 # in case something wrong , limit to 10
  @base_org_review_level = 0
  @org_review_users = Array.new
  @commodity_review_users = Array.new
  @fo_users = Array.new
  while true && x < 10
    new_user = ''
    on(page_class_for(document)) do |page|
      page.expand_all
      if (page.document_status != 'FINAL')
        (0..page.pnd_act_req_table.rows.length - 3).each do |i|
          idx = i + 1
          if page.pnd_act_req_table[idx][1].text.include?('APPROVE')
            if (!page.pnd_act_req_table[idx][2].text.include?('Multiple'))
              page.pnd_act_req_table[idx][2].links[0].click
              page.use_new_tab
              new_user = page.new_user
            else
              # for Multiple
              page.show_multiple
              page.multiple_link_first_approver
              page.use_new_tab
              new_user = page.new_user
            end
            page.close_children
            break
          end
        end
      else
        break
      end
    end

    if new_user != ''
      step "I am logged in as \"#{new_user}\""
      step "I view the #{document} document on my action list"
      if (document == 'Payment Request')
        if (on(page_class_for(document)).app_doc_status == 'Awaiting Tax Approval')
          step  "I update the Tax Tab"
          step  "I calculate PREQ"
        else
          if (on(page_class_for(document)).app_doc_status == 'Awaiting Treasury Manager Approval')
            #TODO : wait till Alternate PM is implemented
          end
        end
      end
      if (on(page_class_for(document)).app_doc_status == 'Awaiting Base Org Review' || on(page_class_for(document)).app_doc_status == 'Awaiting Chart Approval')
        @base_org_review_level += 1
        @org_review_users.push(new_user)
      else
        if (on(page_class_for(document)).app_doc_status == 'Awaiting Commodity Review' || on(page_class_for(document)).app_doc_status == 'Awaiting Commodity Code Approval')
          @commodity_review_users.push(new_user)
        else
          if (on(page_class_for(document)).app_doc_status == 'Awaiting Fiscal Officer')
             @fo_users.push(new_user)
          end
        end
      end
      step "I approve the #{document} document"
      step "the #{document} document goes to one of the following statuses:", table(%{
        | ENROUTE   |
        | FINAL     |
      })
    end

    if on(page_class_for(document)).document_status == 'FINAL'
        break
    end
    x += 1
  end

  if @org_review_routing_check
    step "the #{document} document routes to the correct individuals based on the org review levels"
  else
    if @commodity_review_routing_check
      step "I validate Commodity Review Routing for #{document} document"
    end
  end

end

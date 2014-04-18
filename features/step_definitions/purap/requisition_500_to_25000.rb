And /^I create the Requisition document with:$/  do |table|
  updates = table.rows_hash
  @requisition = create RequisitionObject, description: 'AFT',
                        payment_request_positive_approval_required: updates['payment request'],
                        vendor_number:        updates['vendor number'],
                        item_quantity:        updates['item quanity'],
                        item_unit_cost:       updates['item cost'],
                        item_commodity_code:  updates['item commodity code'],
                        item_account_number:  updates['account number'],
                        item_object_code:     updates['object code'],
                        item_percent:         updates['percent']

end

And /^I calculate my Requisition document$/ do
  on(RequisitionPage).calculate
  #need to let calculate process, no other way to verify calculate is completed
  sleep 3
end

And /^I view the Requisition document on my action list$/ do
    visit(MainPage).action_list
  on ActionList do |page|
    #sort the date
    page.sort_results_by('Date Created')
    page.result_item(@requisition.document_id).wait_until_present
    page.open_item(@requisition.document_id)
  end
  on RequisitionPage do |page|
    @requisition_id = page.requisition_id
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

And /^The View Related Documents Tab PO Status displays$/ do
    on PurchaseOrderPage do |page|
      page.show_related_documents
      page.show_purchase_order
      @purchase_order_id = page.purchase_order_number
      page.open_purchase_order_number(@purchase_order_id)

      puts 'PO Num'
      puts @purchase_order_id
      page.description.wait_until_present
    end
end

And /^I Complete Selecting a Vendor$/ do
  @requisition.add_vendor_to_req('27015-0')
  #pull common vendor from service
end

And /^I enter a Vendor Choice of '(.*)'$/ do  |choice|
  on PurchaseOrderPage do |page|
    page.vendor_choice.fit choice
  end
end

And /^I calculate and verify the GLPE tab$/ do
  on PurchaseOrderPage do |page|
    page.calculate
    page.show_glpe

    page.glpe_results_table.text.include? @requisition.item_object_code
    page.glpe_results_table.text.include? @requisition.item_account_number
    # credit object code should be 3110 (depends on parm)

  end
end

Then /^In Pending Action Requests an FYI is sent to FO and Initiator$/ do
  on PurchaseOrderPage do |page|
    page.headerinfo_table.wait_until_present
    page.expand_all
  page.pending_action_annotation_1.include? 'Fiscal Officer'
  page.pending_action_annotation_2.include? 'Initiator'
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
  on PurchaseOrderPage do |page|
    #this is a different field from the document status field
    page.po_doc_status.should == po_doc_status
  end
end

And /^The Requisition status is '(.*)'$/ do |doc_status|
  on RequisitionPage do |page|
    sleep 5
    page.reload unless page.reload_button.nil?
    page.document_status == doc_status
  end
end

And(/^I select the purchase order '(\d+)' with the doc id '(\d+)'$/) do |req_num, doc_id|
  on DocumentSearch do |page|
    page.requisition_number.set req_num.to_s
    page.search
    page.result_item(doc_id.to_s).when_present.click
    sleep 5
  end
end
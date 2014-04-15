#When /^I visit the "(.*)" page$/  do   |go_to_page|
#  go_to_pages = go_to_page.downcase.gsub!(' ', '_')
#  on(MainPage).send(go_to_pages)
#end
#
#And /^I create the Requisition document with:$/  do |table|
#  updates = table.rows_hash
#  @requisition = create RequisitionObject, description: 'HELLO',
#                        payment_request_positive_approval_required: updates['payment request'],
#                        vendor_number:        updates['vendor number'],
#                        item_quantity:        updates['item quanity'],
#                        item_unit_cost:       updates['item cost'],
#                        item_commodity_code:  updates['item commodity code'],
#                        item_account_number:  updates['account number'],
#                        item_object_code:     updates['object code'],
#                        item_percent:         updates['percent']
#
#end
#
#And /^I calculate my Requisition document$/ do
#  on(RequisitionPage).calculate
#  #need to let calculate process, no other way to verify calculate is completed
#  sleep 3
#end
#
#And /^I view the Requisition document on my action list$/ do
#    visit(MainPage).action_list
#  on ActionList do |page|
#    #sort the date
#    page.sort_results_by('Date Created')
#    page.result_item(@requisition.document_id).wait_until_present
#    page.open_item(@requisition.document_id)
#  end
#
#  on RequisitionPage do |page|
#    @requisition_number = page.requisition_number
#    puts @requisition_number
#  end
#end

  Given /^I am logged in as a Purchasing Processor$/ do
    visit(BackdoorLoginPage).login_as('ml284') #TODO get from role service
  end

And /^I (submit|close|cancel) a Contract Manager Assignment of '(\d+)' for the Requisition$/ do |btn, contract_manager_number|
   visit(MainPage).contract_manager_assignment
   on ContractManagerAssignmentPage do |page|
    page.set_contract_manager(@requisition_number, contract_manager_number)
    page.send(btn)

    sleep 10 # need to wait a little
   end
end

And /^I am logged in as a Contract Manager$/ do
  visit(BackdoorLoginPage).login_as('mss7') #TODO get from role service
  # pending # express the regexp above with the code you wish you had
end


And /^I retrieve the Requisition$/ do
  # temp
  #@requisition_number = '325401'
  #@document_id = '5291056'
  puts 'req, doc# ',@requisition_number,@document_id
  visit(MainPage).requisitions  #remember "S" is for search
   on DocumentSearch do |page|
     page.document_type.set 'REQS'
     page.requisition_number.fit @requisition_number
     page.search

     page.open_item(@document_id)
   end
end

And /^The View Related Documents Tab PO Status displays$/ do
    on RequisitionPage do |page|
      page.show_related_documents
      page.show_purchase_order
      @purchase_order_number = page.purchase_order_number
      page.purchase_order_number.should_not include '*****' # unmasked
      page.purchase_order_number_link

      sleep 15
      @purchase_order = create PurchaseOrderObject
    end


end

And /^the Purchase Order Number is unmasked$/ do
  on (PurchaseOrderPage) do |page|
    page.po_number.should_not include '****'
  end
end

And /^I Select the PO$/ do
  pending # express the regexp above with the code you wish you had
end

And /^I Complete Selecting Vendor (.*)$/ do |vendor_number|
  on (PurchaseOrderPage) do |page|
    page.vendor_search
    on VendorLookupPage do |vlookup|
      vlookup.vendor_number.fit vendor_number
      vlookup.search
      vlookup.return_value(vendor_number)
    end
  end

end


And /^I enter a Vendor Choice$/ do
  on (PurchaseOrderPage) do |page|
    page.vendor_choice.fit 'Lowest Price'
  end
end

And /^I calculate and verify the GLPE with amount (.*)$/ do |amount|
  on (PurchaseOrderPage) do |page|
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


Then /^In Pending Action Requests an FYI is sent to FO and Initiator$/ do
  on(KFSBasePage) do |page|
    page.expand_all

    annotation_col = page.pnd_act_req_table.keyed_column_index(:annotation)
    action_col = page.pnd_act_req_table.keyed_column_index(:action)
    fo_row = page.pnd_act_req_table
    .column(annotation_col)
    .index{ |c| c.exists? && c.visible? && c.text.match(/Fiscal Officer/) }
    initiator_row = page.pnd_act_req_table
    .column(annotation_col)
    .index{ |c| c.exists? && c.visible? && c.text.match(/Notification of Requisition Initiator/) }
    page.pnd_act_req_table[fo_row][action_col].text.should include "IN ACTION LIST\nFYI"
    page.pnd_act_req_table[initiator_row][action_col].text.should include "IN ACTION LIST\nFYI"
  end
end


And(/^The PO eDoc Status is$/) do
  pending # express the regexp above with the code you wish you had
end


And(/^The Purchase Order Doc Status is (\w+)/) do |doc_status|
  on (PurchaseOrderPage) do |page|
    page.app_doc_status.should == doc_status
  end
end





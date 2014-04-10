When /^I visit the "(.*)" page$/  do   |go_to_page|
  go_to_pages = go_to_page.downcase.gsub!(' ', '_')
  on(MainPage).send(go_to_pages)
end

And /^I create the Requisition document with:$/  do |table|
  updates = table.rows_hash
  @requisition = create RequisitionObject, description: 'HELLO',
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
    @requisition_number = page.requisition_number
    puts @requisition_number
  end
end

  Given /^I am logged in as a Purchasing Processor$/ do
    visit(BackdoorLoginPage).login_as('ml284') #TODO get from role service
  end

And /^I (submit|close|cancel) a Contract Manager Assignment of '(\d+)' for the Requisition$/ do |btn, contract_manager_number|
   visit(MainPage).contract_manager_assignment
   on ContractManagerAssignmentPage do |page|
    page.set_contract_manager(@requisition_number, contract_manager_number)
    page.send(btn)

    puts @requisition_number
    puts @requisition_number
    puts @requisition_number

   end
end

And /^I am logged in as a Contract Manager$/ do
  visit(BackdoorLoginPage).login_as('mss7') #TODO get from role service
  # pending # express the regexp above with the code you wish you had
end


And /^I retrieve the Requisition\$/ do
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
      @purchase_order = page.purchase_order_number

      page.purchase_order_number_link
      puts @purchase_order

      sleep 15
    end


end

And /^I Select the PO$/ do
  pending # express the regexp above with the code you wish you had
end

And /^I Complete Selecting a Vendor$/ do
  pending # express the regexp above with the code you wish you had
end


And /^I enter a Vendor Choice$/ do
  pending # express the regexp above with the code you wish you had
end

And /^I calculate and verify the GLPE$/ do
  pending # express the regexp above with the code you wish you had
end


And /^I submit the PO eDoc Status is$/ do
  pending # express the regexp above with the code you wish you had
end


Then /^In Pending Action Requests an FYI is sent to FO and Initiator$/ do
  pending # express the regexp above with the code you wish you had
end


And(/^The PO eDoc Status is$/) do
  pending # express the regexp above with the code you wish you had
end


And(/^The Purchase Order Doc Status equals$/) do
  pending # express the regexp above with the code you wish you had
end





When /^I visit the "(.*)" page$/  do   |go_to_page|
  go_to_pages = go_to_page.downcase.gsub!(' ', '_')
  go_to_pages = go_to_page.downcase.gsub!('-', '_')
  on(MainPage).send(go_to_pages)
end

And /^I create the Requisition document with:$/  do |table|
  updates = table.rows_hash
  @requisition = create RequisitionObject, description: random_alphanums(40, 'AFT'),
                        payment_request_positive_approval_required: updates['payment request'],
                        vendor_number:        updates['vendor number'],
                        item_quantity:        updates['item quanity'],
                        item_unit_cost:       updates['item cost'],
                        item_commodity_code:  updates['item commodity code'],
                        item_account_number:  updates['account number'],
                        item_catalog_number:  updates['item catalog number'],
                        item_description:     updates['item description'].nil? ? random_alphanums(15, 'AFT') : updates['item description'],
                        item_object_code:     updates['object code'],
                        item_percent:         updates['percent']
  @document_id = @requisition.document_id

end

And /^I calculate my Requisition document$/ do
  on(RequisitionPage).calculate
  #need to let calculate process, no other way to verify calculate is completed
  sleep 3
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
      @requisition_number = page.requisition_number
    end
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

And /^I add an Attachment to the Requisition document$/ do
  on RequisitionPage do |page|
    page.note_text.fit random_alphanums(40, 'AFT-NoteText')
    page.send_to_vendor.fit 'Yes'
    page.attach_notes_file.set($file_folder+@requisition.attachment_file_name)
    page.add_note
    page.attach_notes_file_1.should exist #verify that note is indeed added

  end
end

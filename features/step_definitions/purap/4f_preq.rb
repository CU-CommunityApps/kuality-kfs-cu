When /^I visit the "(.*)" page$/  do   |go_to_page|
  go_to_pages = go_to_page.downcase.gsub!(' ', '_')
  on(MainPage).send(go_to_pages)
end

And /^I view the Requisition document on my action list$/ do
  visit(MainPage).action_list
  on ActionList do |page|
    #sort the date
    # if previous user already clicked this sort, then action list for next user will be sorted with 'Date created'.  So, add this 'unless' check
    page.sort_results_by('Date Created') unless page.result_item(@requisition.document_id).exists?
    page.result_item(@requisition.document_id).wait_until_present
    page.open_item(@requisition.document_id)
  end
  @requisition_id = on(RequisitionPage).requisition_id
end

And /^I enter Delivery Instructions and Notes to Vendor$/ do
  on RequisitionPage do |page|
    page.vendor_notes.fit random_alphanums(40, 'AFT-ToVendorNote')
    page.delivery_instructions.fit random_alphanums(40, 'AFT-DelvInst')
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

And /^I enter Payment Information for recurring payment type (.*)$/ do |recurring_payment_type|
  puts 'recur type',recurring_payment_type
  unless recurring_payment_type.empty?
    on RequisitionPage do |page|
      page.recurring_payment_type.fit recurring_payment_type
      page.payment_from_date.fit right_now[:date_w_slashes]
      page.payment_to_date.fit next_year[:date_w_slashes]
    end
  end
end


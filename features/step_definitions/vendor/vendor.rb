When /^I start an empty Vendor document$/ do
  @vendor = create VendorObject
end

And /^I add an Attachment to the Vendor document$/ do
  on VendorPage do |page|
    page.note_text.fit @vendor.note_text
    page.attach_notes_file.set($file_folder+@vendor.attachment_file_name)
    page.add_note
  end
end

Then /^the Vendor document should be in my action list$/ do
 visit(MainPage).action_list

  on ActionList do |page|
    page.sort_results_by('Id')
    page.sort_results_by('Id')
    page.result_item(@vendor.document_id).should exist
  end
end
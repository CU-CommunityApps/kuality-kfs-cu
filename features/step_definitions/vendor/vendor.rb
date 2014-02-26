When /^I start an empty Vendor document$/ do
  @vendor = create VendorObject
end

And /^I add an Attachment to the Vendor document$/ do
  on VendorPage do |page|
    page.note_text.fit @vendor.note_text
    page.attach_notes_file.fit ($file_folder+@vendor.attachment_file_name)
    page.add_note
  end
end

Then /^the Vendor document should be in my action list$/ do
  sleep 5
  on(ActionList).view_as(@user_id)

  on(ActionList).last if on(ActionList).last_link.exists?
  on(ActionList).result_item(@vendor.document_id).should exist
end
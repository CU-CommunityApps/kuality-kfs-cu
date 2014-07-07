Then /^the Notes and Attachment Tab says "(.*)"$/ do |message|
  on DistributionOfIncomeAndExpensePage do |page|
    page.expand_all
    page.notes_tab.text.should include message
  end
end

And /^I enter text into the Note Text field of the (.*) document$/ do |document|
  new_text = 'Testing note text.'
  on(page_class_for(document)).note_text.fit new_text
  # document_object_for(document).notes_and_attachments_tab.add note_text: new_text, immediate_add: false
end

And /^I manually add a file attachment to the Notes and Attachment Tab of the (.*) document$/ do |document|
  pending 'Not ready for primetime!'
  filename = 'vendor_attachment_test.png'
  on(page_class_for(document)).attach_notes_file.set($file_folder+filename)
  on(page_class_for(document)).attach_notes_file.value.should == filename
  pending
  @browser.send_keys :tab
  on(page_class_for(document)).attach_notes_file.value.should == filename
  pending
end

And /^I add a file attachment to the Notes and Attachment Tab of the (.*) document$/ do |document|
  filename = 'vendor_attachment_test.png'
  document_object_for(document).notes_and_attachments_tab
                               .add file:          'vendor_attachment_test.png',
                                    immediate_add: false
  on(page_class_for(document)).attach_notes_file.value.include?(filename).should be_true
end

And /^I add note '(.*)' to the (.*) document$/ do |note_text, document|
  on(page_class_for(document)).note_text.fit note_text
  document_object_for(document).notes_and_attachments_tab.add note_text: note_text, immediate_add: true
end

When /^I attach a file to the Notes and Attachments Tab line of the (.*) document$/ do |document|
  document_object_for(document).notes_and_attachments_tab
                               .first
                               .attach_file 'vendor_attachment_test.png'
end

When /^I enter a Valid Notification Recipient for the (.*) document$/ do |document|
  case document
    when ''
      # For now, we'll map them all to the same thing
    else
      recipient = 'ccs1'
      on(page_class_for(document)).notification_recipient.fit recipient
      document_object_for(document).notes_and_attachments_tab
                                   .first
                                   .notification_recipient = recipient
  end
end

And /^I add an attachment to the (.*) document$/ do |document|
  if on(KFSBasePage).send_to_vendor.exists?
    document_object_for(document).notes_and_attachments_tab
                                 .add note_text:      'Testing note text.',
                                      file:           'vendor_attachment_test.png',
                                      send_to_vendor: 'Yes'
  else
    document_object_for(document).notes_and_attachments_tab
                                 .add note_text: 'Testing note text.',
                                      file:      'vendor_attachment_test.png'
  end
end

And /^I note how many attachments the (.*) document has already$/ do |document|
  @attachments_count = on(page_class_for(document)).notes_and_attachments_count
end

And /^the (.*) document's Notes and Attachments Tab displays the added attachment$/ do |document|
  on page_class_for(document) do |page|
    page.notes_and_attachments_count.should == @attachments_count + 1

    i = page.notes_and_attachments_count - 1
    last_attachment = document_object_for(document).notes_and_attachments_tab.last

    file_matches = page.submitted_attached_file_name(i).match(/#{last_attachment.file}/m) unless (last_attachment.file.nil? || last_attachment.file.empty?)
    note_matches = page.submitted_note_text(i).match(last_attachment.note_text) unless (last_attachment.note_text.nil? || last_attachment.note_text.empty?)
    (!file_matches.nil? && !note_matches.nil?).true?.should
  end
end

And /^the (.*) document's Notes and Attachments Tab has (\d+) more attachments? than before$/ do |document, count|
  on(page_class_for(document)).notes_and_attachments_count.should == @attachments_count + count.to_i
end

And /^the (.*) document's Notes Tab displays the added attachment$/ do |document|
  on page_class_for(document) do |page|
    page.ro_notes_count.should == @attachments_count + 1

    i = page.ro_notes_count - 1
    last_attachment = document_object_for(document).notes_and_attachments_tab.last

    # There's no way to actually compare the attached file, unfortunately, without actually downloading it. This should be sufficient for now, though.:
    file_matches = page.ro_note_has_attached_file?(i) unless (last_attachment.file.nil? || last_attachment.file.empty?)
    note_matches = page.ro_note_note_text(i).match(last_attachment.note_text) unless (last_attachment.note_text.nil? || last_attachment.note_text.empty?)
    (!file_matches.nil? && !note_matches.nil?).true?.should
  end
end

And /^I expand the Notes and Attachments tab$/ do
  on(KFSBasePage).show_notes_and_attachments
end

When /^I add the Notes and Attachment line to the (.*) document$/ do |document|
  on KFSBasePage do |p|
    # We're assuming we've already added the appropriate fields. This should simply make the object.
    # We're also assuming there are not lines added so far
    document_object_for(document).notes_and_attachments_tab
                                 .add note_text: p.note_text,
                                      immediate_attach: false,
                                      immediate_add: false,
                                      immediate_fyi: false
    document_object_for(document).notes_and_attachments_tab.first.file = p.attach_notes_file.value
    p.add_note
  end
end
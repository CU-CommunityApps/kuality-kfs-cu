Then /^the Notes and Attachment Tab says "(.*)"$/ do |message|
  on DistributionOfIncomeAndExpensePage do |page|
    page.expand_all
    page.notes_tab.text.should include message
  end
end

And /^I enter text into the Note Text field of the (.*) document$/ do |document|
  new_text = 'Testing note text.'
  on(KFSBasePage).note_text.fit new_text
  document_object_for(document).notes_and_attachments_tab.add note_text: new_text, immediate_add: false
end

And /^I add note '(.*)' to the (.*) document$/ do |note_text, document|
  on(KFSBasePage).note_text.fit note_text
  document_object_for(document).notes_and_attachments_tab.add note_text: note_text, immediate_add: true
end

When /^I attach a file to the Notes and Attachments Tab line of the (.*) document$/ do |document|
  document_object_for(document).notes_and_attachments_tab
                               .first
                               .attach_file 'vendor_attachment_test.png'
end

When /^I enter a a Valid Notification Recipient for the (.*) document$/ do |document|
  case document
    when ''
      # For now, we'll map them all to the same thing
    else
      recipient = 'ccs1'
      on(KFSBasePage).notification_recipient.fit recipient
      document_object_for(document).notes_and_attachments_tab
                                   .first
                                   .notification_recipient = recipient
  end
end

And /^I add an attachment to the (.*) document$/ do |document|
  document_object_for(document).notes_and_attachments_tab
                               .add note_text: 'Testing note text.',
                                    file:      'vendor_attachment_test.png'
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

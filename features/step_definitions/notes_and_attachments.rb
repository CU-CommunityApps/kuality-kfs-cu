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

And /^the file is attached to the (.*) document$/ do |document|
  #pending document_object_for(document).notes_and_attachments_tab.first.file
  #document_object_for(document).notes_and_attachments_tab.first.file
  warn "Step 'the file is attached to the #{document} document' is not actually complete yet!"
end
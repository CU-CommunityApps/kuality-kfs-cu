Then /^an error should say "(.*)"$/ do |error|
  $current_page.errors.should include error
end

Then(/^The document should have no errors$/) do
  $current_page.errors.should == []
end

Then(/^The document should save successfully$/) do
  $current_page.left_errmsg_text.should include 'Document was successfully saved.'
  $current_page.document_status.should == 'SAVED'
end
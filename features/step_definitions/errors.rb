Then /^an error should say (.*)$/ do |error|
  errors = {'at least one principal investigator is required' => 'There is no Principal Investigator selected. Please enter a Principal Investigator.',
            'to select a valid unit' => 'Please select a valid Unit.',
            'a key person role is required' => 'Key Person Role is a required field.',
            'the credit split is not a valid percentage' => 'Credit Split is not a valid percentage.',
            'only one PI is allowed' => 'Only one proposal role of Principal Investigator is allowed.'
  }
  $current_page.errors.should include errors[error]
end

Then /^the document should have no errors$/ do
  $current_page.errors.should == []
end

Then /^The document should save successfully$/ do
  $current_page.left_errmsg_text.should include 'Document was successfully saved.'
  $current_page.document_status.should == 'SAVED'
end

Then /^I should get an error saying "([^"]*)"$/ do |error_msg|
  $current_page.errors.should include error_msg
end

Then /^I should get these error messages:$/ do |error_msgs|
  $current_page.errors.should include *(error_msgs.raw.flatten)
end

Then /^I should get an error that starts with "([^"]*)"$/ do |error_msg|
  $current_page.errors.any? { |s| s.include?(error_msg) }
end

And /^I should get an Authorization Exception Report error$/ do
  $current_page.frm.div(id: 'headerarea').h1.text.rstrip.should == 'Authorization Exception Report'
end

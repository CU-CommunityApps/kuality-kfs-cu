Then /^an error should say (.*)$/ do |error|
  errors = {'at least one principal investigator is required' => 'There is no Principal Investigator selected. Please enter a Principal Investigator.',
            'to select a valid unit' => 'Please select a valid Unit.',
            'a key person role is required' => 'Key Person Role is a required field.',
            'the credit split is not a valid percentage' => 'Credit Split is not a valid percentage.',
            'only one PI is allowed' => 'Only one proposal role of Principal Investigator is allowed.'
  }
  $current_page.errors.should include errors[error]
end

Then /^I should get an error saying "(.*)"$/ do |error_msg|
  $current_page.errors.should include error_msg
end

Then /^The document should have no errors$/ do
  $current_page.errors.should == []
end

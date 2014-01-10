  Then /^an error should say (.*)$/ do |error|
    $current_page.errors.should include error
  end

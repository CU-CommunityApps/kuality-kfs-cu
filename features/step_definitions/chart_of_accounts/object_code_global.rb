And /^I create an Object Code Global$/ do
  @object_code_global = create ObjectCodeGlobalObject
end

And /^I enter an invalid CG Reporting Code of (.*)$/ do |invalid_code|
  on ObjectCodeGlobalPage do |page|
    page.cg_reporting_code.set invalid_code
  end
end

And /^I Submit the Object Code Global document$/ do
  on ObjectCodeGlobalPage do |page|
    page.submit
  end
end

Then(/^Object Code Global should show an error that says (.*?)$/) do |error|
  on(ObjectCodeGlobalPage).errors.should include error
end

Then /^The Object Code Global document status should be PROCESSED$/ do
  on DocumentSearchPage do |page|
    page.doc_search
    page.search
    page.result_item('PROCESSED').should exist
    page.result_item('FINAL').should exist
  end
end



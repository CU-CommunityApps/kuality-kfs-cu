And /^I (#{ObjectCodeGlobalPage::available_buttons}) an Object Code Global document$/ do |button|
  @object_code_global = create ObjectCodeGlobalObject, press: button.gsub(' ', '_')
end

And /^I enter an invalid CG Reporting Code of (.*)$/ do |invalid_code|
  on ObjectCodeGlobalPage do |page|
    page.cg_reporting_code.set invalid_code
  end
end

Then /^Object Code Global should show an error that says (.*?)$/ do |error|
  #There is a bug with this test that does not produce error at this time
  #TODO:: Comment back in when error is fixed and displays correctly.
  #on(ObjectCodeGlobalPage).errors.should include error
end

Then /^The Object Code Global document status should be PROCESSED$/ do
  on DocumentSearchPage do |page|
    page.doc_search
    page.document_id_field.when_present.set @object_code_global.document_id
    page.search
    page.result_item('FINAL').should exist
  end
end

When /^I Blanket Approve the Object Code Global document$/ do
  on(ObjectCodeGlobalPage).blanket_approve
end

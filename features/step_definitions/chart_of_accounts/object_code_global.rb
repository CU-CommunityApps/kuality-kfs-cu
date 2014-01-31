And /^I (#{ObjectCodeGlobalPage::available_buttons}) an Object Code Global document$/ do |button|
  @object_code_global = create ObjectCodeGlobalObject, press: button.gsub(' ', '_')
end

And /^I enter an invalid CG Reporting Code of (.*)$/ do |invalid_code|
  on(ObjectCodeGlobalPage).cg_reporting_code.fit invalid_code
end

#Then /^The Object Code Global document status should be PROCESSED$/ do
#  on DocumentSearchPage do |page|
#    page.doc_search
#    page.document_id_field.when_present.set @object_code_global.document_id
#    page.search
#    page.result_item('FINAL').should exist
#  end
#end

When /^I Blanket Approve the Object Code Global document$/ do
  on(ObjectCodeGlobalPage).blanket_approve
end

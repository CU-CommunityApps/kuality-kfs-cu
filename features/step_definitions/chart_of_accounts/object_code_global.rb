And /^I create an Object Code Global$/ do
  @object_code_global = create ObjectCodeGlobalObject
end

And /^I enter an invalid CG Reporting Code of (.*)$/ do |invalid_code|
  on ObjectCodeGlobalPage do |page|
    page.cg_reporting_code.set invalid_code
  end
end

Then(/^Object Code Global should show an error that says "(.*)”$/) do |error|
   on(ObjectCodeGlobalPage).errors.should include error
end


Then(/^Object Code Global should show an error that says “CG Reporting Code ZZZZ for Chart Code IT does not exist\.”$/) do |error|
  on(ObjectCodeGlobalPage).errors.should include error

end

Then /^The Object Code Global document status should be PROCESSED$/ do
  on DocumentSearch do |page|
    page.doc_search
    @time = Time.new
    page.document_id.set @time.strftime("%m/%d/%Y")
    page.search

   #status in row should be PROCESSED


  pending # express the regexp above with the code you wish you had
  end
end



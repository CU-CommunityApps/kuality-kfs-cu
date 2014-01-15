And /^I create an Object Code document$/ do
  @object_code = create ObjectCodeObject
end

When /^I Blanket Approve the document$/ do
  on(ObjectCodePage).blanket_approve
end

Then /^I should see the Object Code document in the object code search results$/ do
  on(MainPage).object_code
  on ObjectCodeLookupPage do |page|
    page.object_code.fit @object_code.object_code
    page.search

    page.find_item_in_table(@object_code.object_code.upcase).should exist
  end
end

And /^I edit an Object Code document with object code (.*)$/ do |the_object_code|
  @object_code = make ObjectCodeObject

  on(MainPage).object_code
  on ObjectCodeLookupPage do |page|
    page.object_code.set the_object_code
    page.search
    page.edit_item(the_object_code)
  end
end

And /^I edit an Object Code document$/ do
  @object_code = make ObjectCodeObject

  on(MainPage).object_code
  on ObjectCodeLookupPage do |page|
    page.search
    page.edit_random
  end
  on ObjectCodePage do |page|
    page.description.set random_alphanums(40, 'AFT')
    @object_code.document_id = page.document_id
  end

end

And /^I enter invalid CG Reporting Code of (.*)$/ do |the_reporting_code|
  on ObjectCodePage do |page|
    page.description.set @object_code.description
    page.cg_reporting_code.set the_reporting_code
  end
end

Then /^The object code should show an error that says "(.*?)"$/ do |error|
  on(ObjectCodePage).errors.should include error
end

When /^I blanket approve the Object Code document$/ do
  @object_code.blanket_approve
  sleep(10)
end

Then /^the Object Code Document goes to (.*)/ do |doc_status|
  @object_code.view
  on(ObjectCodePage).document_status.should == doc_status
end


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
    page.result_item(@object_code.object_code).should exist
  end
end

And /^I enter invalid CG Reporting Code$/ do
  on ObjectCodePage do |page|
    page.cg_reporting_code.set 'FA!L!'
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

And /^I enter invalid CG Reporting Code of (.*)$/ do |the_reporting_code|
  on ObjectCodePage do |page|
    page.description.set @object_code.description
    page.cg_reporting_code.set the_reporting_code
  end
end

Then /^The object code should show an error that says “(.*?)”$/ do |error|
  on(ObjectCodePage).errors.should include error
end

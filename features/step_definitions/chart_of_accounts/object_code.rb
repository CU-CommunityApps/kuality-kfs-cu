And /^I create an Object Code document$/ do
  @object_code = create ObjectCodeObject
end

When /^I Blanket Approve the document$/ do
  @object_code.blanket_approve
end

Then /^I should see the Object Code document in the object code search results$/ do
  visit(MainPage).object_code

  on ObjectCodeLookupPage do |page|
    page.object_code.fit @object_code.object_code
    page.search
    page.find_item_in_table(@object_code.object_code.upcase).should exist
  end
end

And /^I edit an Object Code document with object code (.*)$/ do |the_object_code|
  @object_code = make ObjectCodeObject, object_code: the_object_code

  visit(MainPage).object_code

  on ObjectCodeLookupPage do |page|
    page.object_code.set @object_code.object_code
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

Then /^The object code should show an error that says "(.*?)"$/ do |error|
  on(ObjectCodePage).errors.should include error
end

And(/^I enter a valid Reports to Object Code$/) do
  on ObjectCodePage do |page|
    page.search_reports_to_object_code
  end

  on ObjectCodeLookupPage do |page|
    page.object_code.set ''
    page.search
    page.return_random
  end

  on ObjectCodePage do |page|
    @object_code.reports_to_object_code = page.reports_to_object_code.value
    page.description.set @object_code.description
  end

end

And(/^I Submit the Object Code document$/) do
  @object_code.submit
end

When(/^I Lookup the Object Code (.*)$/) do |the_object_code|
  visit(MainPage).object_code

  on ObjectCodeLookupPage do |page|
    page.object_code.set the_object_code
    page.search
    page.edit_item(@object_code.object_code)
  end
end

Then(/^The Lookup should display the Reports to Object Code$/) do
  on ObjectCodePage do |page|
    page.reports_to_object_code.value.should == @object_code.reports_to_object_code
  end
end


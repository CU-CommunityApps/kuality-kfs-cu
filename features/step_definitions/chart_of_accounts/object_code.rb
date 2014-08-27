Then /^I should see the Object Code document in the object code search results$/ do
  on(MainPage).object_code
  on ObjectCodeLookupPage do |page|
    page.object_code.fit @object_code.object_code
    page.search
    if page.frm.divs(id: 'lookup')[0].parent.text.include?('No values match this search.')
      # Double-check, for timing issues.
      sleep 5
      page.search
    end
    page.find_item_in_table(@object_code.object_code.upcase).should exist
  end
end

And /^I edit an Object Code document with object code (.*)$/ do |the_object_code|
  @object_code = make ObjectCodeObject, object_code: the_object_code

  visit(MainPage).object_code
  on ObjectCodeLookupPage do |page|
    page.object_code.fit      @object_code.object_code
    page.chart_code.fit       @object_code.new_chart_code
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

And /^I enter a valid Reports to Object Code$/ do
  on ObjectCodePage do |page|
    page.search_reports_to_object_code
  end

  on ObjectCodeLookupPage do |page|
    page.object_code.set ''
    page.search
    page.return_random
  end

  on ObjectCodePage do |page|
    page.description.set @object_code.description
  end

end

When /^I Lookup the Object Code (.*)$/ do |the_object_code|
  visit(MainPage).object_code

  on ObjectCodeLookupPage do |page|
    page.object_code.set the_object_code
    page.search
    page.edit_item(@object_code.object_code)
  end
end

Then /^The Lookup should display the Reports to Object Code$/ do
  on ObjectCodePage do |page|
    page.reports_to_object_code.value.should == @object_code.reports_to_object_code
  end
end

And /^I update the Financial Object Code Description/ do
  on(ObjectCodePage).financial_object_code_description.set random_alphanums(60, 'AFT')
end


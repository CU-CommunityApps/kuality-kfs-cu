When /^I create a blank Federal Funded Code$/ do
  @federal_funded_code = create FederalFundedCodeObject, description: nil, federal_funded_code: nil, federal_funded_name: nil, press: :submit
end

And /^I enter a description of '(.*)'$/ do |descrpt|
  on(FederalFundedCodePage).description.fit descrpt
end

Then /^I should see '(.*)' message displayed$/ do  |msg|
  on FederalFundedCodePage do |page|
    page.text.should msg
  end
end

And /^I create the Federal Funded Code with:$/ do |table|
  updates = table.rows_hash
  @federal_funded_code = create FederalFundedCodeObject, federal_funded_code: updates['code'],
                        federal_funded_name: updates['name'], active_indicator: updates['active']
end

Then /^I should be on the Maintenance tab$/ do
  on MaintenancePage do |page|
   page.federal_funded_code_link.should exist
  end
end

When /^I select a random Federal Funded Code$/ do
  visit(MaintenancePage).federal_funded_code
  on FederalFundedCodeLookupPage do |page|
    page.active_both.fit :set
    page.search

    row = page.return_random_row
    @validation = { code: row[1].text, name: row[2].text, active: row[3].text  }

    page.open_item_link(@validation[:code])
        # page.select_link_item(@validation[:code])
  end
end

When /^I copy a random Federal Funding Code$/ do
  visit(MaintenancePage).federal_funded_code
  on FederalFundedCodeLookupPage do |page|
    # @federal_funded_code = make FederalFundedCodeObject
    page.active_both.fit :set
    page.search
    page.copy_random
  end
end

When /^I edit a random (active|inactive) Federal Funding Code$/ do |activity|
    visit(MaintenancePage).federal_funded_code
    on FederalFundedCodeLookupPage do |page|
      # @federal_funded_code = make FederalFundedCodeObject
      case activity
        when 'active'
          page.active_yes.fit :set
        when 'inactive'
          page.active_no.fit :set
        else
          puts 'using DEFAULT:: Activity Type'
      end

      page.search
      if page.ffc_lookup_frame_text.include?('No values match this search')
        puts 'There were NO Federal Funded Codes for this test, so test will make one.'

        #Would be nice to grab all existing codes then create one that doesn't already exist
        step "I create the Federal Funded Code with:", table(%{
          | code | W  |
          | name | Test FF new inactive |
          | active | clear      |
        })

        step "I blanket approve the document"

        visit(MaintenancePage).federal_funded_code

        on FederalFundedCodeLookupPage do |page|
          case activity
            when 'active'
              page.active_yes.fit :set
            when 'inactive'
              page.active_no.fit :set
            else
              puts 'using DEFAULT:: Activity Type'
          end
          page.search
        end
      end

      page.edit_random
    end
  end

Then(/^the Federal Funded Code data displays on the inquiry screen$/) do
  #verify data
  on FederalFundedCodeInquiryPage do |page|
    page.federal_funded_name_value.should == @validation[:name]
    page.active_indicator_value.should == @validation[:active]
    page.federal_funded_code_value.should == @validation[:code]
  end
end


And /^I enter a Federal Funded Code of '(.*)'$/ do |new_ff_code|
  on FederalFundedCodePage do |page|
    page.federal_funded_code.fit new_ff_code
  end
end

And /^I enter a Federal Funded Name of '(.*)'$/ do |new_ff_name|
  on FederalFundedCodePage do |page|
    page.federal_funded_name.fit new_ff_name
  end
end

Then /^I verify the Active Indicator is not checked on the Federal Funding Code$/ do
  on FederalFundedCodePage do |page|
    page.active_indicator.checked?.should be false
  end
end

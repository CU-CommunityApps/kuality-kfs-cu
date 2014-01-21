And /^I (#{OrganizationPage::available_buttons}) an Organization$/ do |button|
  if button == 'copy'
    steps %{
    Given I access Organization Lookup
    And   I search for all Organizations
  }
    on OrganizationLookupPage do |page|
      page.copy_random
    end
    @organization = make OrganizationObject
    on OrganizationPage do |page|
      page.expand_all
      page.description.focus
      @organization.begin_date = tomorrow[:date_w_slashes]
      @organization.end_date = in_a_year[:date_w_slashes]
      @organization.fill_out page, :description, :chart_code, :org_code, :begin_date, :end_date
      @organization.document_id = page.document_id
      @browser.alert.ok if @browser.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
    end
  else
    @organization = create OrganizationObject, press: button
  end
end

When /^I (#{OrganizationPage::available_buttons}) the Organization$/ do |button|
  button.gsub!(' ', '_')
  on OrganizationPage do |page|
    page.send(button)
  end
  sleep 10 if button == 'blanket_approve'
end

And /^I make the Organization inactive$/ do
  on(OrganizationPage).active.clear
end

Then /^the Organization Maintenance Document goes to (.*)/ do |doc_status|
  sleep 5
  @organization.view
  on(OrganizationPage).document_status.should == doc_status
end
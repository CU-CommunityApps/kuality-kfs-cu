And(/^I copy an Organization$/) do
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
    page.alert.ok if page.alert.exists? # Because, y'know, sometimes it doesn't actually come up...
    @organization.begin_date = tomorrow[:date_w_slashes]
    @organization.end_date = in_a_year[:date_w_slashes]
    @organization.fill_out page, :description, :chart_code, :org_code, :begin_date, :end_date
    @organization.document_id = page.document_id
  end
end

And(/^I make the Organization inactive$/) do
  on(OrganizationPage).active.clear
end

When(/^I submit the Organization$/) do
  @organization.submit
end

Then /^the Organization Maintenance Document goes to (.*)/ do |doc_status|
  sleep 5
  @organization.view
  on(OrganizationPage).document_status.should == doc_status
end

When(/^I blanket approve the Organization$/) do
  @organization.blanket_approve
end
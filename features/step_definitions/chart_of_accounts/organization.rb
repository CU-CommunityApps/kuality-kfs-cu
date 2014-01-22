And /^I (#{OrganizationPage::available_buttons}) an Organization document$/ do |button|
  button.gsub!(' ', '_')
  @organization = create OrganizationObject, press: button
end

When /^I (#{OrganizationPage::available_buttons}) the Organization document$/ do |button|
  button.gsub!(' ', '_')
  on(OrganizationPage).send(button)
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

Then /^the Organization Maintenance Document goes to (.*)/ do |doc_status|
  sleep 5
  @organization.view
  on(OrganizationPage).document_status.should == doc_status
end

And /^I copy an Organization$/ do
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
end

And /^I make the Organization inactive$/ do
  on(OrganizationPage).active.clear
end

When /^I inactivate an Organization Code with closed accounts$/ do
  steps %{
    Given I access Organization Lookup
  }
  on OrganizationLookupPage do |page|
    page.active_indicator_no.set
    page.search
    page.edit_random
  end
  on OrganizationPage do |page|
    @organization = make OrganizationObject
    @organization.document_id = page.document_id
    @organization.chart_code = page.ro_chart_code
    @organization.org_code = page.ro_org_code
    page.description.set random_alphanums(40, 'AFT')
    page.active.set
    page.blanket_approve
  end
  sleep(5)
  steps %{
    Given I access Organization Lookup
  }
  on OrganizationLookupPage do |page|
    page.chart_code.set @organization.chart_code
    page.org_code.set @organization.org_code
    page.search
    page.edit_random
  end
  on OrganizationPage do |page|
    @organization = make OrganizationObject
    @organization.document_id = page.document_id
    @organization.chart_code = page.ro_chart_code
    @organization.org_code = page.ro_org_code
    page.description.set random_alphanums(40, 'AFT')
    page.active.clear
    page.blanket_approve
  end

end
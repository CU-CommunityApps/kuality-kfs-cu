And /^I edit an Organization Review$/ do
  visit(MainPage).organization_review
  on OrganizationReviewLookupPage do |page|
    page.search
    page.edit_random
  end
  on OrganizationReviewRolePage do |page|
    @organization_review_role = make OrganizationReviewRoleObject
    page.description.set random_alphanums(40, 'AFT')
    @organization_review_role.document_id = page.document_id
    page.save
  end
end

Then /^the Organization Review Role Maintenance Document goes to (.*)/ do |doc_status|
  sleep(10)
  @organization_review_role.view
  on(OrganizationReviewRolePage).document_status.should == doc_status
end

And /^I (#{OrganizationPage::available_buttons}) an Organization Review document/ do |button|
  button.gsub!(' ', '_')
  @organization_review_role = create OrganizationReviewRoleObject, press: button
end

When /^I (#{AccountPage::available_buttons}) the Organization Review document$/ do |button|
  button.gsub!(' ', '_')
  @organization_review_role.send(button)
  sleep 5 if button == 'blanket_approve'
end
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

And /^I create an Organization Review/ do
  @organization_review_role = create OrganizationReviewRoleObject
end


When /^I Blanket Approve the Organization Review document$/ do
    on(OrganizationReviewRolePage).blanket_approve
end
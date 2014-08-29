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

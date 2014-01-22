When /^I access Organization Lookup$/ do
  visit(MainPage).organization
end

When /^I search for all Organizations$/ do
  on(OrganizationLookupPage).search
end

Given /^I am logged in as a KFS Fiscal Officer$/ do
  visit(BackdoorLoginPage).login_as('jguillor')
end

Given(/^I am logged in as a KFS User$/) do
  visit(BackdoorLoginPage).login_as('khuntley')
end

Given /^I am backdoored as "([^"]*)"$/ do |user_id|
  visit(BackdoorLoginPage).login_as(user_id)
end
Given /^I am logged in as a KFS Fiscal Officer$/ do
  visit(LoginPage).login_as('jguillor')
end

Given(/^I am logged in as a KFS User$/) do
  visit(LoginPage).login_as('khuntley')
end

Given /^I am backdoored as "([^"]*)"$/ do |user_id|
  visit(LoginPage).login_as(user_id)
end
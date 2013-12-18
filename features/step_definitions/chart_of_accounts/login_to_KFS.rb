Given /^I am logged in as a KFS Fiscal Officer$/ do
  visit(BackdoorLoginPage).login_as('dh273')
end

Given(/^I am logged in as a KFS User$/) do
  visit(BackdoorLoginPage).login_as('Ccs1')
end

Given /^I am backdoored as "([^"]*)"$/ do |user_id|
  visit(BackdoorLoginPage).login_as(user_id)
end
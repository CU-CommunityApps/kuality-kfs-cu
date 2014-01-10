Given /^I am logged in as a KFS Chart Manager$/ do
  visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
end

Given /^I am logged in as a KFS Technical Administrator$/ do
  visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
end

Given /^I am logged in as a KFS Fiscal Officer$/ do
  visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
end

Given /^I am logged in as a KFS User$/  do
  visit(BackdoorLoginPage).login_as('Ccs1') #TODO get from role service
end

Given /^I am logged in as "([^"]*)"$/ do |user_id|
  visit(BackdoorLoginPage).login_as(user_id)
end

Given /^I am logged in as a KFS Chart User$/  do
  visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
end

Given(/^I am logged in as a KFS Chart Administrator$/) do
  visit(BackdoorLoginPage).login_as('ky16') #TODO get from role service
end

Given /^I am logged in as a KFS Technical Administrator$/ do
  visit(BackdoorLoginPage).login_as('cab379') #TODO get from role service
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

Given /^I am logged in as a KFS Chart Administrator$/ do
  visit(BackdoorLoginPage).login_as('ky16') #TODO get from role service
end

Given /^I am logged in as a KFS Chart Manager$/ do
  visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
end

Given /^I am am logged in as a KFS Chart Administrator$/ do
  visit(BackdoorLoginPage).login_as('ky16') #TODO get from role service
end

Given /^I am logged in as a KFS Cash Manager$/ do
  visit(BackdoorLoginPage).login_as('ccs1') #TODO get from role service
end

Given /^I am logged in as a KFS Contracts & Grants Processor$/ do
  visit(BackdoorLoginPage).login_as('jis45') #TODO get from role service
end

Given /^I am logged in as a KFS System Manager$/ do
  visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
end

Given /^I am logged in as a KFS User for the (.*) document$/ do |eDoc|
  case eDoc
    when 'AD'
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
    when 'AV'
      visit(BackdoorLoginPage).login_as('scu1') #TODO get from role service
    when 'BA'
      visit(BackdoorLoginPage).login_as('sag3') #TODO get from role service
    when 'CCR'
      visit(BackdoorLoginPage).login_as('ccs1') #TODO get from role service
    when 'DV'
      visit(BackdoorLoginPage).login_as('rlc56') #TODO get from role service
    when 'DI'
      visit(BackdoorLoginPage).login_as('sag3') #TODO get from role service
    when 'GEC'
      visit(BackdoorLoginPage).login_as('sag3') #TODO get from role service
    when 'IB'
      visit(BackdoorLoginPage).login_as('djj1') #TODO get from role service
    when 'ICA'
      visit(BackdoorLoginPage).login_as('lmm3') #TODO get from role service
    when 'JV-1'
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
    when 'JV-2'
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
    when 'JV-3'
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
    when 'ND'
      visit(BackdoorLoginPage).login_as('kpg1') #TODO get from role service
    when 'PE'
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
    when 'SB'
      visit(BackdoorLoginPage).login_as('chl52') #TODO get from role service
    when 'TF'
      visit(BackdoorLoginPage).login_as('mdw84') #TODO get from role service
    else
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
  end
end

Given /^I am logged in as a KFS Manager for the (.*) document$/ do |eDoc|
  case eDoc
    when 'CCR'
      visit(BackdoorLoginPage).login_as('ccs1') #TODO get from role service
    when 'SB'
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
    else
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
  end
end
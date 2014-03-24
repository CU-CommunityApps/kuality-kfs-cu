Given /^I am logged in as a KFS Technical Administrator$/ do
  visit(BackdoorLoginPage).login_as('cab379') #TODO get from role service
end

Given /^I am logged in as a Vendor Reviewer$/ do
  visit(BackdoorLoginPage).login_as('kme44') #TODO get from role service
end

Given /^I am logged in as a KFS Fiscal Officer$/ do
  visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
end

Given /^I am logged in as a KFS User$/  do
  visit(BackdoorLoginPage).login_as('ccs1') #TODO get from role service
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

Then /^I switch to the user with the next Pending Action in the Route Log$/ do
  new_user = ''
  on(FinancialProcessingPage) do |page|
    page.expand_all
    page.pnd_act_req_table[1][2].links[0].click
    page.use_new_tab
    page.frm.div(id: 'tab-Overview-div').tables[0][1].tds[0].should exist
    page.frm.div(id: 'tab-Overview-div').tables[0][1].tds[0].text.empty?.should_not
    new_user = page.frm.div(id: 'tab-Overview-div').tables[0][1].tds[0].text
    page.close_children
  end

  step "I am logged in as \"#{new_user}\""
end

Given /^I am logged in as a Disbursement Manager$/ do
  visit(BackdoorLoginPage).login_as('jas9') #TODO get from role service
end

Given /^I login as a KFS user to create an REQS$/ do
  visit(BackdoorLoginPage).login_as('der9') #TODO get from role service
end
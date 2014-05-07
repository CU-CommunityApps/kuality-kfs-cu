Given /^I am logged in as a KFS Technical Administrator$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'Technical Administrator'))
end

Given /^I am logged in as a KFS Operations$/ do
  visit(BackdoorLoginPage).login_as('srb55') #TODO get from role service
  #visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'Operations'))
end

Given /^I am logged in as a Vendor Reviewer$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-VND', 'Reviewer'))
end

Given /^I am logged in as a Vendor Initiator$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-VND', 'CU Vendor Initiator'))
end

Given /^I am logged in as a KFS Fiscal Officer$/ do
  visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
end

Given /^I am logged in as a KFS User$/  do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'User'))
end

Given /^I am logged in as "([^"]*)"$/ do |user_id|
  visit(BackdoorLoginPage).login_as(user_id)
end

Given /^I am logged in as a KFS Chart Manager$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'Chart Manager'))
end

Given /^I am logged in as a KFS Chart Administrator$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'Chart Administrator (cu)'))
end

Given /^I am logged in as a KFS Cash Manager$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-FP', 'Cash Manager'))
end

Given /^I am logged in as a KFS Contracts & Grants Processor$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'Contracts & Grants Processor'))
end

Given /^I am logged in as a KFS Parameter Change Administrator$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KR-NS', 'Parameter Approver (cu)'))
end

Given /^I am logged in as a KFS System Manager$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'Manager'))
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
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
    when 'JV-1'
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
    when 'JV-2'
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
    when 'JV-3'
      visit(BackdoorLoginPage).login_as('dh273') #TODO get from role service
    when 'LLJV'
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
Then /^I switch to the user with the next Pending Action in the Route Log for the (.*) document$/ do |document|
  # TODO : it will be good if a member of 'group' approver can be selected.  For example :  'Group Name: Radioactive Review'
  new_user = ''
  on(page_class_for(document)) do |page|
    page.expand_all
    page.pnd_act_req_table[1][2].links[0].click
    page.use_new_tab
    page.frm.div(id: 'tab-Overview-div').tables[0][1].tds[0].should exist
    page.frm.div(id: 'tab-Overview-div').tables[0][1].tds[0].text.empty?.should_not
    if (page.frm.div(id: 'tab-Overview-div').tables[0][1].text.include?('Principal Name:'))
       new_user = page.frm.div(id: 'tab-Overview-div').tables[0][1].tds[0].text
    else
      # TODO : this is for group.  any other alternative ?
      mbr_tr = page.frm.select(id: 'document.members[0].memberTypeCode').parent.parent.parent
      new_user = mbr_tr[4].text
    end

    page.close_children
  end

  step "I am logged in as \"#{new_user}\""
end


Given /^I am logged in as a Disbursement Manager$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-FP', 'Disbursement Manager'))
end

Given /^I am logged in as a Tax Manager$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'Tax Manager'))
end

Given /^I am logged in as a Disbursement Method Reviewer$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-FP', 'Disbursement Method Reviewer'))
end

Given /^I login as a KFS user to create an REQS$/ do
  visit(BackdoorLoginPage).login_as('der9') #TODO get from role service
end

Given /^I login as a PURAP eSHop user$/ do
  # der9
  visit(BackdoorLoginPage).login_as('ajh42') #TODO get from role service
  #visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PURAP', 'eShop User (cu)'))
end

And /^I am logged in as a PURAP Contract Manager$/ do
  visit(BackdoorLoginPage).login_as('mss7') #TODO get from role service
  #visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PURAP', 'Contract Manager'))
end

Given /^I am logged in as a Purchasing Processor$/ do
  # ml284
  visit(BackdoorLoginPage).login_as('ml284') #TODO get from role service
  #visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PURAP', 'Purchasing Processor'))
end

Given /^I am logged in as a Commodity Reviewer$/ do
  visit(BackdoorLoginPage).login_as('am28') #TODO get from role service
end

Given /^I login as a Accounts Payable Processor to create a PREQ$/ do
  visit(BackdoorLoginPage).login_as('jf427') #TODO get from role service
  #visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PURAP', 'Accounts Payable Processor'))
end

Given /^I am logged in as a KFS Parameter Change Approver$/ do
  #visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KR-NS', 'Parameter Approver (cu) KFS')) # TODO: Get role from service
  visit(BackdoorLoginPage).login_as('ccs1')
end


Given /^I Login as a PDP Format Disbursement Processor$/ do
  visit(BackdoorLoginPage).login_as('mo14') #TODO get from role service
  #visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PDP', 'Processor'))
end

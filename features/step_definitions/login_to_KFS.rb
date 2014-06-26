Given /^I am logged in as a KFS Technical Administrator$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-SYS', 'Technical Administrator'))
end

Given /^I am logged in as a KFS Operations$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'Operations'))
end

Given /^I am logged in as a Vendor Reviewer$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-VND', 'Reviewer Omit Initiator'))
end

Given /^I am logged in as a Vendor Initiator$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-VND', 'CU Vendor Initiator'))
end

Given /^I am logged in as a KFS Fiscal Officer$/ do
  visit(BackdoorLoginPage).login_as(get_aft_parameter_value(ParameterConstants::DEFAULT_FISCAL_OFFICER))
end

Given /^I am logged in as a KFS Fiscal Officer for account number (.*)$/ do |account_number|
  account_info = get_kuali_business_object('KFS-COA','Account','accountNumber=' + account_number)
  fiscal_officer_principal_name = account_info['accountFiscalOfficerUser.principalName']
  visit(BackdoorLoginPage).login_as(fiscal_officer_principal_name)
end

Given /^I am logged in as a KFS User$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-SYS', 'User'))
end

Given /^I am logged in as "([^"]*)"$/ do |user_id|
  visit(BackdoorLoginPage).login_as(user_id)
end

Given /^I am logged in as a KFS Chart Manager$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-SYS', 'Chart Manager'))
end

Given /^I am logged in as a KFS Chart Administrator$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-SYS', 'Chart Administrator (cu)'))
end

Given /^I am logged in as a KFS Cash Manager$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-FP', 'Cash Manager'))
end

Given /^I am logged in as a KFS Contracts & Grants Processor$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-SYS', 'Contracts & Grants Processor'))
end

Given /^I am logged in as a KFS Parameter Change Administrator$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KR-NS', 'Parameter Approver (cu)'))
end

Given /^I am logged in as a KFS System Manager$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-SYS', 'Manager'))
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

Given /^I am logged in as a Disbursement Manager$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-FP', 'Disbursement Manager'))
end

Given /^I am logged in as a Tax Manager$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-SYS', 'Tax Manager'))
end

Given /^I am logged in as a Disbursement Method Reviewer$/ do
  visit(BackdoorLoginPage).login_as(get_random_principal_name_for_role('KFS-FP', 'Disbursement Method Reviewer'))
end

Given /^I login as a KFS user to create an REQS$/ do
  visit(BackdoorLoginPage).login_as('der9') #TODO get from role service
end

And /^I am logged in as a PURAP Contract Manager$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PURAP', 'Contract Manager'))
end

Given /^I am logged in as a Purchasing Processor$/ do
  # ml284
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PURAP', 'Purchasing Processor'))
end

Given /^I am logged in as a Commodity Reviewer$/ do
  visit(BackdoorLoginPage).login_as('am28') #TODO get from role service
end

Given /^I am logged in as FTC\/BSC member User$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'FTC/BSC members'))
end

Given /^I am logged in as a Vendor Contract Editor\(cu\)$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PURAP', 'Vendor Contract Editor(cu)'))
end

Given /^I am logged in as a (.*) principal in namespace (.*)$/ do |role, namespace|
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role(role, namespace))
end

Given /^I am logged in as a Vendor Attachment viewer \(cu\)$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-VND', 'Vendor Attachment viewer (cu)'))
end

Given /^I login as a Accounts Payable Processor to create a PREQ$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PURAP', 'Accounts Payable Processor'))
end

Given /^I am logged in as a KFS Parameter Change Approver$/ do
  #visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KR-NS', 'Parameter Approver (cu) KFS')) # TODO: Get role from service
  visit(BackdoorLoginPage).login_as('ccs1')
end


Given /^I Login as a PDP Format Disbursement Processor$/ do
  visit(BackdoorLoginPage).login_as('mo14') #TODO get from role service
  #visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PDP', 'Processor'))
end

Given /^I Login as a Salary Transfer Initiator$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-LD', 'Labor Distribution Manager (cu)'))
end

Given /^I Login as a Benefit Transfer Initiator$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-LD', 'BT Initiator (cu)'))
end

Given /^I Login as an Asset Processor$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-SYS', 'Asset Processor'))
end

Given /^I am logged in as an e\-SHOP User$/ do
  visit(BackdoorLoginPage).login_as(get_first_principal_name_for_role('KFS-PURAP', 'eShop User (cu)'))
end

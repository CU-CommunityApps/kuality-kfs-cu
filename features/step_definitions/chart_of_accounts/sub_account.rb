And /^I create a Sub-Account using a CG account with a CG Account Responsibility ID in range (.*) to (.*)$/ do |lower_limit, upper_limit|
  account_number_hash = get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&subFundGroup.fundGroupCode=CG&closed=N&active=Y&accountExpirationDate=NULL&}")
  accounts = account_number_hash['org.kuali.kfs.coa.businessobject.Account']

  unless accounts.nil? || accounts.empty?
    valid_account_not_found = true
    index = 0
    while valid_account_not_found & (index < accounts.size)
      cg_responsibility_id = accounts[index]['contractsAndGrantsAccountResponsibilityId'][0]
      account_number = accounts[index]['accountNumber'][0]
      if lower_limit <= cg_responsibility_id && cg_responsibility_id <= upper_limit
        options = {
            chart_code:               get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
            account_number:           account_number,
            name:                     'Test route sub-acct type CS to CG Respon',
            sub_account_type_code:    'EX',
            press:                    'save'
        }
        @sub_account = create SubAccountObject, options
        valid_account_not_found = false
      end
      index += 1
    end #while-loop
  end #unless-statement
end


And /^on the Sub-Account document I modify the Sub-Account Type Code to (.*)$/ do |sub_account_type_code_value|
  (on SubAccountPage).sub_account_type_code.select sub_account_type_code_value
end


And /^on the Sub-Account document I modify the CG Cost Sharing Account Number to a cost sharing account$/ do
  cost_share_account_number_hash = get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&accountTypeCode=CC&subFundGroup.fundGroupCode=CG&accountName=*cost share*&}")
  cost_share_acct_num = ((cost_share_account_number_hash['org.kuali.kfs.coa.businessobject.Account']).sample)['accountNumber'][0]

  on SubAccountPage do |page|
    page.cost_sharing_chart_of_accounts_code.select_value   get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    page.cost_sharing_account_number.fit                    cost_share_acct_num
  end
end


And /^on the Sub-Account document I modify the current Indirect Cost Recovery Account to a contract college general appropriated Account$/ do
  general_appropriated_accounts_hash = get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&accountTypeCode=CC&subFundGroup.fundGroupCode=GN&subFundGroupCode=GNAPPR&}")

  on SubAccountPage do |page|
    on IndirectCostRecoveryAccountsTab do |tab|
      #If there are no Indirect Cost Recovery Accounts in the array, bypass the edit; otherwise, edit the first element in the arrray
      unless tab.current_icr_accounts_count == 0
        tab.update_chart_of_accounts_code.select_value     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
        tab.update_account_number.fit                      ((general_appropriated_accounts_hash['org.kuali.kfs.coa.businessobject.Account']).sample)['accountNumber'][0]
      end
    end
  end
end

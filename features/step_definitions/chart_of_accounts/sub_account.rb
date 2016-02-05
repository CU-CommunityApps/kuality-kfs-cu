And /^I create a Sub-Account using a CG account with a CG Account Responsibility ID in range (.*) to (.*)$/ do |lower_limit, upper_limit|
  #method call should return an array
  account_numbers = find_cg_accounts_in_cg_responsibility_range(lower_limit, upper_limit)

  options = {
      chart_code:               get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
      account_number:           account_numbers.sample,
      name:                     'Test route sub-acct type CS to CG Respon',
      sub_account_type_code:    get_aft_parameter_value(ParameterConstants::DEFAULT_EXPENSE_SUB_ACCOUNT_TYPE_CODE),
  }
  @sub_account = create SubAccountObject, options
end


And /^I edit the Sub-Account changing its type code to Cost Share$/ do
  #add values for the specified keys being edited
  options = {
      description:                          'Edit Sub-Acct from expense to cost share',
      sub_account_type_code:                get_aft_parameter_value(ParameterConstants::DEFAULT_COST_SHARE_SUB_ACCOUNT_TYPE_CODE),
      cost_sharing_account_number:          get_account_of_type('Cost Sharing Account'),
      cost_sharing_chart_of_accounts_code:  get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
  }

  @sub_account.edit options
end


And /^I (#{SubAccountPage::available_buttons}) a Cost Share Sub-Account with an adhoc approver$/ do |button|
  #The requirement for @KFSQA-589 is C&G processor as adhoc user
  @adhoc_user = get_random_principal_name_for_role('KFS-SYS', 'Contracts & Grants Processor')
  @user_id = @adhoc_user # for actionlist check
  sub_account_type_code = get_aft_parameter_value(ParameterConstants::DEFAULT_COST_SHARE_SUB_ACCOUNT_TYPE_CODE)  #get the parameter value once and use it multiple times in this method
  account_number = ""
  i = 0
  while account_number.empty? && i < 10
    # must be an account that can have subaccounttype of 'CS'
    sub_account_info = get_kuali_business_object('KFS-COA','SubAccount',"active=true&a21SubAccount.subAccountTypeCode=#{sub_account_type_code}&chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}")
    account_number = sub_account_info['accountNumber'][0]
    account_info = get_kuali_business_object('KFS-COA','Account',"accountNumber=#{account_number}")
    # check if account is closed or expired
    if account_info['closed'][0] == 'true'
      account_number = ""
    else
      if (account_info['accountExpirationDate'][0]) != 'null' && DateTime.strptime(account_info['accountExpirationDate'][0], '%Y-%m-%d') < DateTime.now
        account_number = ""
      end
    end
    i += 1
  end

  options = {
      account_number:                      account_number,
      cost_sharing_chart_of_accounts_code: get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE_WITH_NAME),
      sub_account_type_code:               sub_account_type_code,
      cost_sharing_account_number:         account_number,
      adhoc_approver_userid:               @adhoc_user
  }

  @sub_account = create SubAccountObject, options
  step "I #{button} the Sub Account document"
end


And /^I create a Sub-Account with a Cost Share Sub-Account Type Code$/ do
  #parameter look-ups are costly, get default chart code once and use it multiple times in this method
  chart_code = get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
  account_number = get_kuali_business_object('KFS-COA','Account',"subFundGroupCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_COST_SHARE_SUB_FUND_GROUP_CODE)}&active=Y&accountExpirationDate=NULL&chartOfAccountsCode=#{chart_code}")['accountNumber'].sample
  options = {
      account_number:                      account_number,
      cost_sharing_chart_of_accounts_code: chart_code,
      sub_account_type_code:               get_aft_parameter_value(ParameterConstants::DEFAULT_COST_SHARE_SUB_ACCOUNT_TYPE_CODE),
      cost_sharing_account_number:         account_number
  }
  @sub_account = create SubAccountObject, options
end


And /^I edit the first active Indirect Cost Recovery Account on the Sub-Account to (a|an) (closed|open)(?: (.*))? Contracts & Grants Account$/ do |a_an_ind, open_closed_ind, expired_non_expired_ind|
  # do not continue, fail the test if there there is no icr_account to edit
  fail ArgumentError, 'No Indirect Cost Recovery Account on the Sub-Account, cannot edit. ' if @sub_account.icr_accounts.length == 0

  random_account_number = find_random_cg_account_number_having(open_closed_ind, expired_non_expired_ind)

  fail ArgumentError, "Cannot edit ICR Account on Sub-Account, WebService call did not return requested '#{open_closed_ind} #{expired_non_expired_ind} Contacts & Grants Acccount' required for this test." if random_account_number.nil? || random_account_number.empty?

  # Need to find first active ICR account as an inactive one could be anywhere in collection
  i = 0
  index_to_use = -1
  while i < @sub_account.icr_accounts.length and index_to_use == -1
    if @sub_account.icr_accounts[i].active_indicator == :set
      index_to_use = i
    end
    i+=1
  end

  # add values for the specified keys being edited for this single ICR account
  options = {
      account_number:         random_account_number,
      chart_of_accounts_code: get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
  }
  
  @sub_account.icr_accounts[index_to_use].edit options
end

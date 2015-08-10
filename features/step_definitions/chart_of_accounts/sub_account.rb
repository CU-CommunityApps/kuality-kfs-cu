And /^I create a Sub-Account using a CG account with a CG Account Responsibility ID in range (.*) to (.*)$/ do |lower_limit, upper_limit|
  responsibility_criteria = (lower_limit..upper_limit).to_a.join('|') #get all numeric values in range separated by pipe  (1..3)=1|2|3
  accounts_hash = get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&subFundGroup.fundGroupCode=CG&closed=N&active=Y&accountExpirationDate=NULL&contractsAndGrantsAccountResponsibilityId=#{responsibility_criteria}")

  # The webservice returns the data in two different formats depending upon whether there is one Account found
  # or there are multiple Accounts found. We need to deal with both cases and we need to deal with condition of
  # no data at all returned.
  account_numbers = []
  if accounts_hash.empty?  #no data found
    raise RuntimeError, "No CG Accounts with CG Account Responsibility ID in range #{lower_limit} to #{upper_limit} found."
  elsif accounts_hash.has_key?('org.kuali.kfs.coa.businessobject.Account')  # multiple accounts found
    accounts_array = accounts_hash['org.kuali.kfs.coa.businessobject.Account']
    accounts_array.each{ |value|
      account_numbers.concat(value['accountNumber'])
    }
  else #single Account found
      account_numbers.concat(accounts_hash['accountNumber'])
  end

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


And /^I edit the current Indirect Cost Recovery Account on the Sub-Account to a Contracts & Grants Account$/ do
  # do not continue, if there is not one and only one icr_account
  fail ArgumentError, 'No Indirect Cost Recovery Account on the Sub-Account, cannot edit. ' if @sub_account.icr_accounts.length == 0
  fail ArgumentError, 'More that one Indirect Cost Recovery Account on the Sub-Account, do not know which one to edit.' if @sub_account.icr_accounts.length > 1
  # implied,  @sub_account.icr_accounts.length == 1

  #add values for the specified keys being edited for this single ICR account
  options = {
      account_number:         get_account_of_type('Contracts & Grants Account'),
      chart_of_accounts_code: get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
      line_number:            0   #current value is considered to be the first value
  }

  @sub_account.edit icr_accounts: [options]
end

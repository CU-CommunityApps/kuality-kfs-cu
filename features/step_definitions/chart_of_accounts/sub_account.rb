And /^I create a Sub-Account using a CG account with a CG Account Responsibility ID in range (.*) to (.*)$/ do |lower_limit, upper_limit|
  accounts = []
  counter = lower_limit.to_i

  #get all of the accounts that are in the range we are looking for
  while counter <= upper_limit.to_i do
    account_number_hash = get_kuali_business_objects('KFS-COA','Account',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&subFundGroup.fundGroupCode=CG&closed=N&active=Y&accountExpirationDate=NULL&contractsAndGrantsAccountResponsibilityId=#{counter}&}")
    accounts.concat(account_number_hash['org.kuali.kfs.coa.businessobject.Account'])
    counter += 1
  end

  options = {
      chart_code:               get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
      account_number:           (accounts.sample)['accountNumber'][0],
      name:                     'Test route sub-acct type CS to CG Respon',
      sub_account_type_code:    'EX',
      press:                    'save'
  }
  @sub_account = create SubAccountObject, options
end


And /^I edit the Sub-Account with the following changes:$/ do |edits|
  edits = edits.rows_hash.snake_case_key
  new_key_value_pairs = Hash.new

  #format the edits correctly for the hash key-value pairs
  edits.each do |key, current_value|
    #add the correct values for the specified keys
    case current_value
      when 'Random'
        case key
          when :description
            existing_key_value_pair = { description:  random_alphanums(37, 'AFT') }
          else
            #No change, do nothing and use what was passed to us
        end
      when 'CS'
        existing_key_value_pair = { sub_account_type_code:  'CS' }
      when 'Cost Sharing Account'
        existing_key_value_pair = { cost_sharing_account_number:  get_account_of_type('Cost Sharing Account') }

        #page requires additional implied data elements so we must add them
        new_key_value_pairs = { cost_sharing_chart_of_accounts_code:  get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE) }
      else
        #No change, do nothing and use what was passed to us
    end

    edits.merge!(existing_key_value_pair) unless existing_key_value_pair.nil?
  end #for-each

  # could not merge new values into existing hash while iterating, have to do it outside of loop
  edits.merge!(new_key_value_pairs)

  on SubAccountPage do |page|
    @sub_account.edit edits
  end
end


And /^I edit the current Indirect Cost Recovery Account on the Sub-Account with the following changes:$/ do |edits|
  # do not continue, if there is not one and only one icr_account
  fail ArgumentError, 'No Indirect Cost Recovery Account on the Sub-Account, cannot edit. ' if @sub_account.icr_accounts.length == 0
  fail ArgumentError, 'More that one Indirect Cost Recovery Account on the Sub-Account, do not know which one to edit.' if @sub_account.icr_accounts.length > 1

  # implied,  @sub_account.icr_accounts.length == 1
  edits = edits.rows_hash.snake_case_key
  new_key_value_pairs = Hash.new

  edits.each do |key, current_value|
    #add the correct values for the specified keys
    case current_value
      when 'Contract College General Appropriated Account'
        existing_key_value_pair = { account_number:  get_account_of_type('General Appropriated Account') }

        #page requires additional implied data elements so we must add them
        new_key_value_pairs = {
            chart_of_accounts_code: get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
            line_number:            0   #current value is considered to be the first value
        }
        else
        #No change, do nothing and use what was passed to us
    end
    #update the existing value for the identified key
    edits.merge!(existing_key_value_pair) unless existing_key_value_pair.nil?
  end

  # could not merge new values into existing hash while iterating, have to do it outside of loop
  edits.merge!(new_key_value_pairs)

  on SubAccountPage do |page|
    @sub_account.edit icr_accounts: [edits]
  end
end

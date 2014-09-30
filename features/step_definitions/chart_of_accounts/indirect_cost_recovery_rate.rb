And /^I create a wild carded Indirect Cost Recovery Rate of (.*) percent using random institutional allowance object codes$/ do |percent|
  @indirect_cost_recovery_rate = create IndirectCostRecoveryRateObject
  @indirect_cost_recovery_rate.create_wildcard_icr_for_random_institutional_object_codes percent
end


# This method presumes that the following global data elements have been created and are populated:
# @from_indirect_cost_rate_debit_object_code, @from_indirect_cost_rate_credit_object_code
And /^I create a wild carded Indirect Cost Recovery Rate of (.*) percent using From Indirect Cost Rate institutional allowance object codes$/ do |percent|
  @indirect_cost_recovery_rate = create IndirectCostRecoveryRateObject
  @indirect_cost_recovery_rate.create_wildcard_icr_for_specified_institutional_object_codes percent, @from_indirect_cost_rate_debit_object_code, @from_indirect_cost_rate_credit_object_code
end


# This method creates the following global data elements:
# @from_indirect_cost_rate, @from_indirect_cost_rate_debit_object_code, @from_indirect_cost_rate_credit_object_code
And /^I remember the Indirect Cost Recovery Rate as a From Indirect Cost Rate$/ do
  @from_indirect_cost_rate = @indirect_cost_recovery_rate.rate_id
  @from_indirect_cost_rate_debit_object_code = @indirect_cost_recovery_rate.debit_object_code
  @from_indirect_cost_rate_credit_object_code = @indirect_cost_recovery_rate.credit_object_code
end


# This method creates the following global data elements:
# @to_indirect_cost_rate, @to_indirect_cost_rate_debit_object_code, @to_indirect_cost_rate_credit_object_code
And /^I remember the Indirect Cost Recovery Rate as a To Indirect Cost Rate$/ do
  @to_indirect_cost_rate = @indirect_cost_recovery_rate.rate_id
  @to_indirect_cost_rate_debit_object_code = @indirect_cost_recovery_rate.debit_object_code
  @to_indirect_cost_rate_credit_object_code = @indirect_cost_recovery_rate.credit_object_code
end


And /^I edit an active CG account modifying the Indirect Cost Rate to the (From|To) Indirect Cost Rate$/ do |target|
  case target
    when 'From'
      indirect_cost_rate = @from_indirect_cost_rate
      remembered_account = @remembered_from_account
    when 'To'
      indirect_cost_rate = @to_indirect_cost_rate
      remembered_account = @remembered_to_account
  end

  #Need to ensure CG account being retrieved does not match existing CG account if it has been populated.
  if remembered_account.nil?
    #just get an account
    step 'I find an unexpired CG account that has an unexpired continuation account'
  else
    #remembered_account exists, ensure new CG account being obtained is different
    accounts_not_different = true
    while accounts_not_different
      step 'I find an unexpired CG account that has an unexpired continuation account'
      unless (@account.chart_code.eql? remembered_account.chart_code) &&
             (@account.number.eql? remembered_account.number)
        accounts_not_different = false
      end
    end
  end
  step "I change the Indirect Cost Rate on account #{@account.number} belonging to chart #{@account.chart_code} to #{indirect_cost_rate}"
end



And /^I add the remembered (From|To) account for a Services Object code for amount (.*)$/ do |target, amount|
  case target
    when 'From'
      account_number = @remembered_from_account.number
      line_description = 'From wildcard ICR account being used'
      object_code = get_kuali_business_object('KFS-COA','ObjectCode',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectLevelCode=SVCS&active=true")
    when 'To'
      account_number = @remembered_to_account.number
      line_description = 'To wildcard ICR account being used'
      object_code = get_kuali_business_object('KFS-COA','ObjectCode',"chartOfAccountsCode=#{get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)}&financialObjectLevelCode=SVCS&active=true")
  end
  step "I add a #{target} amount of ""#{amount}"" for account ""#{account_number}"" with object code ""#{object_code}"" with a line description of ""#{line_description}"" to the DI Document"
end


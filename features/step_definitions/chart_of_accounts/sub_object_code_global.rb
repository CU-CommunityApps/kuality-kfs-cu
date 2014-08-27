When /^I add multiple account lines using Organization Code (.*)$/ do |org_code|
  @sub_object_code_global.add_multiple_account_lines(org_code)
end

Then /^retrieved accounts equal all Active Accounts for these Organization Codes:$/ do |multiple_account_numbers|
  accounts = multiple_account_numbers.raw.flatten
  accounts.each do |an_account_number|
    on(SubObjectCodeGlobalPage).verify_account_number(get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE), an_account_number).should exist
  end
end

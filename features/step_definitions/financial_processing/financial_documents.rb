Then /^The Chart of Accounts on the accounting line defaults appropriately for the (.*) document$/ do |document|
  on page_class_for(document) do |page|
    if ['Budget Adjustment', 'Internal Billing', 'General Error Correction'].include?(document)
      page.target_chart_code.value.should == get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    end
    page.source_chart_code.value.should == get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
  end
end
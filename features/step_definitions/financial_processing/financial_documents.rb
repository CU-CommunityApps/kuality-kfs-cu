Then /^The Chart of Accounts on the accounting line defaults appropriately for the (.*) document$/ do |document|
  on page_class_for(document) do |page|
    page.source_chart_code.value.should == 'IT' #TODO get from config
    if ['Budget Adjustment', 'Internal Billing', 'General Error Correction'].include?(document)
      page.target_chart_code.value.should == 'IT' #TODO get from config
    end
  end
end
Then /^The Chart of Accounts on the accounting line defaults appropriately for the (.*) document$/ do |document|
  doc_object = get(snake_case(document))
  page_klass = Kernel.const_get(doc_object.class.to_s.gsub(/(.*)Object$/,'\1Page'))

  on page_klass do |page|
    puts page_klass
    page.source_chart_code.value.should == 'IT' #TODO get from config
    if ['Budget Adjustment', 'Internal Billing', 'General Error Correction'].include?(document)
      page.target_chart_code.value.should == 'IT' #TODO get from config
    end
  end

end
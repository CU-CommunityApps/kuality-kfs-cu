And /^I find a value for a parameter named (.*) for the (.*) document$/ do |param_name, document|
  @browser.goto "#{$base_rice_url}kr/maintenance.do?businessObjectClassName=org.kuali.rice.coreservice.impl.parameter.ParameterBo&name=#{param_name}&componentCode=#{document.gsub(' ', '')}&namespaceCode=KFS-FP&applicationId=KFS&methodToCall=edit"
  @parameter_values = on(ParameterPage).parameter_value.value.split(";")
end

And /^I update the (.*) Parameter for the (.*) component in the (.*) namespace with the following values:$/ do |parameter_name, component, namespace_code, table|
  # table is a table.hashes.keys # => [:Parameter Value, :EX]
  pending
end
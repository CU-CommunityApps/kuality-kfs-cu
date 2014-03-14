And /^I find a value for a parameter named (.*) for the (.*) document$/ do |param_name, document|
  @browser.goto "#{$base_rice_url}kr/maintenance.do?businessObjectClassName=org.kuali.rice.coreservice.impl.parameter.ParameterBo&name=#{param_name}&componentCode=#{document.gsub(' ', '')}&namespaceCode=KFS-FP&applicationId=KFS&methodToCall=edit"
  @parameter_values = on(ParameterPage).parameter_value.value.split(";")
end

And /^I update the (.*) Parameter for the (.*) component in the (.*) namespace with the following values:$/ do |parameter_name, component, namespace_code, table|
  update_values = table.rows_hash

  visit(AdministrationPage).parameter
  on ParameterLookup do |lookup|
    lookup.namespace_code.select_value(/#{namespace_code}/m)
    lookup.component.fit      component
    lookup.parameter_name.fit parameter_name
    lookup.search
    lookup.edit_random # There can only be one!
  end

  on ParameterPage do |page|
    page.description.fit 'Temporary change to add in IC value.'
    page.parameter_value.fit "#{page.parameter_value.text};#{update_values['Parameter Value']}"
    page.submit
  end

end
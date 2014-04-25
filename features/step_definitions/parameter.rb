And /^I find a value for a parameter named (.*) for the (.*) document$/ do |param_name, document|
  @browser.goto "#{$base_rice_url}kr/maintenance.do?businessObjectClassName=org.kuali.rice.coreservice.impl.parameter.ParameterBo&name=#{param_name}&componentCode=#{document.gsub(' ', '')}&namespaceCode=KFS-FP&applicationId=KFS&methodToCall=edit"
  @parameter_values = on(ParameterPage).parameter_value.value.split(";")
end

And /^I update the (.*) Parameter for the (.*) component in the (.*) namespace with the following values:$/ do |parameter_name, component, namespace_code, table|
  update_values = table.rows_hash

  step "I lookup the #{parameter_name} Parameter for the #{component} component in the #{namespace_code} namespace"
  on ParameterPage do |page|
    @parameter = make ParameterObject, namespace_code:                    page.old_namespace_code,
                                       component:                         page.old_component,
                                       application_id:                    page.old_application_id,
                                       parameter_name:                    page.old_parameter_name,
                                       parameter_value:                   page.old_parameter_value,
                                       parameter_description:             page.old_parameter_description,
                                       parameter_type_code:               page.old_parameter_type_code,
                                       parameter_constraint_code_allowed: page.old_parameter_constraint_code == 'Allowed' ? :set : :clear,
                                       parameter_constraint_code_denied:  page.old_parameter_constraint_code == 'Denied' ? :set : :clear

    @parameter.edit description: 'Temporary change to add in IC value.',
                    parameter_value: update_values['Parameter Value'],
                    press: :submit
  end
end

And /^I lookup the (.*) Parameter for the (.*) component in the (.*) namespace$/ do |parameter_name, component, namespace_code|
  visit(AdministrationPage).parameter
  on ParameterLookup do |lookup|
    lookup.namespace_code.select_value(/#{namespace_code}/m)
    lookup.component.fit      component
    lookup.parameter_name.fit parameter_name
    lookup.search
    lookup.edit_random # There can only be one!
  end
end

And /^I finalize the Parameter document$/ do
  # Note: this means you'll change users before the end of this step.
  step 'the Parameter document goes to ENROUTE'
  step 'I am logged in as a KFS Parameter Change Approver'
  step 'I view the Parameter document'
  step 'I approve the Parameter document'
  step 'the Parameter document goes to FINAL'
end
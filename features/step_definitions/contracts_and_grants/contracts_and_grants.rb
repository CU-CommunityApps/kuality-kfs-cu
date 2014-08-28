

When  /^I create a Contract Grant Reporting Code document$/ do
  @contract_grant_reporting_code = create ContractGrantReportingCodeObject
end


# This method presumes the @contract_grant_reporting_code class has been initialized and sets the
# CG Reporting Code Name to the string 'Edited CG Reporting Code Name ' followed by nine random alphanumerics.
And /^I edit the CG Reporting Code Name of the Contract Grant Reporting Code$/ do
  visit(MaintenancePage).cg_reporting_code
  on(ContractGrantsReportingCodeLookupPage) do |page|
    page.chart_code.fit @contract_grant_reporting_code.chart_code
    page.code.fit @contract_grant_reporting_code.code
    page.search
    page.wait_for_search_results
    page.edit_random  #cg reporting code we want was specified so should be only one returned
  end
  on (ContractGrantReportingCodePage) do |page|
    page.description.fit random_alphanums(37, 'AFT')
    page.name.fit random_alphanums(9, 'Edited CG Reporting Code Name ')
  end
end


# This method presumes a @contract_grant_reporting_code object has been created and initialized with data.
# This method creates @object_code which is an ObjectCodeObject with document_id, chart_code, object_code,
# level_code, and cg_reporting_code value set to what this method either modified or used for searching.
And /^I change the Contract and Grant Reporting Code on a Contract and Grant Object Code to the Contract and Grant Reporting Code just entered$/ do
  contracts_grants_level_code = 'CGRT'
  visit(MainPage).object_code
  on(ObjectCodeLookupPage) do |page|
    page.chart_code.fit @contract_grant_reporting_code.chart_code
    page.level_code.fit contracts_grants_level_code
    page.search
    page.wait_for_search_results
    page.edit_random
  end
  @object_code = make ObjectCodeObject
  on(ObjectCodePage) do |page|
    page.description.fit random_alphanums(37, 'AFT')
    page.cg_reporting_code.fit @contract_grant_reporting_code.code

    @object_code.document_id = page.document_id
    @object_code.object_code = page.object_code_value.text.strip
    @object_code.level_code = contracts_grants_level_code
    @object_code.cg_reporting_code = @contract_grant_reporting_code.code
  end
end



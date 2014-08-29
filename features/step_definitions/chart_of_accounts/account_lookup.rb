Then /^the Account Lookup page should appear with Cornell custom fields$/ do
  on AccountLookupPage do |page|
    page.responsibility_center_code.should exist
    page.reports_to_org_code.should exist
    page.reports_to_coa_code.should exist
    page.fund_group_code.should exist
    page.subfund_program_code.should exist
    page.appropriation_acct_number.should exist
    page.major_reporting_category_code.should exist
    page.acct_manager_principal_name.should exist
    page.acct_supervisor_principal_name.should exist
  end
end

#overriding kuality-kfs object
class AccountLookupPage

  element(:responsibility_center_code) { |b| b.frm.text_field(name: 'organization.responsibilityCenterCode') }
  element(:reports_to_org_code) { |b| b.frm.text_field(name: 'organization.reportsToOrganizationCode') }
  element(:reports_to_coa_code) { |b| b.frm.text_field(name: 'organization.reportsToChartOfAccountsCode') }
  element(:fund_group_code) { |b| b.frm.text_field(name: 'subFundGroup.fundGroupCode') }
  element(:subfund_program_code) { |b| b.frm.text_field(name: 'extension.programCode') }
  element(:appropriation_acct_number) { |b| b.frm.text_field(name: 'extension.appropriationAccountNumber') }
  element(:major_reporting_category_code) { |b| b.frm.text_field(name: 'extension.majorReportingCategoryCode') }
  element(:acct_manager_principal_name) { |b| b.frm.text_field(name: 'accountManagerUser.principalName') }
  element(:acct_supervisor_principal_name) { |b| b.frm.text_field(name: 'accountSupervisoryUser.principalName') }

end

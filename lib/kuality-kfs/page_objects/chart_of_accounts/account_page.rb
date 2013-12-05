class AccountPage < BasePage

  description_field
  global_buttons
  tiny_buttons
  tab_buttons

  element(:chart_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.chartOfAccountsCode') }
  element(:number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountNumber') }
  element(:name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountName') }
  element(:org_cd) { |b| b.frm.text_field(name: 'document.newMaintainableObject.organizationCode') }
  element(:campus_cd) { |b| b.frm.select(name: 'document.newMaintainableObject.accountPhysicalCampusCode') }
  element(:effective_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountEffectiveDate') }
  element(:postal_cd) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountZipCode') }
  element(:city) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountCityName') }
  element(:state) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountStateCode') }
  element(:address) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountStreetAddress') }
  element(:type_cd) { |b| b.frm.select(name: 'document.newMaintainableObject.accountTypeCode') }
  element(:sub_fnd_group_cd) { |b| b.frm.text_field(name: 'document.newMaintainableObject.subFundGroupCode') }
  element(:higher_ed_funct_cd) { |b| b.frm.text_field(name: 'document.newMaintainableObject.financialHigherEdFunctionCd') }
  element(:restricted_status_cd) { |b| b.frm.select(name: 'document.newMaintainableObject.accountRestrictedStatusCode') }
  element(:fo_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountFiscalOfficerUser.principalName') }
  element(:supervisor_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountSupervisoryUser.principalName') }
  element(:manager_principal_name) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountManagerUser.principalName') }
  element(:budget_record_level_cd) { |b| b.frm.select(name: 'document.newMaintainableObject.budgetRecordingLevelCode') }
  element(:sufficient_funds_cd) { |b| b.frm.select(name: 'document.newMaintainableObject.accountSufficientFundsCode') }
  element(:expense_guideline_text) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountGuideline.accountExpenseGuidelineText') }
  element(:income_guideline_txt) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountGuideline.accountIncomeGuidelineText') }
  element(:purpose_text) { |b| b.frm.text_field(name: 'document.newMaintainableObject.accountGuideline.accountPurposeText') }

  element(:income_stream_financial_cost_cd) { |b| b.frm.select(name: 'document.newMaintainableObject.incomeStreamFinancialCoaCode') }
  element(:income_stream_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.incomeStreamAccountNumber') }

end
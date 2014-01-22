#overriding kuality-kfs object
class AccountPage

  element(:subfund_program_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.programCode') }
  element(:major_reporting_category_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.majorReportingCategoryCode') }
  element(:appropriation_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.appropriationAccountNumber') }
  element(:labor_benefit_rate_category_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.laborBenefitRateCategoryCode') }

end

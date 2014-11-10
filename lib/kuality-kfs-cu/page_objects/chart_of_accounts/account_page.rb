#overriding kuality-kfs object
class AccountPage

  element(:subfund_program_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.programCode') }
  element(:major_reporting_category_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.majorReportingCategoryCode') }
  element(:appropriation_account_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.appropriationAccountNumber') }
  element(:labor_benefit_rate_category_code) { |b| b.frm.text_field(name: 'document.newMaintainableObject.laborBenefitRateCategoryCode') }
  element(:everify_indicator) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.extension.everify') }
  element(:cost_share_for_project_number) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.costShareForProjectNumber') }
  element(:invoice_frequency_code) { |b| b.frm.select(name: 'document.newMaintainableObject.extension.invoiceFrequencyCode') }
  element(:invoice_type_code) { |b| b.frm.select(name: 'document.newMaintainableObject.extension.invoiceTypeCode') }

  # New
  value(:subfund_program_code_new) { |b| b.subfund_program_code.present? ? b.subfund_program_code.value : b.subfund_program_code_readonly }
  value(:major_reporting_category_code_new) { |b| b.major_reporting_category_code.present? ? b.major_reporting_category_code.value : b.major_reporting_category_code_readonly }
  value(:appropriation_account_number_new) { |b| b.appropriation_account_number.present? ? b.appropriation_account_number.value : b.appropriation_account_number_readonly }
  value(:labor_benefit_rate_category_code_new) { |b| b.labor_benefit_rate_category_code.present? ? b.labor_benefit_rate_category_code.value : b.labor_benefit_rate_category_code_readonly }
  value(:everify_indicator_new) { |b| b.everify_indicator.present? ? yesno2setclear(b.everify_indicator.set?) : b.everify_indicator_readonly }
  value(:cost_share_for_project_number_new) { |b| b.cost_share_for_project_number.present? ? b.cost_share_for_project_number.value : b.cost_share_for_project_number_readonly }
  value(:invoice_frequency_code_new) { |b| b.invoice_frequency_code.present? ? b.invoice_frequency_code.selected_options.first.text : b.invoice_frequency_code_readonly }
  value(:invoice_type_code_new) { |b| b.invoice_type_code.present? ? b.invoice_type_code.selected_options.first.text : b.invoice_type_code_readonly }

  # Old
  value(:subfund_program_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.programCode.div').text.strip }
  value(:major_reporting_category_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.majorReportingCategoryCode.div').text.strip }
  value(:appropriation_account_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.appropriationAccountNumber.div').text.strip }
  value(:labor_benefit_rate_category_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.laborBenefitRateCategoryCode.div').text.strip }
  value(:everify_indicator_old) { |b| yesno2setclear(b.frm.span(id: 'document.oldMaintainableObject.extension.everify.div').text.strip) }
  value(:cost_share_for_project_number_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.costShareForProjectNumber.div').text.strip }
  value(:invoice_frequency_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.invoiceFrequencyCode.div').text.strip }
  value(:invoice_type_code_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.invoiceTypeCode.div').text.strip }


  # Read-Only
  value(:subfund_program_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.programCode.div').text.strip }
  value(:major_reporting_category_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.majorReportingCategoryCode.div').text.strip }
  value(:appropriation_account_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.appropriationAccountNumber.div').text.strip }
  value(:labor_benefit_rate_category_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.laborBenefitRateCategoryCode.div').text.strip }
  value(:everify_indicator_readonly) { |b| yesno2setclear(b.frm.span(id: 'document.newMaintainableObject.extension.everify.div').text.strip) }
  value(:cost_share_for_project_number_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.costShareForProjectNumber.div').text.strip }
  value(:invoice_frequency_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.invoiceFrequencyCode.div').text.strip }
  value(:invoice_type_code_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.invoiceTypeCode.div').text.strip }

  value(:account_extended_data_old) do |b|
    {
      subfund_program_code:             b.subfund_program_code_old,
      major_reporting_category_code:    b.major_reporting_category_code_old,
      labor_benefit_rate_category_code: b.labor_benefit_rate_category_code_old,
      appropriation_account_number:     b.appropriation_account_number_old,
      everify_indicator:                b.everify_indicator_old,
      cost_share_for_project_number:    b.cost_share_for_project_number_old,
      invoice_frequency_code:           b.invoice_frequency_code_old,
      invoice_type_code:                b.invoice_type_code_old
    }
  end

  value(:account_extended_data_new) do |b|
    {
      subfund_program_code:             (b.subfund_program_code.exists? ? b.subfund_program_code_new : b.subfund_program_code_readonly),
      major_reporting_category_code:    (b.major_reporting_category_code.exists? ? b.major_reporting_category_code_new : b.major_reporting_category_code_readonly),
      appropriation_account_number:     (b.appropriation_account_number.exists? ? b.appropriation_account_number_new : b.appropriation_account_number_readonly),
      labor_benefit_rate_category_code: (b.labor_benefit_rate_category_code.exists? ? b.labor_benefit_rate_category_code_new : b.labor_benefit_rate_category_code_readonly),
      everify_indicator:                (b.everify_indicator.exists? ? b.everify_indicator_new : b.everify_indicator_readonly),
      cost_share_for_project_number:    (b.cost_share_for_project_number.exists? ? b.cost_share_for_project_number_new : b.cost_share_for_project_number_readonly),
      invoice_frequency_code:           (b.invoice_frequency_code.exists? ? b.invoice_frequency_code_new : b.invoice_frequency_code_readonly),
      invoice_type_code:                (b.invoice_type_code.exists? ? b.invoice_type_code_new : b.invoice_type_code_readonly)
    }
  end

  value(:account_extended_data_readonly) do |b|
    {
      subfund_program_code:             b.subfund_program_code_readonly,
      major_reporting_category_code:    b.major_reporting_category_code_readonly,
      appropriation_account_number:     b.appropriation_account_number_readonly,
      labor_benefit_rate_category_code: b.labor_benefit_rate_category_code_readonly,
      everify_indicator:                b.everify_indicator_readonly,
      cost_share_for_project_number:    b.cost_share_for_project_number_readonly,
      invoice_frequency_code:           b.invoice_frequency_code_readonly,
      invoice_type_code:                b.invoice_type_code_readonly
    }
  end

end

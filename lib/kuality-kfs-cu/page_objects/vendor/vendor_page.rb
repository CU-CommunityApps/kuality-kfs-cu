#overriding kuality-kfs object
class VendorPage

  element(:w9_received_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.vendorHeader.extension.vendorW9ReceivedDate') }
  alias_method :new_w9_received_date, :w9_received_date
  element(:general_liability_coverage_amt) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.generalLiabilityCoverageAmount') }
  alias_method :new_general_liability_coverage_amt, :general_liability_coverage_amt
  element(:general_liability_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.generalLiabilityExpiration') }
  alias_method :new_general_liability_expiration_date, :general_liability_expiration_date
  element(:automobile_liability_coverage_amt) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.automobileLiabilityCoverageAmount') }
  alias_method :new_automobile_liability_coverage_amt, :automobile_liability_coverage_amt
  element(:automobile_liability_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.automobileLiabilityExpiration') }
  alias_method :new_automobile_liability_expiration_date, :automobile_liability_expiration_date
  element(:workman_liability_coverage_amt) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.workmansCompCoverageAmount') }
  alias_method :new_workman_liability_coverage_amt, :workman_liability_coverage_amt
  element(:workman_liability_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.workmansCompExpiration') }
  alias_method :new_workman_liability_expiration_date, :workman_liability_expiration_date
  element(:excess_liability_umb_amt) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.excessLiabilityUmbrellaAmount') }
  alias_method :new_excess_liability_umb_amt, :excess_liability_umb_amt
  element(:excess_liability_umb_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.excessLiabilityUmbExpiration') }
  alias_method :new_excess_liability_umb_expiration_date, :excess_liability_umb_expiration_date
  element(:health_offset_lic_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.healthOffSiteLicenseExpirationDate') }
  alias_method :new_health_offset_lic_expiration_date, :health_offset_lic_expiration_date
  element(:insurance_note) { |b| b.frm.textarea(name: 'document.newMaintainableObject.extension.insuranceNotes') }
  alias_method :new_insurance_note, :insurance_note
  element(:insurance_requirements_complete) { |b| b.frm.select(name: 'document.newMaintainableObject.extension.insuranceRequirementsCompleteIndicator') }
  alias_method :new_insurance_requirements_complete, :insurance_requirements_complete
  element(:cornell_additional_ins_ind) { |b| b.frm.select(name: 'document.newMaintainableObject.extension.cornellAdditionalInsuredIndicator') }
  alias_method :new_cornell_additional_ins_ind, :cornell_additional_ins_ind
  element(:health_offsite_catering_lic_req) { |b| b.frm.select(name: 'document.newMaintainableObject.extension.healthOffSiteCateringLicenseReq') }
  alias_method :new_health_offsite_catering_lic_req, :health_offsite_catering_lic_req
  element(:insurance_requirement_indicator) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.extension.insuranceRequiredIndicator') }
  alias_method :new_insurance_requirement_indicator, :insurance_requirement_indicator
  element(:default_payment_method) { |b| b.frm.select(id: 'document.newMaintainableObject.extension.defaultB2BPaymentMethodCode') }
  alias_method :new_default_payment_method, :default_payment_method

  # readonly insurance
  element(:w9_received_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.vendorHeader.extension.vendorW9ReceivedDate.div').text.strip }
  element(:general_liability_coverage_amt_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.generalLiabilityCoverageAmount.div').text.strip }
  element(:general_liability_expiration_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.generalLiabilityExpiration.div').text.strip }
  element(:automobile_liability_coverage_amt_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.automobileLiabilityCoverageAmount.div').text.strip }
  element(:automobile_liability_expiration_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.automobileLiabilityExpiration.div').text.strip }
  element(:workman_liability_coverage_amt_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.workmansCompCoverageAmount.div').text.strip }
  element(:workman_liability_expiration_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.workmansCompExpiration.div').text.strip }
  element(:excess_liability_umb_amt_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.excessLiabilityUmbrellaAmount.div').text.strip }
  element(:excess_liability_umb_expiration_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.excessLiabilityUmbExpiration.div').text.strip }
  element(:health_offset_lic_expiration_date_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.healthOffSiteLicenseExpirationDate.div').text.strip }
  element(:insurance_note_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.insuranceNotes.div').text.strip }
  element(:insurance_requirements_complete_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.insuranceRequirementsCompleteIndicator.div').text.strip }
  element(:cornell_additional_ins_ind_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.cornellAdditionalInsuredIndicator.div').text.strip }
  element(:health_offsite_catering_lic_req_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.healthOffSiteCateringLicenseReq.div').text.strip }
  element(:insurance_requirement_indicator_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.insuranceRequiredIndicator.div').text.strip }
  element(:default_payment_method_readonly) { |b| b.frm.span(id: 'document.newMaintainableObject.extension.defaultB2BPaymentMethodCode.div').text.strip }

  # new insurance
  value(:w9_received_date_new) { |i=0, b| b.w9_received_date_update(i).exists? ? b.w9_received_date_update(i).value : b.w9_received_date_readonly(i) }
  value(:general_liability_coverage_amt_new) { |i=0, b| b.general_liability_coverage_amt_update(i).exists? ? b.general_liability_coverage_amt_update(i).value : b.general_liability_coverage_amt_readonly(i) }
  value(:general_liability_expiration_date_new) { |i=0, b| b.general_liability_expiration_date_update(i).exists? ? b.general_liability_expiration_date_update(i).value : b.general_liability_expiration_date_readonly(i) }
  value(:automobile_liability_coverage_amt_new) { |i=0, b| b.automobile_liability_coverage_amt_update(i).exists? ? b.automobile_liability_coverage_amt_update(i).value : b.automobile_liability_coverage_amt_readonly(i) }
  value(:automobile_liability_expiration_date_new) { |i=0, b| b.automobile_liability_expiration_date_update(i).exists? ? b.automobile_liability_expiration_date_update(i).value : b.automobile_liability_expiration_date_readonly(i) }
  value(:workman_liability_coverage_amt_new) { |i=0, b| b.workman_liability_coverage_amt_update(i).exists? ? b.workman_liability_coverage_amt_update(i).value : b.workman_liability_coverage_amt_readonly(i) }
  value(:workman_liability_expiration_date_new) { |i=0, b| b.workman_liability_expiration_date_update(i).exists? ? b.workman_liability_expiration_date_update(i).value : b.workman_liability_expiration_date_readonly(i) }
  value(:excess_liability_umb_amt_new) { |i=0, b| b.excess_liability_umb_amt_update(i).exists? ? b.excess_liability_umb_amt_update(i).value : b.excess_liability_umb_amt_readonly(i) }
  value(:excess_liability_umb_expiration_date_new) { |i=0, b| b.excess_liability_umb_expiration_date_update(i).exists? ? b.excess_liability_umb_expiration_date_update(i).value : b.excess_liability_umb_expiration_date_readonly(i) }
  value(:health_offset_lic_expiration_date_new) { |i=0, b| b.health_offset_lic_expiration_date_update(i).exists? ? b.health_offset_lic_expiration_date_update(i).value : b.health_offset_lic_expiration_date_readonly(i) }
  value(:insurance_note_new) { |i=0, b| b.insurance_note_update(i).exists? ? b.insurance_note_update(i).value : b.insurance_note_readonly(i) }
  value(:insurance_requirements_complete_new) { |i=0, b| b.insurance_requirements_complete_update(i).exists? ? b.insurance_requirements_complete_update(i).selected_options.first.value : b.insurance_requirements_complete_readonly(i) }
  value(:cornell_additional_ins_ind_new) { |i=0, b| b.cornell_additional_ins_ind_update(i).exists? ? b.cornell_additional_ins_ind_update(i).selected_options.first.value : b.cornell_additional_ins_ind_readonly(i) }
  value(:health_offsite_catering_lic_req_new) { |i=0, b| b.health_offsite_catering_lic_req_update(i).exists? ? b.health_offsite_catering_lic_req_update(i).selected_options.first.value : b.health_offsite_catering_lic_req_readonly(i) }
  value(:insurance_requirement_indicator_new) { |i=0, b| b.insurance_requirement_indicator_update(i).exists? ? b.insurance_requirement_indicator_update(i).value : b.insurance_requirement_indicator_readonly(i) }
  value(:default_payment_method_new) { |i=0, b| b.default_payment_method_update(i).exists? ? b.default_payment_method_update(i).selected_options.first.value : b.default_payment_method_readonly(i) }

  # old insurance
  element(:w9_received_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.vendorHeader.extension.vendorW9ReceivedDate.div').text.strip }
  element(:general_liability_coverage_amt_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.generalLiabilityCoverageAmount.div').text.strip }
  element(:general_liability_expiration_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.generalLiabilityExpiration.div').text.strip }
  element(:automobile_liability_coverage_amt_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.automobileLiabilityCoverageAmount.div').text.strip }
  element(:automobile_liability_expiration_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.automobileLiabilityExpiration.div').text.strip }
  element(:workman_liability_coverage_amt_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.workmansCompCoverageAmount.div').text.strip }
  element(:workman_liability_expiration_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.workmansCompExpiration.div').text.strip }
  element(:excess_liability_umb_amt_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.excessLiabilityUmbrellaAmount.div').text.strip }
  element(:excess_liability_umb_expiration_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.excessLiabilityUmbExpiration.div').text.strip }
  element(:health_offset_lic_expiration_date_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.healthOffSiteLicenseExpirationDate.div').text.strip }
  element(:insurance_note_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.insuranceNotes.div').text.strip }
  element(:insurance_requirements_complete_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.insuranceRequirementsCompleteIndicator.div').text.strip }
  element(:cornell_additional_ins_ind_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.cornellAdditionalInsuredIndicator.div').text.strip }
  element(:health_offsite_catering_lic_req_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.healthOffSiteCateringLicenseReq.div').text.strip }
  element(:insurance_requirement_indicator_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.insuranceRequiredIndicator.div').text.strip }
  element(:default_payment_method_old) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.defaultB2BPaymentMethodCode.div').text.strip }

  # Contract
  element(:contract_extension_option_date) { |b| b.contracts_tab.text_field(name: 'document.newMaintainableObject.add.vendorContracts.vendorContractExtensionDate') }
  alias_method :new_contract_extension_option_date, :contract_extension_option_date
  action(:contract_extension_option_date_update) { |i=0, b| b.contracts_tab.text_field(name: "document.newMaintainableObject.vendorContracts[#{i}].vendorContractExtensionDate") }
  action(:contract_extension_option_date_old) { |i=0, b| b.contracts_tab.span(id: "document.oldMaintainableObject.vendorContracts[#{i}].vendorContractExtensionDate.div").text.strip }
  value(:contract_extension_option_date_readonly) { |i=0, b| b.contracts_tab.span(id: "document.newMaintainableObject.vendorContracts[#{i}].vendorContractExtensionDate.div").text.strip }
  value(:contract_extension_option_date_new) { |i=0, b| b.contract_extension_option_date_update(i).exists? ? b.contract_extension_option_date_update(i).value : b.contract_extension_option_date_readonly(i) }

  # Address
  element(:method_of_po_transmission) { |b| b.addresses_tab.select(id: 'document.newMaintainableObject.add.vendorAddresses.extension.purchaseOrderTransmissionMethodCode') }
  alias_method :new_method_of_po_transmission, :method_of_po_transmission
  element(:method_of_po_transmission_update) { |i=0, b| b.addresses_tab.select(id: "document.newMaintainableObject.vendorAddresses[#{i}].extension.purchaseOrderTransmissionMethodCode") }
  value(:method_of_po_transmission_old) { |i=0, b| b.addresses_tab.span(id: "document.oldMaintainableObject.vendorAddresses[#{i}].extension.purchaseOrderTransmissionMethodCode.div").text.strip }
  value(:method_of_po_transmission_readonly) { |i=0, b| b.addresses_tab.span(id: "document.newMaintainableObject.vendorAddresses[#{i}].extension.purchaseOrderTransmissionMethodCode.div").text.strip }
  value(:method_of_po_transmission_new) { |i=0, b| b.method_of_po_transmission_update(i).exists? ? b.method_of_po_transmission_update(i).selected_options.first.value : b.method_of_po_transmission_readonly(i) }

  value(:vendor_address_generated_identifier) do |i=0, b|
    b.addresses_tab.span(id: "vendorAddresses[#{i}].extension.vendorAddressGeneratedIdentifier.div")
                   .text
                   .strip if b.addresses_tab
                              .span(id: "vendorAddresses[#{i}].extension.vendorAddressGeneratedIdentifier.div")
                              .exists? # This only shows up on the "Read-Only" Notes tab
  end
  alias_method :new_vendor_address_generated_identifier, :vendor_address_generated_identifier # These are auto-generated, and immutable
  alias_method :old_vendor_address_generated_identifier, :vendor_address_generated_identifier

  # Supplier Diversity
  element(:supplier_diversity_tab) { |b| b.frm.div(id: 'tab-SupplierDiversity-div') }
  value(:current_supplier_diversity_count) { |b| b.supplier_diversity_tab.spans(class: 'left', text: /Supplier Diversity [(]/m).length }
  action(:add_supplier_diversity) { |b| b.supplier_diversity_tab.button(id: /methodToCall.addLine.vendorHeader.vendorSupplierDiversities/m).click }
  action(:show_supplier_diversities_button) { |b| b.frm.button(id: 'tab-SupplierDiversity-imageToggle') }
  value(:supplier_diversities_tab_shown?) { |b| b.show_supplier_diversities_button.title.match(/close Supplier Diversity/m) }
  value(:supplier_diversities_tab_hidden?) { |b| !b.supplier_diversities_tab_shown? }
  action(:show_supplier_diversities) { |b| b.show_supplier_diversities_button.click }
  alias_method :hide_supplier_diversities, :show_supplier_diversities

  element(:supplier_diversity_type) { |b| b.supplier_diversity_tab.select(name: 'document.newMaintainableObject.add.vendorHeader.vendorSupplierDiversities.vendorSupplierDiversityCode') }
  alias_method :new_supplier_diversity_type, :supplier_diversity_type
  element(:supplier_diversity_certification_expiration_date) { |b| b.supplier_diversity_tab.text_field(name: 'document.newMaintainableObject.add.vendorHeader.vendorSupplierDiversities.extension.vendorSupplierDiversityExpirationDate') }
  alias_method :new_supplier_diversity_certification_expiration_date, :supplier_diversity_certification_expiration_date
  element(:supplier_diversity_active) { |b| b.supplier_diversity_tab.checkbox(name: 'document.newMaintainableObject.add.vendorHeader.vendorSupplierDiversities.active') }
  alias_method :new_supplier_diversity_active, :supplier_diversity_active

  # update supplier diversity
  action(:supplier_diversity_type_update) { |i=0, b|
    b.supplier_diversity_tab.select(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].vendorSupplierDiversityCode")
  }
  action(:supplier_diversity_certification_expiration_date_update) { |i=0, b|
    b.supplier_diversity_tab.text_field(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].extension.vendorSupplierDiversityExpirationDate")
  }
  action(:supplier_diversity_active_update) { |i=0, b| b.supplier_diversity_tab.checkbox(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].active") }

  # readonly supplier diversity
  value(:supplier_diversity_type_readonly) { |i=0, b|
    b.supplier_diversity_tab.span(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].vendorSupplierDiversityCode.div").text.strip
  }
  value(:supplier_diversity_certification_expiration_date_readonly) { |i=0, b|
    b.supplier_diversity_tab.span(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].extension.vendorSupplierDiversityExpirationDate.div").text.strip
  }
  value(:supplier_diversity_active_readonly) { |i=0, b| b.supplier_diversity_tab.span(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].active.div").text.strip }

  # new supplier diversity
  value(:supplier_diversity_type_new) { |i=0, b| b.supplier_diversity_type_update(i).exists? ? b.supplier_diversity_type_update(i).selected_options.first.value : b.supplier_diversity_type_readonly(i) }
  value(:supplier_diversity_certification_expiration_date_new) { |i=0, b| b.supplier_diversity_certification_expiration_date_update(i).exists? ? b.supplier_diversity_certification_expiration_date_update(i).value : b.supplier_diversity_certification_expiration_date_readonly(i) }
  value(:supplier_diversity_active_new) { |i=0, b| b.supplier_diversity_active_update(i).exists? ? b.supplier_diversity_active_update(i).value : b.supplier_diversity_active_readonly(i) }

  # old supplier diversity
  action(:supplier_diversity_type_old) { |i=0, b|
    b.supplier_diversity_tab.span(id: "document.oldMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].vendorSupplierDiversityCode.div").text.strip
  }
  action(:supplier_diversity_certification_expiration_date_old) { |i=0, b|
    b.supplier_diversity_tab.span(id: "document.oldMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].extension.vendorSupplierDiversityExpirationDate.div").text.strip
  }
  action(:supplier_diversity_active_old) { |i=0, b| b.supplier_diversity_tab.span(id: "document.oldMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].active.div").text.strip }


end
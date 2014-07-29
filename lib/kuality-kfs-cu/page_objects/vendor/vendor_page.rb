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

  element(:old_w9_received_date) { |b| b.frm.span(id: 'document.oldMaintainableObject.vendorHeader.extension.vendorW9ReceivedDate.div').text.strip }
  element(:old_general_liability_coverage_amt) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.generalLiabilityCoverageAmount.div').text.strip }
  element(:old_general_liability_expiration_date) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.generalLiabilityExpiration.div').text.strip }
  element(:old_automobile_liability_coverage_amt) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.automobileLiabilityCoverageAmount.div').text.strip }
  element(:old_automobile_liability_expiration_date) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.automobileLiabilityExpiration.div').text.strip }
  element(:old_workman_liability_coverage_amt) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.workmansCompCoverageAmount.div').text.strip }
  element(:old_workman_liability_expiration_date) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.workmansCompExpiration.div').text.strip }
  element(:old_excess_liability_umb_amt) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.excessLiabilityUmbrellaAmount.div').text.strip }
  element(:old_excess_liability_umb_expiration_date) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.excessLiabilityUmbExpiration.div').text.strip }
  element(:old_health_offset_lic_expiration_date) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.healthOffSiteLicenseExpirationDate.div').text.strip }
  element(:old_insurance_note) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.insuranceNotes.div').text.strip }
  element(:old_insurance_requirements_complete) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.insuranceRequirementsCompleteIndicator.div').text.strip }
  element(:old_cornell_additional_ins_ind) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.cornellAdditionalInsuredIndicator.div').text.strip }
  element(:old_health_offsite_catering_lic_req) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.healthOffSiteCateringLicenseReq.div').text.strip }
  element(:old_insurance_requirement_indicator) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.insuranceRequiredIndicator.div').text.strip }
  element(:old_default_payment_method) { |b| b.frm.span(id: 'document.oldMaintainableObject.extension.defaultB2BPaymentMethodCode.div').text.strip }

  # Contract
  element(:contract_extension_option_date) { |b| b.contracts_tab.text_field(name: 'document.newMaintainableObject.add.vendorContracts.vendorContractExtensionDate') }
  alias_method :new_contract_extension_option_date, :contract_extension_option_date
  action(:update_contract_extension_option_date) { |i=0, b| b.contracts_tab.text_field(name: "document.newMaintainableObject.vendorContracts[#{i}].vendorContractExtensionDate") }
  action(:old_contract_extension_option_date) { |i=0, b| b.contracts_tab.span(id: "document.oldMaintainableObject.vendorContracts[#{i}].vendorContractExtensionDate.div").text.strip }

  # Address
  element(:method_of_po_transmission) { |b| b.addresses_tab.select(id: 'document.newMaintainableObject.add.vendorAddresses.extension.purchaseOrderTransmissionMethodCode') }
  alias_method :new_method_of_po_transmission, :method_of_po_transmission
  element(:update_method_of_po_transmission) { |i=0, b| b.addresses_tab.select(id: "document.newMaintainableObject.vendorAddresses[#{i}].extension.purchaseOrderTransmissionMethodCode") }
  value(:old_method_of_po_transmission) { |i=0, b| b.addresses_tab.span(id: "document.oldMaintainableObject.vendorAddresses[#{i}].extension.purchaseOrderTransmissionMethodCode.div").text.strip }
  value(:readonly_method_of_po_transmission) { |i=0, b| b.addresses_tab.span(id: "document.newMaintainableObject.vendorAddresses[#{i}].extension.purchaseOrderTransmissionMethodCode.div").text.strip }

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

  action(:update_supplier_diversity_type) { |i=0, b|
    b.supplier_diversity_tab.span(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].vendorSupplierDiversityCode.div")
  }
  action(:update_supplier_diversity_certification_expiration_date) { |i=0, b|
    b.supplier_diversity_tab.text_field(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].extension.vendorSupplierDiversityExpirationDate")
  }
  action(:update_supplier_diversity_active) { |i=0, b| b.supplier_diversity_tab.checkbox(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].active") }

  action(:old_supplier_diversity_type) { |i=0, b|
    b.supplier_diversity_tab.span(id: "document.oldMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].vendorSupplierDiversityCode.div").text.strip
  }
  action(:old_supplier_diversity_certification_expiration_date) { |i=0, b|
    b.supplier_diversity_tab.span(id: "document.oldMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].extension.vendorSupplierDiversityExpirationDate.div").text.strip
  }
  action(:old_supplier_diversity_active) { |i=0, b| b.supplier_diversity_tab.span(id: "document.oldMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].active.div").text.strip }


end
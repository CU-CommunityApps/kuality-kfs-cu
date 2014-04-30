#overriding kuality-kfs object
class VendorPage

  element(:w9_received_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.vendorHeader.extension.vendorW9ReceivedDate') }
  element(:general_liability_coverage_amt) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.generalLiabilityCoverageAmount') }
  element(:general_liability_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.generalLiabilityExpiration') }
  element(:automobile_liability_coverage_amt) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.automobileLiabilityCoverageAmount') }
  element(:automobile_liability_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.automobileLiabilityExpiration') }
  element(:workman_liability_coverage_amt) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.workmansCompCoverageAmount') }
  element(:workman_liability_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.workmansCompExpiration') }
  element(:excess_liability_umb_amt) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.excessLiabilityUmbrellaAmount') }
  element(:excess_liability_umb_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.excessLiabilityUmbExpiration') }
  element(:health_offset_lic_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.healthOffSiteLicenseExpirationDate') }
  element(:insurance_note) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.insuranceNotes') }
  element(:insurance_requirements_complete) { |b| b.frm.select(name: 'document.newMaintainableObject.extension.insuranceRequirementsCompleteIndicator') }
  element(:cornell_additional_ins_ind) { |b| b.frm.select(name: 'document.newMaintainableObject.extension.cornellAdditionalInsuredIndicator') }
  element(:health_offsite_catering_lic_req) { |b| b.frm.select(name: 'document.newMaintainableObject.extension.healthOffSiteCateringLicenseReq') }
  element(:contract_extension_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.vendorContracts.vendorContractExtensionDate') }
  element(:insurance_requirement_indicator) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.extension.insuranceRequiredIndicator') }
  element(:default_payment_method) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.defaultB2BPaymentMethodCode') }

  # Address
  element(:method_of_po_transmission) { |b| b.frm.select(name: 'document.newMaintainableObject.add.vendorAddresses.extension.purchaseOrderTransmissionMethodCode') }
  element(:update_method_of_po_transmission) { |i=0, b| b.frm.select(name: "document.newMaintainableObject.vendorAddresses[#{i}].extension.purchaseOrderTransmissionMethodCode") }

  # Supplier Diversity
  action(:add_supplier_diversity) { |b| b.frm.button(id: /methodToCall.addLine.vendorHeader.vendorSupplierDiversities/m).click }
  action(:show_supplier_diversities) { |b| b.frm.button(name: 'methodToCall.toggleTab.tabSupplierDiversity').click }

  element(:new_supplier_diversity_type) { |b| b.frm.select(name: 'document.newMaintainableObject.add.vendorHeader.vendorSupplierDiversities.vendorSupplierDiversityCode') }
  alias_method :supplier_diversity, :new_supplier_diversity_type
  element(:new_supplier_diversity_certification_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.vendorHeader.vendorSupplierDiversities.extension.vendorSupplierDiversityExpirationDate') }
  alias_method :supplier_diversity_expiration_date, :new_supplier_diversity_certification_expiration_date
  element(:new_supplier_diversity_active) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.add.vendorHeader.vendorSupplierDiversities.active') }

  action(:update_supplier_diversity_type) { |i=0, b| b.frm.div(id: 'tab-SupplierDiversity-div').span(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].vendorSupplierDiversityCode.div") }
  value(:supplier_diversity_code_1) { |b| b.update_supplier_diversity_type(0).text }

  action(:update_supplier_diversity_certification_expiration_date) { |i=0, b| b.frm.div(id: 'tab-SupplierDiversity-div').text_field(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].extension.vendorSupplierDiversityExpirationDate") }
  action(:update_supplier_diversity_active) { |i=0, b| b.frm.div(id: 'tab-SupplierDiversity-div').checkbox(id: "document.newMaintainableObject.vendorHeader.vendorSupplierDiversities[#{i}].active") }

  action(:pull_existing_supplier_diversity) do |i=0, b|
    {
        type:   b.update_supplier_diversity_type(i).text.strip,
        certification_expiration_date:   b.update_supplier_diversity_certification_expiration_date(i).value.strip,
        active: yesno2setclear(b.update_supplier_diversity_active(i).value.strip)
    }
  end
  value(:current_supplier_diversity_count) { |b| b.frm.div(id: 'tab-SearchAlias-div').spans(class: 'left', text: /Supplier Diversity [(]/m).length }

end
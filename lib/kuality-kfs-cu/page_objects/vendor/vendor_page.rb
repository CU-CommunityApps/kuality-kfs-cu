#overriding kuality-kfs object
class VendorPage

  element(:w9_received_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.vendorHeader.extension.vendorW9ReceivedDate') }
  element(:supplier_diversity_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.vendorHeader.vendorSupplierDiversities.extension.vendorSupplierDiversityExpirationDate') }
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

end
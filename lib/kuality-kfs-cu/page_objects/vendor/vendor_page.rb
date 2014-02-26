#overriding kuality-kfs object
class VendorPage

  element(:w9_received_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.vendorHeader.extension.vendorW9ReceivedDate') }

  element(:supplier_diversity_expiration_date) { |b| b.frm.text_field(name: 'document.newMaintainableObject.add.vendorHeader.vendorSupplierDiversities.extension.vendorSupplierDiversityExpirationDate') }

  element(:method_of_po_trasmission) { |b| b.frm.select(name: 'document.newMaintainableObject.add.vendorAddresses.extension.purchaseOrderTransmissionMethodCode') }

end
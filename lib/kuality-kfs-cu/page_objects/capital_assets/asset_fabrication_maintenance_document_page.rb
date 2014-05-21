class AssetFabricationMaintenanceDocumentPage < KFSBasePage

  element(:service_rate_indicator) { |b| b.frm.text_field(name: 'document.newMaintainableObject.extension.serviceRateIndicator') }


end
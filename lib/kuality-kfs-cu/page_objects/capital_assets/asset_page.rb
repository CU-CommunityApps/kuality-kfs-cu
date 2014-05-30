class AssetPage < KFSBasePage

  element(:service_rate_indicator) { |b| b.frm.checkbox(name: 'document.newMaintainableObject.extension.serviceRateIndicator') }

end
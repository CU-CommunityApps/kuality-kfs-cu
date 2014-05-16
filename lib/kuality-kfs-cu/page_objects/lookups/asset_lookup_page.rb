class AssetLookupPage < Lookups


  element(:service_rate_indicator_yes) { |b| b.frm.radio(id: 'extension.serviceRateIndicatorYes') }
  element(:service_rate_indicator_no) { |b| b.frm.radio(id: 'extension.serviceRateIndicatorNo') }
  element(:service_rate_indicator_both) { |b| b.frm.radio(id: 'extension.serviceRateIndicatorBoth') }


end
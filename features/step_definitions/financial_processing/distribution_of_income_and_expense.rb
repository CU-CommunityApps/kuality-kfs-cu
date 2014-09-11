And /^I add a tag and location for Capital Asset$/ do
  on(DistributionOfIncomeAndExpensePage).vendor_search
  vendor_num = get_aft_parameter_value(ParameterConstants::REQS_NONB2B_VENDOR)

  on VendorLookupPage do |page|
    page.vendor_number.wait_until_present
    page.vendor_number.fit vendor_num
    page.search
    page.return_value(vendor_num)
  end
  on DistributionOfIncomeAndExpensePage do |page|
    page.capital_asset_qty.fit '1'
    page.capital_asset_type.fit '019'
    page.capital_asset_manufacturer.fit 'CA manufacturer'
    page.capital_asset_description.fit random_alphanums(40, 'AFT')
    page.insert_tag

    page.use_new_tab
    page.close_parents
    page.tag_number.fit random_alphanums(8, 'T')
    page.capital_asset_campus.fit get_aft_parameter_value(ParameterConstants::DEFAULT_CAMPUS_CODE)
    page.capital_asset_building.fit '7000'
    page.capital_asset_room.fit 'XXXXXXXX'
  end
end
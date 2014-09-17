And /^I add a tag and location for Capital Asset$/ do
  on(CapitalAssetsTab).vendor_search
  vendor_num = get_aft_parameter_value(ParameterConstants::REQS_NONB2B_VENDOR)

  on VendorLookupPage do |page|
    page.vendor_number.wait_until_present
    page.vendor_number.fit vendor_num
    page.search
    page.return_value(vendor_num)
  end

  on CapitalAssetsTab do |tab|
    tab.insert_tag
    tab.tag_number.fit random_alphanums(8, 'T')
    tab.campus.fit 'IT - Ithaca'
    tab.building.fit '7000'
    tab.room.fit 'XXXXXXXX'
  end
  @distribution_of_income_and_expense.update_line_objects_from_page!
end

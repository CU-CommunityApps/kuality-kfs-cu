And /^I create a Asset Fabrication Maintenance Document$/ do
  @asset_fabrication_maintenance_document = create AssetFabricationMaintenanceDocumentObject, organization_owner_chart_of_accounts_code: 'IT',
                                                   asset_condition: 'Good',
                                                   asset_description: random_alphanums(20, 'AFT'),
                                                   asset_type_code: '40000',
                                                   on_campus_campus: 'IT',
                                                   estimated_fabrication_completion_date: '05/16/2014',
                                                   fabrication_estimated_total_amount: '100',
                                                   years_expected_to_retain_asset_once_fabrication_is_complete: '1',
                                                   on_campus_building_code: '1003',
                                                   on_campus_building_room_number: '100CC'
end

And /^I create a Pre Asset Tagging Document$/ do
  @pre_asset_tagging = create PreAssetTaggingObject, purchase_order_number: '1234',
                              item_line_number: '1',
                              quantity_ordered: '1',
                              asset_type_code: 'Artwork',
                              manufacturer_name: 'test',
                              vendor_name: 'test',
                              organization_owner_chart_of_accounts_code: 'IT - Ithaca Campus',
                              organization_owner_organization_code: '01C3',
                              purchase_order_line_item_description: 'Test po descript'


end


And /^I create a Asset Manual Payment Document$/ do
  @asset_manual_payment = create AssetManualPaymentObject

end



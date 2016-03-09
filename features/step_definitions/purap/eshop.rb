# And /^I search for an e\-SHOP item with a (Non\-Sensitive|Sensitive) Commodity Code$/ do |item_type|
#   case item_type
#     when 'Non-Sensitive'
#       on EShopCatalogPage do |page|
#         page.choose_supplier                         'Staples'
#         page.supplier_search_box('Staples').when_present.fit 'Paper, PASTELS 8.5X11 BLUE PAPER RM'
#         page.supplier_search('Staples')
#       end
#     when 'Sensitive'
#       on EShopCatalogPage do |page|
#         page.choose_supplier                         'QIAGEN, Inc.'
#         page.supplier_search_box('QIAGEN, Inc.').when_present.fit 'Tetanus toxin from Clostridium tetani'
#         page.supplier_search('QIAGEN, Inc.')
#       end
#     else
#       pending "Item Type: #{item_type} is not handled for e-Shop item search"
#   end
# end


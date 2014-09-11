And /^I search for an e\-SHOP item with a Non\-Sensitive Commodity Code$/ do
  on EShopCatalogPage do |page|
    page.choose_hosted_supplier                         'Staples'
    page.hosted_supplier_item_search_box('Staples').fit 'Paper, PASTELS 8.5X11 BLUE PAPER RM'
    page.hosted_supplier_item_search                    'Staples'
  end
end

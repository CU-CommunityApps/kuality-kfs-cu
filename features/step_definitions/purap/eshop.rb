And /^I search for an e\-SHOP item with a Non\-Sensitive Commodity Code$/ do
  on ShopCatalogPage do |page|
    page.choose_hosted_supplier                         'Staples'
    page.hosted_supplier_item_search_box('Staples').fit 'Paper, PASTELS 8.5X11 BLUE PAPER RM'
    page.hosted_supplier_item_search                    'Staples'
  end
end

And /^I add e\-SHOP items to my cart until the cart total reaches the Business to Business Total Amount For Automatic Purchase Order limit$/ do
  on ShopResultsPage do |page|
    target_quantity = ((get_parameter_values('KFS-PURAP', 'B2B_TOTAL_AMOUNT_FOR_AUTO_PO', 'Requisition').first.to_f -
                        page.cart_total_value.to_f) /
                        21.26).ceil
    target_quantity.should be > 0, 'There are already one or more items in your shopping cart such that we cannot add an additional item!'
    page.item_quantity(0).fit target_quantity
    page.add_item(0)
    page.cart_total_value.to_f.should be >= get_parameter_values('KFS-PURAP', 'B2B_TOTAL_AMOUNT_FOR_AUTO_PO', 'Requisition').first.to_f
    page.cart_total_value.to_f.should be < get_parameter_values('KFS-PURAP', 'B2B_TOTAL_AMOUNT_FOR_SUPER_USER_AUTO_PO', 'Requisition').first.to_f
  end
end

And /^I add a note to my e\-SHOP cart$/ do
  # You must already be in the e-SHOP section of KFS
  on(EShopPage).goto_cart
  on(ShopCartPage).add_note_to_cart 'Wow! That is a sweet note, you might say!'
  on(ShopCartPage).cart_status_message.should == 'Cart was saved successfully'
end

And /^I submit my e\-SHOP cart$/ do
  pending 'Need to figure out how to actually submit an e-SHOP cart'
end

Then /^Payment Request Positive Approval Required is checked$/ do
  pending 'Need to figure out where I go to check if a Payment Request Positive Approval Required message is checked'
end

And /^the e\-SHOP cart has an associated Requisition document$/ do
  pending 'Need to figure out how to verify if an e-SHOP cart has spawned a REQ'
end

When /^I go to the e\-SHOP main page$/ do
  visit(MainPage).e_shop
end
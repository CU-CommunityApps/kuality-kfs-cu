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
  @eshop_cart.add_note 'Wow! That is a sweet note, you might say!'
end

And /^I submit my e\-SHOP cart$/ do
  # We're assuming you're already on the e-SHOP cart page here.
  @eshop_cart.submit

  # Surprise! This should kick you out to a Requisition document.
  on(RequisitionPage).doc_title.strip.should == 'Requisition'
  @requisition = make RequisitionObject
  pending 'Gotta write RequisitionObject#absorb!'
  # @requisition.absorb :new # Hopefully, we can #absorb this mutha
end

Then /^Payment Request Positive Approval Required is checked$/ do
  # TODO: Convert this to using @requisition
  on(RequisitionPage).payment_request_positive_approval_required.checked?.should
end

And /^the e\-SHOP cart has an associated Requisition document$/ do
  # You need to have to have already pulled up the Req doc, naturally
  @requisition.description.should == @eshop_cart.cart_name
end

When /^I go to the e\-SHOP main page$/ do
  visit(MainPage).e_shop
end

When /^I view my e\-SHOP cart$/ do
  # We're going to assume you want to update this guy
  # if you're checking out your cart...
  @eshop_cart = make EShopCartObject if @eshop_cart.nil?
  @eshop_cart.view # This assumes you're at least in the e-SHOP, naturally
  @eshop_cart.absorb!
end
And /^I search for an e\-SHOP item with a Non\-Sensitive Commodity Code$/ do
  on EShopCatalogPage do |page|
    page.choose_hosted_supplier                         'Staples'
    page.hosted_supplier_item_search_box('Staples').fit 'Paper, PASTELS 8.5X11 BLUE PAPER RM'
    page.hosted_supplier_item_search                    'Staples'
  end
end

And /^I add e\-SHOP items to my cart until the cart total reaches the Business to Business Total Amount For Automatic Purchase Order limit$/ do
  on ShopResultsPage do |page|
    item = 0
    target_value = page.price_for_item item
    target_quantity = ((get_parameter_values('KFS-PURAP', 'B2B_TOTAL_AMOUNT_FOR_AUTO_PO', 'Requisition').first.to_f -
                        page.cart_total_value.to_f) /
                        target_value).ceil
    target_quantity.should be > 0, 'There are already one or more items in your shopping cart such that we cannot add an additional item!'
    page.item_quantity(item).fit target_quantity
    page.add_item item
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
  @requisition.absorb! :new
end

Then /^Payment Request Positive Approval Required is (not required|required)$/ do |is_required|
  if is_required == 'required'
    @requisition.payment_request_positive_approval_required.set?.true?.should
    on(RequisitionPage).result_payment_request_positive_approval_required.should == 'Yes'
  else
    @requisition.payment_request_positive_approval_required.set?.false?.should
    on(RequisitionPage).result_payment_request_positive_approval_required.should == 'No'
  end
end

And /^the e\-SHOP cart has an associated Requisition document$/ do
  # You need to have to have already pulled up the Req doc, naturally
  @requisition.description.should == @eshop_cart.cart_name
end

When /^I go to the e\-SHOP main page$/ do
  visit(MainPage).e_shop
  on EShopPage do |page|
    if page.announcements_block.exists?
      page.clear_announcement
      page.goto_home
    end
  end
end

When /^I view my e\-SHOP cart$/ do
  # We're going to assume you want to update this guy
  # if you're checking out your cart...
  @eshop_cart = make EShopCartObject if @eshop_cart.nil?
  @eshop_cart.view # This assumes you're at least in the e-SHOP, naturally
  @eshop_cart.absorb!
end

When /^I clear my e\-SHOP cart$/ do
  @eshop_cart.clear_items
end

Given /^I initiate an e\-SHOP order$/ do
  step 'I am logged in as an e-SHOP Plus User'
  step 'I go to the e-SHOP main page'
  step 'I view my e-SHOP cart'
  step 'I clear my e-SHOP cart'
  step 'I go to the e-SHOP main page'
  step 'I search for an e-SHOP item with a Non-Sensitive Commodity Code'
  step 'I add e-SHOP items to my cart until the cart total reaches the Business to Business Total Amount For Automatic Purchase Order limit'
  step 'I view my e-SHOP cart'
  step 'I add a note to my e-SHOP cart'
  step 'I submit my e-SHOP cart'
  step 'I add a random address to the Delivery tab on the Requisition document'
  step 'I add a random Requestor Phone number to the Requisition document'
  step 'I add these Accounting Lines to Item #1 on the Requisition document:',
    table(%q{
            | Chart Code | Account Number       | Object Code | Amount |
            | Default    | Unrestricted Account | Expenditure | 10     |
          })
  step 'I add an attachment to the Requisition document'
  step 'I add a file attachment to the Notes and Attachment Tab of the Requisition document'
  step 'I calculate the Requisition document'
  step 'I submit the Requisition document'
  step 'the document should have no errors'
  step 'I reload the Requisition document'
  step 'Payment Request Positive Approval Required is required'
end


And /^I search for an e\-SHOP item with a Sensitive Commodity Code$/ do
  on EShopCatalogPage do |page|
    page.choose_hosted_supplier                         'PerkinElmer Life and Analytical Sciences'
    page.hosted_supplier_item_search_box('PerkinElmer Life and Analytical Sciences').fit 'Iodine'
    page.hosted_supplier_item_search                    'PerkinElmer Life and Analytical Sciences'
  end
end

And /^I add over \$(.*) worth of e\-SHOP items to my cart$/ do |amount|
  on ShopResultsPage do |page|
    item = 0
    target_value = page.price_for_item item
    target_quantity = amount.to_f / target_value
    puts target_quantity.ceil
    page.item_quantity(item).fit target_quantity.ceil
    page.add_item item
  end
end

And	 /^I change to Capital Asset object code$/ do
  on(RequisitionPage).expand_all
  on(ItemsTab).update_object_code.fit fetch_random_capital_asset_object_code
end

And /^the Vendor Choice is populated$/ do
  !on(PurchaseOrderPage).result_vendor_choice.empty?.should
end

And /^I can not search and retrieve the Payment Request document$/ do
  visit(MainPage).payment_requests
  on DocumentSearch do |page|
    page.document_id.fit @payment_request.document_id
    page.search
    step 'I should get an error saying "1 rows were filtered for security purposes."'
  end

end

Then /^I verify future action requests contain: (.*)$/  do |routing_annotations|
  on KFSBasePage do |page|
    ras = routing_annotations.gsub(', and ','').split(",")
    page.expand_all
    page.pnd_act_req_table.rows(text: /APPROVE/m).any? { |r| r.text.include? ras[0] }.should
    ras.shift
    page.show_future_action_requests if page.show_future_action_requests_button.exists?
    ras.each do |ra|
      page.future_actions_table.rows(text: /APPROVE/m).any? { |r| r.text.include? ra.lstrip }.should
    end
  end

end

And /^I verify that the following (Pending|Future) Action approvals are requested:$/ do |action_type, roles|
  roles = roles.raw.flatten
  on KFSBasePage do |page|
    page.expand_all
    case action_type
      when 'Pending'
        roles.each do |ra|
          page.pnd_act_req_table.rows(text: /APPROVE/m).any? { |r| r.text.include? ra }.should
        end
      when 'Future'
              page.show_future_action_requests if page.show_future_action_requests_button.exists?
              roles.each do |ra|
                page.future_actions_table.rows(text: /APPROVE/m).any? { |r| r.text.include? ra }.should
              end
    end
   end

end
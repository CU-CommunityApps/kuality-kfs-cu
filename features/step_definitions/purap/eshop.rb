And /^I search for an e\-SHOP item with a (Non\-Sensitive|Sensitive) Commodity Code$/ do |item_type|
  case item_type
    when 'Non-Sensitive'
      on EShopCatalogPage do |page|
        page.choose_supplier                         'Staples'
        page.supplier_search_box('Staples').when_present.fit 'Paper, PASTELS 8.5X11 BLUE PAPER RM'
        page.supplier_search('Staples')
      end
    when 'Sensitive'
      on EShopCatalogPage do |page|
        page.choose_supplier                         'QIAGEN, Inc.'
        page.supplier_search_box('QIAGEN, Inc.').when_present.fit 'Tetanus toxin from Clostridium tetani'
        page.supplier_search('QIAGEN, Inc.')
      end
    else
      pending "Item Type: #{item_type} is not handled for e-Shop item search"
  end
end


And /^I add e\-SHOP items to my cart with a value of at least (\d*)$/ do  |min_amount|
  on ShopResultsPage do |page|
    item = 0
    target_value = page.price_for_item item
    target_quantity = ((min_amount.to_f - page.cart_total_value.to_f )/target_value).ceil

    target_quantity.should be > 0, 'There are already one or more items in your shopping cart such that we cannot add an additional item!'
    page.item_quantity(item).fit target_quantity
    page.add_item item
  end
end

Given  /^I create an e-SHOP Requisition document with a (.*) item type$/ do |item_type|
  step 'I am logged in as an e-SHOP User'
  step 'I go to the e-SHOP main page'
  step "I search for an e-SHOP item with a #{item_type} Commodity Code"
  step 'I add e-SHOP items to my cart until the cart total reaches the Business to Business Total Amount For Automatic Purchase Order limit'
  step 'I view my e-SHOP cart'
  step 'I add a note to my e-SHOP cart'
  step 'I submit my e-SHOP cart'
  step 'I add a random address to the Delivery tab on the Requisition document'
  step 'I add a random Requestor Phone number to the Requisition document'
  step 'I capture the Requisition document id number'
end

Given  /^I create an e-SHOP Requisition document with a (.*) item type that is at least (.*) in value$/ do |item_type, min_cart_value|
  step 'I am logged in as an e-SHOP User'
  step 'I go to the e-SHOP main page'
  step "I search for an e-SHOP item with a #{item_type} Commodity Code"
  step "I add e-SHOP items to my cart with a value of at least #{min_cart_value}"
  # step 'I add e-SHOP items to my cart until the cart total reaches the Business to Business Total Amount For Automatic Purchase Order limit'
  step 'I view my e-SHOP cart'
  step 'I add a note to my e-SHOP cart'
  step 'I submit my e-SHOP cart'
  step 'I add a random address to the Delivery tab on the Requisition document'
  step 'I add a random Requestor Phone number to the Requisition document'
end

When /^I route the e-SHOP Requisition document through SciQuest until the Payment Request document is ENROUTE$/ do
  step 'I add these Accounting Lines to Item #1 on the Requisition document:',
       table(%q{
        | chart_code | account_number       | object_code | percent |
        | Default    | Unrestricted Account | Expenditure | 100     |
  })
  step 'I select the Payment Request Positive Approval Required'
  step 'I add a random delivery address to the Requisition document if there is not one present'
  step 'I add a random phone number to the Requestor Phone on the Requisition document'
  step 'I calculate the Requisition document'
  step 'I submit the Requisition document'
  step 'the Requisition document goes to ENROUTE'
  step 'I switch to the user with the next Pending Action in the Route Log to approve Requisition document to Final'
  step 'the Requisition document goes to FINAL'
  step 'I extract the Requisition document to SciQuest'
  step 'I submit a Payment Request document to ENROUTE'
end



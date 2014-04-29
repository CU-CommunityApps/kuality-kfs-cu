
Given  /^I INITIATE A REQS with following:$/ do |table|
  arguments = table.rows_hash
  step "I login as a PURAP eSHop user"
  # TODO : more work here to get all the parameters right
  #vendor_number = get_aft_parameter_value(arguments['Vendor Type'])
  @vendor_number = '27015-0' #external vendor
  #@vendor_number = '39210-0' #foreign vendor
  #commodity_code = get_aft_parameter_value((arguments['Commodity Code'].nil? ? 'REGULAR' : arguments['Commodity Code'].upcase)+"_COMMODITY")
  #commodity_code = '12142203' # sensitive
  commodity_code = '14111703'  # regular
  #account_number = get_aft_parameter_value(arguments['Account Type']) # from service or parameter
  account_number = '1278003' # this is grant
  #account_number = '1093603' # department account ?
  #apo_amount = get_parameter_value('KFS-PURAP', 'AUTOMATIC_PURCHASE_ORDER_DEFAULT_LIMIT_AMOUNT').to_i
  apo_amount = 10000
  #apo_amount = 500000
  apo_op = arguments['APO']
  item_qty = 1
  if (apo_op.nil? || apo_op == 'LT')
    item_qty = apo_amount/1000 - 1
  else
    item_qty = apo_amount/1000 + 1
  end
  object_code = 6540
  step "I create the Requisition document with:", table(%{
      | Vendor Number       | #{@vendor_number}   |
      | Item Quantity       | #{item_qty}        |
      | Item Cost           | 1000               |
      | Item Commodity Code | #{commodity_code}  |
      | Account Number      | #{account_number}  |
      | Object Code         | #{object_code}     |
      | Percent             | 100                |
  })
  steps %Q{ And I add an Attachment to the Requisition document
            And I enter Delivery Instructions and Notes to Vendor

            And  I calculate my Requisition document
            And  I submit the Requisition document
            Then the Requisition document goes to ENROUTE

            And  I switch to the user with the next Pending Action in the Route Log to approve Requisition document to Final
            Then the Requisition document goes to FINAL
            And  users outside the Route Log can not search and retrieve the REQS
}
end


And /^users outside the Route Log can not search and retrieve the REQS$/ do
  step "I am logged in as \"mrw258\"" # TODO : need a better way to figure out who can't view REQS
  visit(MainPage).requisitions
  on DocumentSearch do |page|
    page.document_id.fit @requisition.document_id
    #page.document_id.fit '5358712'
    page.search
    if !page.lookup_div.parent.text.include?('No values match this search.')
      # if search found, then can not open
      page.open_item(@requisition.document_id)
      step "I should get an Authorization Exception Report error"
    end
  end

end

And /^I EXTRACT THE REQS TO SQ$/ do

  steps %Q{  And I am logged in as a Purchasing Processor
             And I submit a Contract Manager Assignment of '10' for the Requisition
             And I am logged in as a PURAP Contract Manager
             And I retrieve the Requisition document
             And the View Related Documents Tab PO Status displays
             And the Purchase Order Number is unmasked
             And I Complete Selecting Vendor #{@vendor_number}
             And I enter a Vendor Choice of 'Lowest Price'
             And I calculate and verify the GLPE tab
             And I submit the Purchase Order document
        }
  step "the Purchase Order document goes to one of the following statuses:", table(%{
      | ENROUTE   |
      | FINAL     |
    })
  steps %Q{  And  I switch to the user with the next Pending Action in the Route Log to approve Purchase Order document to Final
             And the Purchase Order document goes to FINAL
             Then in Pending Action Requests an FYI is sent to FO and Initiator
             And the Purchase Order Doc Status is Open
             Given I am logged in as "db18"
             And   I visit the "e-SHOP" page
             And   I view the Purchase Order document via e-SHOP
             Then  the Document Status displayed 'Completed'
             And   the Delivery Instructions displayed equals what came from the PO
             And   the Attachments for Supplier came from the PO
             }
end

When /^I INITIATE A PREQS$/ do
  steps %Q{
    Given I login as a Accounts Payable Processor to create a PREQ
    And   I fill out the PREQ initiation page and continue
    And   I change the Remit To Address
    And   I enter the Qty Invoiced and calculate
    And   I enter a Pay Date
    And   I attach an Invoice Image
    And   I calculate PREQ
    And   I submit the Payment Request document
    And   the Payment Request document goes to ENROUTE
    And   I switch to the user with the next Pending Action in the Route Log to approve Payment Request document to Final
    And   the Payment Request document goes to FINAL
    And   the Payment Request Doc Status is Department-Approved
    And   the Payment Request document's GLPE tab shows the Requisition document submissions
  }
end
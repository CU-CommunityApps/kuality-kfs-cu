
Given  /^I INITIATE A REQS with following:$/ do |table|
  arguments = table.rows_hash
  step "I login as a PURAP eSHop user"
  # TODO : more work here to get all the parameters right
  if arguments['Vendor Type'].nil? || arguments['Vendor Type'] != 'Blank'
    #@vendor_number = get_aft_parameter_value('REQS_' + (arguments['Vendor Type'].nil? ? 'NONB2B' : arguments['Vendor Type'].upcase) + '_VENDOR')
     @vendor_number = '27015-0' #NonB2B
    #@vendor_number = '39210-0' #foreign vendor
  end
  add_vendor = arguments['Add Vendor On REQS'].nil? ? 'Yes' : arguments['Vendor Type']
  positive_approve = arguments['Positive Approval'].nil? ? 'Unchecked' : arguments['Positive Approval']
   #commodity_code = get_aft_parameter_value('REQS_' + (arguments['Commodity Code'].nil? ? 'REGULAR' : arguments['Commodity Code'].upcase)+"_COMMODITY")
  commodity_code = '10100000' # sensitive
  #commodity_code = '14111703'  # regular
  #account_number = get_aft_parameter_value('REQS_' + (arguments['Account Type'].nil? ? 'NONGRANT' : arguments['Account Type'].upcase) + '_ACCOUNT') # from service or parameter
  #account_number = '1278003' # this is grant
  account_number = '1093603' # nongrant account ?
  #apo_amount = get_parameter_values('KFS-PURAP', 'AUTOMATIC_PURCHASE_ORDER_DEFAULT_LIMIT_AMOUNT', 'Requisition')[0].to_i
   apo_amount = 10000
  amount = arguments['Amount']
  item_qty = 1
  if amount.nil? || amount == 'LT APO'
    item_qty = apo_amount/1000 - 1
  else
    case amount
      when 'GT APO'
        item_qty = apo_amount/1000 + 1
      else
        item_qty = amount.to_i/1000 + 1
    end
  end
  # so far it used 6540, 6560, 6570 which are all EX type (Expense Expenditure)
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
  if !@vendor_number.nil? && add_vendor == 'Yes'
    @requisition.add_vendor_to_req(@vendor_number)
  end
  if positive_approve == 'Checked'
    step  "I select the Payment Request Positive Approval Required"
  end
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

Then /^I FORMAT AND PROCESS THE CHECK WITH PDP$/ do
  #purap batch
  steps %Q{
    Given I am logged in as a KFS Operations
    And   I run Auto Approve PREQ
    And   I extract Electronic Invoices
    And   I extract Regular PREQS to PDP for Payment
    And   I extract Immediate PREQS to PDP for Payment
    And   I close POS wtih Zero Balanecs
    And   I load PREQ into PDP
  }
  # format checks
  steps %Q{
    Given I Login as a PDP Format Disbursement Processor
    And   I format Disbursement
}
    #And   I select continue on Format Disbursement Summary
    #And   a Format Summary Lookup displays
  #}

  # generate output files batch jobs
  steps %Q{
    And   I generate the ACH XML File
    And   I generate the Check XML File
    And   I generate the Cancelled Check XML File
    And   I send EMAIL Notices to ACH Payees
    And   I process Cancels and Paids
    And   I generate the GL Files from PDP
    And   I populate the ACH Bank Table
    And   I clear out PDP Temporary Tables
 }
end


And /^I format Disbursement$/ do
  on MaintenancePage do |page|
    visit(MaintenancePage).format_checks_ach
  end

  on FormatDisbursementPage do |page|
    page.payment_date.set right_now[:date_w_slashes]
    page.all_payment_type.set
    page.all_payment_distribution.set
    puts 'fields set'
    page.customer_boxes.each {|check_box| check_box.checked? ? nil : check_box.click }
    puts 'customer checked'
    page.begin_format
    sleep 20
  end
end

And /^I select continue on Format Disbursement Summary$/ do
  on(FormatDisbursementSummaryPage).continue_format
  # this will take a while
  sleep 60
end

And /^a Format Summary Lookup displays$/ do
  # TODO : not sure what to check
  on FormatSummaryLookupPage do |page|

  end
end

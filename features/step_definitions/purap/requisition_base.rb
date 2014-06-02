Given  /^I initiate a Requisition document with the following:$/ do |table|
  arguments = table.rows_hash

  step 'I login as a KFS user to create an REQS'

  # TODO : more work here to get all the parameters right
  if arguments['Vendor Type'].nil? || arguments['Vendor Type'] != 'Blank'
    @vendor_number = get_aft_parameter_value('REQS_' + (arguments['Vendor Type'].nil? ? 'NONB2B' : arguments['Vendor Type'].upcase) + '_VENDOR')
  end
  @add_vendor_on_reqs = arguments['Add Vendor On REQS'].nil? ? 'Yes' : arguments['Add Vendor On REQS']
  positive_approve = arguments['Positive Approval'].nil? ? 'Unchecked' : arguments['Positive Approval']
  commodity_code = get_aft_parameter_value('REQS_' + (arguments['Commodity Code'].nil? ? 'REGULAR' : arguments['Commodity Code'].upcase)+"_COMMODITY")
  account_number = get_aft_parameter_value('REQS_' + (arguments['Account Type'].nil? ? 'NONGRANT' : arguments['Account Type'].upcase) + '_ACCOUNT') # from service or parameter
  apo_amount = get_parameter_values('KFS-PURAP', 'AUTOMATIC_PURCHASE_ORDER_DEFAULT_LIMIT_AMOUNT', 'Requisition')[0].to_i
  amount = arguments['Amount']
  @level = arguments['Level'].nil? ? 0 : arguments['Level'].to_i
  @sensitive_commodity = !arguments['Commodity Code'].nil? && arguments['Commodity Code'] == 'Sensitive'
  @commodity_review_routing_check = !arguments['Routing Check'].nil? && arguments['Routing Check'] == 'Commodity'
  @org_review_routing_check = @level > 0 && !arguments['Routing Check'].nil? && arguments['Routing Check'] == 'Base Org'
  item_qty = 1

  if amount.nil? || amount == 'LT APO'
    item_qty = apo_amount/1000 - 1
  else
    if amount == 'GT APO'
        item_qty = apo_amount/1000 + 1
    else
        item_qty = amount.to_i/1000
    end
  end

  # so far it used 6540, 6560, 6570 which are all EX type (Expense Expenditure)
  object_code = 6540
  step 'I create the Requisition document with:',
       table(%Q{
         | Vendor Number       | #{@vendor_number}  |
         | Item Quantity       | #{item_qty}        |
         | Item Cost           | 1000               |
         | Item Commodity Code | #{commodity_code}  |
         | Account Number      | #{account_number}  |
         | Object Code         | #{object_code}     |
         | Percent             | 100                |
       })

  if !@vendor_number.nil? && @add_vendor_on_reqs == 'Yes'
    @requisition.add_vendor_to_req(@vendor_number)
  end

  step 'I select the Payment Request Positive Approval Required' if positive_approve == 'Checked'

  steps %q{
    When I add an Attachment to the Requisition document
    And  I enter Delivery Instructions and Notes to Vendor

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
    sleep 2
    unless page.lookup_div.parent.text.include?('No values match this search.')
      # if search found, then can not open
      page.open_item(@requisition.document_id)
      step 'I should get an Authorization Exception Report error'
    end
  end

end

And /^I extract the Requisition document to SciQuest$/ do
  steps %q{
    Given I am logged in as a Purchasing Processor
    And   I retrieve the Requisition document
    When  I check Related Documents Tab on Requisition Document
  }

  if !@auto_gen_po.nil? && !@auto_gen_po
   step 'I assign Contract Manager and approve Purchase Order Document to FINAL'
  end

  steps %Q{
    Given I am logged in as "db18"
    When  I visit the "e-SHOP" page
    And   I view the Purchase Order document via e-SHOP
    Then  the Document Status displayed 'Completed'
    And   the Delivery Instructions displayed equals what came from the PO
    And   the Attachments for Supplier came from the PO
  }
end

And /^I assign Contract Manager and approve Purchase Order Document to FINAL$/ do

  steps %Q{
    Given I am logged in as a Purchasing Processor
    When  I submit a Contract Manager Assignment of '10' for the Requisition
    Given I am logged in as a PURAP Contract Manager
    When  I retrieve the Requisition document
    Then  the View Related Documents Tab PO Status displays
    And the Purchase Order Number is unmasked
  }

  step "I Complete Selecting Vendor #{@vendor_number}" unless @add_vendor_on_reqs == 'Yes'

  steps %Q{
    When I enter a Vendor Choice of 'Lowest Price'
    And  I calculate and verify the GLPE tab
    And  I submit the Purchase Order document
  }

  step 'the Purchase Order document goes to one of the following statuses:',
       table('
               | ENROUTE   |
               | FINAL     |
             ')

  steps %q{
    Given I switch to the user with the next Pending Action in the Route Log to approve Purchase Order document to Final
    Then  the Purchase Order document goes to FINAL
    And   in Pending Action Requests an FYI is sent to FO and Initiator
    And   the Purchase Order Doc Status is Open
  }

end

When /^I initiate a Payment Request document$/ do
  steps %Q{
    Given I login as a Accounts Payable Processor to create a PREQ
    When  I fill out the PREQ initiation page and continue
    And   I change the Remit To Address
    And   I enter the Qty Invoiced and calculate
    And   I enter a Pay Date
    And   I attach an Invoice Image
    And   I calculate PREQ
    And   I submit the Payment Request document
    Then  the Payment Request document goes to ENROUTE
    Given I switch to the user with the next Pending Action in the Route Log to approve Payment Request document to Final
    Then  the Payment Request document goes to FINAL
    And   the Payment Request Doc Status is Department-Approved
    And   the Payment Request document's GLPE tab shows the Requisition document submissions
  }
end

Then /^I FORMAT AND PROCESS THE CHECK WITH PDP$/ do
  #purap batch
  steps %q{
    Given I am logged in as a KFS Operations
    When  I run Auto Approve PREQ
    And   I extract Electronic Invoices
    And   I extract Regular PREQS to PDP for Payment
    And   I extract Immediate PREQS to PDP for Payment
    And   I close POS wtih Zero Balanecs
    And   I load PREQ into PDP
  }

  # format checks
  steps %q{
    Given I Login as a PDP Format Disbursement Processor
    When  I format Disbursement
  }
    #And   I select continue on Format Disbursement Summary
    #And   a Format Summary Lookup displays
  #}

  # generate output files batch jobs
  steps %q{
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
  visit(MaintenancePage).format_checks_ach
  on FormatDisbursementPage do |page|
    page.payment_date.set right_now[:date_w_slashes]
    page.all_payment_type.set
    page.all_payment_distribution.set
    puts 'fields set'
    page.customer_boxes.each { |check_box| check_box.checked? ? nil : check_box.click }
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
  # on FormatSummaryLookupPage do |page|
  #
  # end
  pending 'not sure what to check!'
end

Then /^the (.*) document routes to the correct individuals based on the org review levels$/ do |document|
  reqs_org_reviewers_level_1 = Array.new
  reqs_org_reviewers_level_2 = Array.new
  po_reviewer_5m = ''

  if @level == 1
    reqs_org_reviewers_level_1 = get_principal_name_for_role('KFS-SYS', 'ORG 0100 Level 1 Review')
  elsif @level >= 2
    reqs_org_reviewers_level_2 = get_principal_name_for_role('KFS-SYS', 'ORG 0100 Level 2 Review')
  end

  if document == 'Purchase Order'
    puts 'base org review level ', @base_org_review_level

    @base_org_review_level.should == @level
    po_reviewer_500k = get_aft_parameter_value('PO_BASE_ORG_REVIEW_500K')
    po_reviewer_5m = get_aft_parameter_value('PO_BASE_ORG_REVIEW_5M')
    po_reviewer_100k = get_principal_name_for_group('3000106')

    case @level
      when 1
        (@org_review_users & po_reviewer_100k).length.should >= 1
      when 2
        (@org_review_users & po_reviewer_100k).length.should >= 1
        @org_review_users.should include po_reviewer_500k
      when 3
        (@org_review_users & po_reviewer_100k).length.should >= 1
        @org_review_users.should include po_reviewer_500k
        @org_review_users.should include po_reviewer_5m
    end
  elsif document == 'Requisition' || document == 'Payment Request'
    puts 'reqs base org  ', @org_review_users
    case @level
     when 1
       (@org_review_users & reqs_org_reviewers_level_1).length.should >= 1
     when 2
       (@org_review_users & reqs_org_reviewers_level_2).length.should >= 1
     when 3
       (@org_review_users & reqs_org_reviewers_level_2).length.should >= 1
    end
  end

end

And /^I validate Commodity Review Routing for (.*) document$/ do |document|
  # TODO : may need for POA in the future.
  if document == 'Purchase Order'
    puts 'po commodity ',@commodity_review_users
    @commodity_review_users.length.should == 0
  elsif document == 'Requisition'
    # TODO : reviewers should come from groupservice when it is ready
    reqs_animal_reviewers = get_principal_name_for_group('3000083')
    puts 'reqs commodity ', @commodity_review_users
    if @sensitive_commodity
      (@commodity_review_users & reqs_animal_reviewers).length.should >= 1
    else
      @commodity_review_users.length.should == 0
    end
  end
end

And /^the POA Routes to the FO$/ do
  @fo_users.length.should >= 1
end

And /^I amend the Purchase Order$/ do
  on(PurchaseOrderPage).amend_po
  on AmendPOReasonPage do |page|
    page.reason.fit random_alphanums(40, 'AFT-amendreason')
    page.amend
  end
  sleep 3
  @purchase_order_amendment = create PurchaseOrderAmendmentObject
end

When /^I initiate a Purchase Order Amendment document$/ do
  step 'I initiate a Purchase Order Amendment document with the following:', table(%q{| Default |  |})
end

When /^I initiate a Purchase Order Amendment document with the following:$/ do |table|
  arguments = table.rows_hash

  steps %Q{
    Given I am logged in as "#{@requisition_initiator}"
    And   I view the Purchase Order document
    And   I amend the Purchase Order
  }

  if !arguments['Item Quantity'].nil? && arguments['Item Quantity'].to_f > 0
    @poa_item_amount = arguments['Item Quantity'].to_f * arguments['Item Cost'].to_f
    step 'I add an item to Purchase Order Amendment with:',
         table(%Q{
           | Item Quantity       | #{arguments['Item Quantity']}        |
           | Item Cost           | #{arguments['Item Cost']}            |
           | Item Commodity Code | #{@requisition.item_commodity_code}  |
           | Account Number      | #{@requisition.item_account_number}  |
           | Object Code         | #{@requisition.item_object_code}     |
           | Percent             | 100                                  |
         })
    step 'I calculate and verify the GLPE tab with no entries'
  else
    step 'I calculate and verify the GLPE tab'
  end

  steps %q{
    When  I submit the Purchase Order Amendment document
    Then  the Purchase Order Amendment document goes to ENROUTE
    Given I switch to the user with the next Pending Action in the Route Log to approve Purchase Order Amendment document to Final
    Then  the Purchase Order Amendment document goes to FINAL
  }
end

And /^I check Related Documents Tab on Requisition Document$/ do
  on RequisitionPage do |page|
    page.show_related_documents
    if page.view_related_doc.length > 1
      @auto_gen_po = true
      page.close_related_documents
      step 'the View Related Documents Tab PO Status displays'
    else
      @auto_gen_po = false
    end
  end
end

And /^I add an item to Purchase Order Amendment with:$/ do |table|
  arguments = table.rows_hash
  on PurchaseOrderAmendmentPage do |page|
    page.item_quantity.fit       arguments['Item Quantity']
    page.item_commodity_code.fit arguments['Item Commodity Code']
    page.item_description.fit    random_alphanums(15, 'AFT Item')
    page.item_unit_cost.fit      arguments['Item Cost']
    page.item_uom.fit            @requisition.item_uom
    page.item_add

    #Add Accounting line
    page.expand_all
    page.account_number(1).fit arguments['Account Number']
    page.object_code(1).fit    arguments['Object Code']
    page.percent(1).fit        arguments['Percent']
    page.add_account(1)
  end

end

And /^I calculate and verify the GLPE tab with no entries$/ do
  on PurchaseOrderAmendmentPage do |page|
    page.calculate
    #page.show_glpe

    page.glpe_results_table.text.include? 'There are currently no General Ledger Pending Entries ' <<
                                          'associated with this Transaction Processing document.'
  end
end

Then /^the Purchase Order Amendment document's GLPE tab shows the new item amount$/ do
  on PurchaseOrderAmendmentPage do |page|
    page.show_glpe

    puts 'requisition ', @requisition.item_account_number,@requisition.item_uom
    puts ' POA glpe ', page.glpe_results_table.text, page.glpe_results_table[2][11].text, @poa_item_amount

    page.glpe_results_table.rows.length.should == 3
    page.glpe_results_table.text.should include @requisition.item_account_number
    page.glpe_results_table[1][11].text.to_f.should == @poa_item_amount
    page.glpe_results_table[2][11].text.to_f.should == @poa_item_amount
  end
end

  Given /^I am logged in as a Purchasing Processor$/ do
    visit(BackdoorLoginPage).login_as('ml284') #TODO get from role service
  end

And /^I (submit|close|cancel) a Contract Manager Assignment of '(\d+)' for the Requisition$/ do |btn, contract_manager_number|
   visit(MainPage).contract_manager_assignment
   on ContractManagerAssignmentPage do |page|
    page.set_contract_manager(@requisition_number, contract_manager_number)
    page.send(btn)

    sleep 10 # need to wait a little
   end
end

And /^I am logged in as a Contract Manager$/ do
  visit(BackdoorLoginPage).login_as('mss7') #TODO get from role service
  # pending # express the regexp above with the code you wish you had
end


And /^I retrieve the Requisition$/ do
  # temp
  #@requisition_number = '325401'
  #@document_id = '5291056'
  visit(MainPage).requisitions  #remember "S" is for search
   on DocumentSearch do |page|
     page.document_type.set 'REQS'
     page.requisition_number.fit @requisition_number
     page.search

     page.open_item(@document_id)
   end
end

And /^the View Related Documents Tab PO Status displays (\w+)$/ do |po_status|
    on RequisitionPage do |page|
      page.show_related_documents
      page.show_purchase_order
      @purchase_order_number = page.purchase_order_number
      # verify unmasked and 'UNAPPROVED'
      page.purchase_order_number.should_not include '*****' # unmasked
      page.po_unapprove.should include 'UNAPPROVED'
      page.purchase_order_number_link

      sleep 15
      @purchase_order = create PurchaseOrderObject
    end


end

And /^the Purchase Order Number is unmasked$/ do
  on (PurchaseOrderPage) do |page|
    page.po_number.should_not include '****'
  end
end

And /^I Select the PO$/ do
  pending # express the regexp above with the code you wish you had
end

And /^I Complete Selecting Vendor (.*)$/ do |vendor_number|
  on (PurchaseOrderPage) do |page|
    page.vendor_search
    on VendorLookupPage do |vlookup|
      vlookup.vendor_number.fit vendor_number
      vlookup.search
      vlookup.return_value(vendor_number)
    end
  end

end


And /^I enter a Vendor Choice$/ do
  on (PurchaseOrderPage) do |page|
    page.vendor_choice.fit 'Lowest Price'
  end
end

And /^I calculate and verify the GLPE with amount (.*)$/ do |amount|
  on (PurchaseOrderPage) do |page|
    page.expand_all
    page.calculate
  end
  # TODO : not sure what to verify about GLPE
  on (GeneralLedgerPendingEntryTab) do |gtab|
    idx = gtab.glpe_tables.length - 1
    glpe_table = gtab.glpe_tables[idx]
    glpe_table[1][11].text.should include amount
    glpe_table[2][11].text.should include amount
    if glpe_table[1][12].text.eql?('D')
      glpe_table[2][12].text.should == 'C'
    else
      if glpe_table[1][12].text.eql?('C')
        glpe_table[2][12].text.should == 'D'
      end
    end
   end
end


And /^I submit the PO eDoc Status is$/ do
  pending # express the regexp above with the code you wish you had
end


Then /^In Pending Action Requests an FYI is sent to FO and Initiator$/ do
  on(KFSBasePage) do |page|
    page.expand_all

    annotation_col = page.pnd_act_req_table.keyed_column_index(:annotation)
    action_col = page.pnd_act_req_table.keyed_column_index(:action)
    fo_row = page.pnd_act_req_table
    .column(annotation_col)
    .index{ |c| c.exists? && c.visible? && c.text.match(/Fiscal Officer/) }
    initiator_row = page.pnd_act_req_table
    .column(annotation_col)
    .index{ |c| c.exists? && c.visible? && c.text.match(/Notification of Requisition Initiator/) }
    page.pnd_act_req_table[fo_row][action_col].text.should include "IN ACTION LIST\nFYI"
    page.pnd_act_req_table[initiator_row][action_col].text.should include "IN ACTION LIST\nFYI"
  end
end


And(/^The PO eDoc Status is$/) do
  pending # express the regexp above with the code you wish you had
end


And(/^the (.*) Doc Status is (.*)/) do |document, doc_status|
  on (KFSBasePage) do |page|
    page.app_doc_status.should == doc_status
  end
end



  And /^I fill out the PREQ initiation page and continue$/ do
    #@purchase_order_number = '296399' # temporary.  don't commit
    visit(MainPage).payment_request
    on(PaymentRequestInitiationPage) do |page|
      page.purchase_order.fit @purchase_order_number
      page.invoice_date.fit yesterday[:date_w_slashes]
      page.invoice_number.fit rand(100000)
      page.vendor_invoice_amount.fit @requisition.item_quantity.delete(',').to_f * @requisition.item_unit_cost.to_i
      page.continue
    end
    on YesOrNoPage do |page|
      page.yes if page.yes_button.exists?
    end
    sleep 10
    @payment_request = create PaymentRequestObject
  end

  And  /^I change the Remit To Address$/ do
    on(PaymentRequestPage) do |page|
      page.vendor_address_1.fit "Apt1" + page.vendor_address_1.value
    end
  end
  And  /^I enter the Qty Invoiced and calculate$/ do
    on(PaymentRequestPage) do |page|
      page.item_qty_invoiced(0).fit @requisition.item_quantity # same as REQS item qty
      page.item_calculate(0)
    end

  end

  And  /^I enter a Pay Date$/ do
    on(PaymentRequestPage) do |page|
      page.pay_date.fit right_now[:date_w_slashes]
    end
  end


  And /^I attach an Invoice Image$/ do
    on PaymentRequestPage do |page|
      page.note_text.fit random_alphanums(40, 'AFT-NoteText')
      page.attachment_type.fit 'Invoice Image'
      page.attach_notes_file.set($file_folder+@payment_request.attachment_file_name)
      page.add_note
      page.attach_notes_file_1.should exist #verify that note is indeed added

    end
  end

  And /^I calculate PREQ$/ do
    on (PaymentRequestPage) do |page|
      page.expand_all
      page.calculate
    end
  end


And   /^I Search Documents retrieve the PO$/ do
  on ShopCatalogPage do |page|
    #page.key_words.fit 'Commidity 14111507'
    page.order_doc
    page.po_doc_search
    page.po_id.fit @purchase_order_number
    (0..page.date_range.length).each do |i|
      if page.date_range[i].visible?
        page.date_range[i].fit 'Today'
      end
    end
    sleep 2
    (0..page.go_buttons.length).each do |i|
      if page.go_buttons[i].visible?
        page.go_buttons[i].click
        break
      end
    end
  end
end

  And   /^the Document Status displayed '(\w+)'$/ do |doc_status|
    on ShopCatalogPage do |page|
      page.return_po_value(@purchase_order_number)
      page.doc_summary[1].text.should include  'Workflow  ' + doc_status
    end
  end

  And   /^the Delivery Instructions displayed equals what came from the PO$/ do
    on ShopCatalogPage do |page|
      page.doc_po_link
      page.doc_summary[1].text.should include "Note to Supplier\n" + @requisition.vendor_notes
      page.doc_summary[3].text.should include "Delivery Instructions " + @requisition.delivery_instructions
    end
  end

  And   /^the Attachments for Supplier came from the PO$/ do
    on ShopCatalogPage do |page|
      page.attachments_link
      page.search_results[1].text.should include @requisition.attachment_file_name
    end
  end


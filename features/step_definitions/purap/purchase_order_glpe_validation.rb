Then /^On the Purchase Order the GLPE displays "(.*?)"$/ do |glpe_msg|
  visit(MainPage).purchase_orders
  on DocumentSearch do |page|
    page.document_type.fit ''
    page.document_id_field.fit @requisition.document_id
    page.search
    page.open_item(@requisition.document_id)
  end

  on RequisitionPage do |page|
    page.show_related_documents
    @po_num = page.purchase_order_number
    page.purchase_order_number_link
  end

  on PurchaseOrderPage do |page|
    page.show_glpe
    page.glpe_message.should include glpe_msg
  end
end

And /^I cancel the Purchase Order on the Requisition$/ do
  visit(MainPage).doc_search
  on DocumentSearch do |page|
    page.document_id.fit @requisition.document_id
    page.search
    page.open_item(@requisition.document_id)
  end

  on RequisitionPage do |page|
    page.show_related_documents
    @po_num = page.purchase_order_number
    page.purchase_order_number_link
  end

  on(PurchaseOrderPage).cancel
  on(RecallPage).reason.fit 'AFT TEST'
  on(YesOrNoPage).yes
end

And /^I view the Purchase Order using the Document ID$/ do
  visit(MainPage).doc_search

  on DocumentSearch do |page|
    page.document_id_field.fit @requisition.document_id
    page.search
    page.open_item @requisition.document_id
  end
  on RequisitionPage do |page|
    page.show_related_documents
    page.purchase_order_number_link
  end
end

And /^I void The Purchase Order$/ do
  on(PurchaseOrderPage).void_order
  on(RecallPage).reason.fit 'AFT TEST VOID PO'
  on(YesOrNoPage).yes
  #this is for the OK which is the same html name tag as the yes button
  on(YesOrNoPage).yes
end


And /^The GLPE from the Purchase Order are reversed by the void$/ do
  step 'I view the Purchase Order using the Document ID'

  on PurchaseOrderPage do |page|
    page.show_glpe
    page.frm.link(text: 'POV').should exist
  end
end

And /^I add a random Delivery Phone number to the Purchase Order document$/ do
  @purchase_order.edit delivery_phone_number: random_phone_number
end
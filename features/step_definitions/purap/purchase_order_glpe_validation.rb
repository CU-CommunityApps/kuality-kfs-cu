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
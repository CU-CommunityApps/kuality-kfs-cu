And /^the Items are GT AUTOMATIC_PURCHASE_ORDER_DEFAULT_LIMIT_AMOUNT$/ do
  pending # express the regexp above with the code you wish you had
end

And /^I am logged in as Approver FO and I Cancel the PO$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I Retrieve the Cancelled PO and Select the GLPE Tab$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^On the Purchase Order the GLPE displays "(.*?)"$/ do |glpe_msg|
  puts 'the po baby number is'
  puts @po_baby_num.inspect
  visit(MainPage).purchase_orders
  on DocumentSearch do |page|
    page.document_id_field.fit @requisition.document_id
    page.search
    page.open_item(@requisition.document_id)
  end
  on PurchaseOrderPage do |page|
    page.show_glpe
    page.glpe_message should == glpe_msg
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
    puts 'is the purchase number'
    page.purchase_order_number.inspect
    @po_baby_num = page.purchase_order_number

    page.purchase_order_number_link
  end

  on(PurchaseOrderPage).cancel

  on(RecallPage).reason.fit 'AFT TEST'

  on(YesOrNoPage).yes_button

end


# When(/^I view the Purchase Order document$/) do
#   visit(MainPage).purchase_orders
#   on DocumentSearch do |page|
#     puts 'doc id'
#     puts @requisition.document_id.inspect
#     puts 'po num'
#     puts @requisition.po_number.inspect
#     puts 'end puts'
#
#     page.document_id.fit @requisition.document_id
#     page.purchase_order_numb.fit @requisition.po_number
#     page.search
#     page.open_item(@requisition.document_id)
#
#   end
# end

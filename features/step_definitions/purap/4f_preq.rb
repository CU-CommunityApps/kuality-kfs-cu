When /^I visit the "(.*)" page$/  do   |go_to_page|
  go_to_pages = go_to_page.downcase.gsub!(' ', '_')
  on(MainPage).send(go_to_pages)
end

And /^I create the Requisition document with:$/  do |table|
  updates = table.rows_hash
  @requisition = create RequisitionObject, description: 'HELLO',
                        payment_request_positive_approval_required: updates['payment request'],
                        vendor_number:        updates['vendor number'],
                        item_quantity:        updates['item quanity'],
                        item_unit_cost:       updates['item cost'],
                        item_commodity_code:  updates['item commodity code'],
                        item_account_number:  updates['account number'],
                        item_object_code:     updates['object code'],
                        item_percent:         updates['percent']

end

And /^I calculate my Requisition document$/ do
  on(RequisitionPage).calculate
  #need to let calculate process, no other way to verify calculate is completed
  sleep 3
end

And /^I view the Requisition document on my action list$/ do
    visit(MainPage).action_list
  on ActionList do |page|
    #sort the date
    page.sort_results_by('Date Created')
    page.result_item(@requisition.document_id).wait_until_present
    page.open_item(@requisition.document_id)
  end
end
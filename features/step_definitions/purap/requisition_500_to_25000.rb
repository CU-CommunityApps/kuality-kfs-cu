# And /^I create the Requisition document with an Award Account and items that total less than the dollar threshold Requiring Award Review$/ do
#   account_info = get_kuali_business_object('KFS-COA','Account','subFundGroupCode=APFEDL&closed=N&contractsAndGrantsAccountResponsibilityId=5&accountExpirationDate=NULL')
#   award_account_number = account_info['accountNumber'][0]
#   cost_from_param = get_parameter_values('KFS-PURAP', 'DOLLAR_THRESHOLD_REQUIRING_AWARD_REVIEW', 'Requisition')[0].to_i
#   cost_from_param = cost_from_param - 1
#
#   step 'I create the Requisition document with:',
#        table(%Q{
#          | Vendor Number       | 4471-0                  |
#          | Item Quantity       | 1                       |
#          | Item Cost           | #{cost_from_param}      |
#          | Item Commodity Code | 12142203                |
#          | Account Number      | #{award_account_number} |
#          | Object Code         | 6570                    |
#          | Percent             | 100                     |
#        })
# end
#
# And /^I submit the Requisition document with items that total more than the dollar threshold Requiring Award Review$/ do
#   account_info = get_kuali_business_object('KFS-COA','Account','subFundGroupCode=APFEDL&closed=N&contractsAndGrantsAccountResponsibilityId=5&accountExpirationDate=NULL')
#   award_account_number = account_info['accountNumber'][0]
#   cost_from_param = get_parameter_values('KFS-PURAP', 'DOLLAR_THRESHOLD_REQUIRING_AWARD_REVIEW', 'Requisition')[0].to_i
#   cost_from_param = cost_from_param + 100
#
#   step 'I create the Requisition document with:',
#        table(%Q{
#          | Vendor Number       | 4471-0                  |
#          | Item Quantity       | 1                       |
#          | Item Cost           | #{cost_from_param}      |
#          | Item Commodity Code | 12142203                |
#          | Account Number      | #{award_account_number} |
#          | Object Code         | 6570                    |
#          | Percent             | 100                     |
#        })
#     step 'I submit the Requisition document'
#
# end
#
# And /^I Complete Selecting a Foreign Vendor$/ do
#   on(PurchaseOrderPage).vendor_search
#   on VendorLookupPage do |vlookup|
#     vendor_number = '39210-0' # TODO : this vendor number should be from a parameter
#     vlookup.vendor_number.fit vendor_number
#     vlookup.search
#     vlookup.return_value(vendor_number)
#   end
# end
#
#
# Then /^in Pending Action Requests an FYI is sent to FO and Initiator$/ do
#   on PurchaseOrderPage do |page|
#     # TODO : it looks like there is no reload button when open PO with final status.  so comment it out for now.  need further check
#     #Watir::Wait::TimeoutError: timed out after 30 seconds, waiting for {:class=>"globalbuttons", :title=>"reload", :tag_name=>"button"} to become present    page.reload # Sometimes the pending table doesn't show up immediately.
#     #page.headerinfo_table.wait_until_present
#     page.expand_all
#     page.refresh_route_log # Sometimes the pending table doesn't show up immediately.
#     page.show_pending_action_requests if page.pending_action_requests_hidden?
#     fyi_initiator = 0
#     fyi_fo = 0
#     (1..page.pnd_act_req_table.rows.length - 2).each do |i|
#       if page.pnd_act_req_table[i][1].text.include?('FYI')
#         if page.pnd_act_req_table[i][4].text.include? 'Fiscal Officer'
#           fyi_fo += 1
#         else
#           if page.pnd_act_req_table[i][4].text.include? 'Initiator'
#             fyi_initiator += 1
#           end
#         end
#       end
#     end
#     fyi_initiator.should >= 1
#     fyi_fo.should >= 1
#   end
# end
#
# Then /^I update the Tax Tab$/ do
#   @payment_request.update_tax_tab income_class_code:   'A - Honoraria, Prize',
#                                   federal_tax_pct:     '0',
#                                   state_tax_pct:       '0',
#                                   postal_country_code: 'Canada'
# end
#
# And /^I add an Attachment to the Requisition document$/ do
#   pending 'THIS STEP DOES NOT USE NOTES AND ATTACHMENTS CORRECTLY.'
#   on RequisitionPage do |page|
#     page.note_text.fit random_alphanums(40, 'AFT-NoteText')
#     page.send_to_vendor.fit 'Yes'
#     page.attach_notes_file.set($file_folder+@requisition.attachment_file_name) # FIXME: This doesn't use Notes and Attachments correctly at all
#
#     page.add_note
#     page.attach_notes_file_1.should exist #verify that note is indeed added
#   end
# end
#
# And /^I Complete Selecting an External Vendor$/ do
#   on(PurchaseOrderPage).vendor_search
#   on VendorLookupPage do |vlookup|
#     vendor_number = '27015-0' # TODO : this vendor number should be from a parameter
#     vlookup.vendor_number.fit vendor_number
#     vlookup.search
#     vlookup.return_value(vendor_number)
#   end
# end
#
# And /^During Approval of the Purchase Order Amendment the Financial Officer adds a line item$/ do
#   step 'I view the Requisition document from the Requisitions search'
#   step 'I switch to the user with the next Pending Action in the Route Log for the Requisition document'
#   step 'I open the Purchase Order Amendment on the Requisition document'
#   step 'I switch to the user with the next Pending Action in the Route Log for the Purchase Order document'
#   step 'I open the Purchase Order Amendment on the Requisition document'
#
#   on PurchaseOrderPage do |page|
#     page.expand_all
#
#     page.account_number.fit '1271001'
#     page.object_code.fit '6570'
#     page.percent.fit '50'
#
#     page.old_percent.fit '50'
#     page.old_amount.fit ''
#
#     page.add_account
#     page.calculate
#     sleep 2
#     page.approve
#   end
# end


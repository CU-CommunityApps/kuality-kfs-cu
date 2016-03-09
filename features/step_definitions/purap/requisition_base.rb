# And /^users outside the Route Log can not search and retrieve the REQS$/ do
#   step "I am logged in as \"mrw258\"" # TODO : need a better way to figure out who can't view REQS
#   visit(MainPage).requisitions
#   on DocumentSearch do |page|
#     page.document_id.fit @requisition.document_id
#     #page.document_id.fit '5358712'
#     page.search
#     sleep 2
#     unless page.lookup_div.parent.text.include?('No values match this search.')
#       # if search found, then can not open
#       page.open_item(@requisition.document_id)
#       step 'I should get an Authorization Exception Report error'
#     end
#   end
#
# end
#
# And /^I validate Commodity Review Routing for (.*) document$/ do |document|
#   # TODO : may need for POA in the future.
#   if document == 'Purchase Order'
#     @commodity_review_users.length.should == 0
#   elsif document == 'Requisition'
#     # TODO : reviewers should come from groupservice when it is ready
#     reqs_animal_reviewers = get_principal_name_for_group('3000083')
#     if @sensitive_commodity
#       (@commodity_review_users & reqs_animal_reviewers).length.should >= 1
#     else
#       @commodity_review_users.length.should == 0
#     end
#   end
# end
#
# And /^I complete the Asset Information Detail tab$/ do
#   on AssetGlobalPage do |page|
#     page.asset_type_code.fit '019'
#     page.manufacturer.fit 'Jones Landscaping' if page.manufacturer.value.strip.empty?
#   end
# end
#
# And /^I complete the existing Asset Location Information$/ do
#   on AssetGlobalPage do |page|
#     page.asset_campus.fit 'IT'
#     page.asset_building_code.fit '7000'
#     page.asset_building_room_number.fit 'XXXXXXXX'
#     @asset_number = page.asset_number
#   end
# end

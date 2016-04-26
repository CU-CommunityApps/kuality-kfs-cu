And /^I create a Requisition with required Chart-Organization, Delivery and Additional Institutional information populated$/ do
  visit(MainPage).requisition
  on RequisitionPage do |req_page|
    # Check Chart/Org associated with the user; if either one does not exist, use corresponding parameter default value and perform lookup
    # Ensure both values are stripped or empty strings
    chart,org = req_page.chart_org_readonly.split('/')
    chart = chart.nil? ? '' : chart.strip
    org = org.nil? ? '' : org.strip
    if org.empty? || chart.empty?
      # Substitute default parameters for empty values then perform lookup
      req_page.chart_org_search
      on OrganizationLookupPage do |org_lookup|
        chart = get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE) if chart.empty?
        org = get_aft_parameter_value(ParameterConstants::DEFAULT_ORGANIZATION_CODE) if org.empty?
        org_lookup.chart_code.set chart
        org_lookup.organization_code.set org
        org_lookup.search
        org_lookup.wait_for_search_results
        org_lookup.return_random
      end
    end

    # Check read-only address line one value; if it does not exist, look-up a building
    if req_page.delivery_address_1_readonly.empty?
      # try a set number of times to find a building with a zip code present
      max_num_searches = 5
      number_bldg_search_attempts = 0
      while req_page.delivery_postal_code_readonly.empty? && number_bldg_search_attempts < max_num_searches
        req_page.building_search
        on BuildingLookupPage do |bldg_page|
          bldg_page.search
          bldg_page.wait_for_search_results
          bldg_page.return_random
        end
        number_bldg_search_attempts +=1
      end #while-postal code blank
      fail ArgumentError, "Attempted #{max_num_searches} times to find Delivery Building with valid Postal Code but each time Postal Code was blank." if number_bldg_search_attempts == max_num_searches
    end

    # look-up and populate room for building just selected
    req_page.room_search
    on(RoomLookupPage).search_and_return_random

    # ensure required email addresses have data values
    req_page.delivery_email.set random_email_address if req_page.delivery_email_new.empty? || req_page.delivery_email_new == 'null'
    req_page.requestor_email.set random_email_address if req_page.requestor_email_new.empty? || req_page.requestor_email_new == 'null'

    # ensure required phone numbers have data values
    req_page.delivery_phone_number.set random_phone_number if req_page.delivery_phone_number_new.empty? || req_page.delivery_phone_number_new == 'null'
    req_page.requestor_phone.set random_phone_number if req_page.requestor_phone_new.empty? || req_page.requestor_phone_new == 'null'

    @requisition = make RequisitionObject
    req_page.description.fit @requisition.description # This will be auto-generated in the object, but not auto-populated on the page
    @requisition.absorb! :new
  end
end


And /^I add an Item with a unit cost of (.*) to the Requisition with a (sensitive|non\-sensitive) Commodity Code$/ do |unit_cost, commodity_code_type|
  # Use the object's default AFT parameters and methods on the ItemLineObject to fill out the data elements in the page
  @item = make ItemLineObject

  on ItemsTab do |item_tab|
    item_tab.commodity_code_search
    on CommodityCodeLookupPage do |comm_page|
      comm_page.sensitive_data.select_value(@item.determine_commodity_code_of_type(commodity_code_type))
      comm_page.search
      comm_page.wait_for_search_results
      begin
        comm_page.return_random
      # first time cache building causes this, wait a bit longer and try again
      rescue Watir::Exception::UnknownObjectException
        puts "Watir::Exception::UnknownObjectException rescued for Commmodity Code search. Waiting a bit longer for search results before attempting return_random a second time."
        sleep(30)
        comm_page.return_random
      end

    end
    #Leave Item Type at page default value; otherwise use the object's default values
    item_tab.quantity.set        @item.quantity
    item_tab.unit_of_measure.set @item.uom
    item_tab.description.set     @item.description
    item_tab.unit_cost.set       unit_cost
    item_tab.add_item
  end
  @requisition.items.update_from_page! :new
end


And /^I add an Accounting Line to or update the favorite account specified for the Requisition Item just created$/ do
  # NOTE: Need to determine whether user has favorite account that could have already pre-populated
  #       the accounting lines. Take the action of overwriting that favorite account with a known
  #       good account because favorite account could be closed which will cause the AFT to fail.

  # Requisition item just created is presumed to be the last item in the zero-based collection.
  # Value used multiple times once so retrieve once and reuse.
  new_item_index = @requisition.items.length-1
  on ItemsTab do |item_tab|
    item_tab.show_item_accounting_lines(new_item_index) if item_tab.item_accounting_lines_hidden?(new_item_index)
    if item_tab.update_chart_code(new_item_index).exists?
      # User's favorite account could be closed.
      # Set accounting line to known good value by deleting the favorite account and adding a known good account.
      item_tab.delete_item_accounting_line(new_item_index)
      step 'I add an Accounting Line to the Requisition Item just created'
    else
      step 'I add an Accounting Line to the Requisition Item just created'
    end
  end
end


And /^I add an Accounting Line to the Requisition Item just created$/ do
  # Requisition item just created is presumed to be the last item in the zero-based collection.
  # Value used multiple times once so retrieve once and reuse.
  new_item_index = @requisition.items.length-1
  on ItemsTab do |item_tab|
    # Get a random account number
    item_tab.show_item_accounting_lines(new_item_index) if item_tab.item_accounting_lines_hidden?(new_item_index)
    item_tab.account_number_new_search(new_item_index)
    on AccountLookupPage do |acct_lookup|
      acct_lookup.sub_fund_group_code.set (get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ITEMS))[:account_subfund_lookup]
      acct_lookup.search
      acct_lookup.wait_for_search_results
      acct_lookup.return_random
    end
    # Attempt a set number of times to obtain a random object code with the AFT parameter specified Object Level and
    # Object Sub-Type values that should not cause a business rule error for the Object Sub-Type code assigned to the
    # random Object Code using the default Chart and Percent values.
    max_num_searches = 10
    number_object_search_attempts = 0
    begin
      item_tab.object_code_new_search(new_item_index)
      on ObjectCodeLookupPage do |obj_lookup|
        obj_lookup.level_code.set (get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ITEMS))[:object_level_lookup]
        obj_lookup.object_sub_type_code.set (get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ITEMS))[:object_sub_type_lookup]
        obj_lookup.search
        obj_lookup.wait_for_search_results
        obj_lookup.return_random
      end
      number_object_search_attempts +=1
      # business rules are verified when add button is pressed
      item_tab.add_item_accounting_line(new_item_index)
      page_errors = $current_page.errors
    end while !(page_errors == []) && number_object_search_attempts < max_num_searches #while-object code business rule failure
    # Get page data in backing object prior to failure check so it is known why should failure occur
    @requisition.items.update_from_page! :new
    fail ArgumentError, "Attempted #{max_num_searches} times to find Object Code with an Object Level of #{((get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ITEMS))[:object_level_lookup])} and an Object SubType of #{((get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ITEMS))[:object_sub_type_lookup])} but each Object Code selected generated a business rule error when attempting to add the Account." if number_object_search_attempts == max_num_searches
  end
end


And /^I add a restricted Vendor to the Requisition$/ do
  on RequisitionPage do |req_page|
    req_page.clear_vendor
    req_page.suggested_vendor_search
    on VendorLookupPage do |vendor_lookup|
      restricted_vendor_number = get_restricted_vendor_number
      vendor_lookup.vendor_number.set restricted_vendor_number
      vendor_lookup.search
      vendor_lookup.wait_for_search_results
      vendor_lookup.return_random
    end
  end
  #absorb for requisition vendor data needs to be created if this data is required by future AFT steps, currently not required
end


Then /^a Commodity Reviewer does (.*) a Pending or Future Action approval request for the (sensitive|non\-sensitive) Commodity Code$/ do |existence_check, commodity_code_type|
  # verify that Pending Action Requests OR Future Action Requests (do|do not) show routing to Commodity Reviewer
  role_exists_in_pending = false
  role_exists_in_future = false

  on(KFSBasePage) do |page|
    page.expand_all
    page.show_pending_action_requests if page.show_pending_action_requests_button.exists?
    page.show_future_action_requests if page.show_future_action_requests_button.exists?

    annotation_pending_col = page.pnd_act_req_table.keyed_column_index(:annotation)
    pending_cr_row = page.pnd_act_req_table
                         .column(annotation_pending_col)
                         .index{ |c| c.exists? && c.visible? && c.text.match(/Commodity Reviewer/) }
    if pending_cr_row.nil?
      role_exists_in_pending = false
    else
      role_exists_in_pending = true
    end

    annotation_future_col = page.future_actions_table.keyed_column_index(:annotation)
    future_cr_row = page.future_actions_table
                        .column(annotation_future_col)
                        .index{ |c| c.exists? && c.visible? && c.text.match(/Commodity Reviewer/) }
    if future_cr_row.nil?
      role_exists_in_future = false
    else
      role_exists_in_future = true
    end
  end

  case existence_check
    when 'have'
      (role_exists_in_pending || role_exists_in_future).should == true
    when 'not have'
      role_exists_in_pending.should == false
      role_exists_in_future.should == false
  end
end


Then /^the Requisition Document Status is (.*)$/ do |status_desired|
  on RequisitionPage do |req_page|
    (req_page.requisition_status).should == status_desired
  end
end

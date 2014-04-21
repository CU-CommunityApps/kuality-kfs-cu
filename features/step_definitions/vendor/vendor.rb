When /^I start an empty Vendor document$/ do
  @vendor = create VendorObject

end

When /^I create an? (Corporation|Individual) and (Foreign|Non-Foreign|eShop) Vendor( with )?(.*)?$/ do |ownership_type, sub_type, with_1, tab_1|
  case ownership_type
    when 'Corporation'
      case sub_type
        when 'Foreign' # KFSQA-634
          default_fields = {
              vendor_type:                'PO - PURCHASE ORDER',
              vendor_name:                'Bob Weir Guitars',
              foreign:                    'Yes',
              tax_number_type_ssn:        nil,
              tax_number_type_fein:       :set,
              ownership:                  'CORPORATION',
              address_type:               'PO - PURCHASE ORDER',
              address_1:                  'PO Box 5466',
              address_2:                  '(127 Matt Street)',
              city:                       'Hanover',
              state:                      'MA',
              zipcode:                    '02359',
              country:                    'United States',
              method_of_po_transmission:  'US MAIL',
              supplier_diversity:         'VETERAN OWNED',
              supplier_diversity_expiration_date: '09/10/2015',
              attachment_file_name:       'vendor_attachment_test.png',
          }
        when 'Non-Foreign'
          case tab_1
            when 'Contract and Insurance' #KFSQA-635
              default_fields = {
                  vendor_type:                'PO - PURCHASE ORDER',
                  vendor_name:                'M Hart Drums',
                  foreign:                    'No',
                  tax_number_type_ssn:        nil,
                  tax_number_type_fein:       :set,
                  ownership:                  'CORPORATION',
                  w9_received:                'Yes',
                  w9_received_date:           '02/01/2014',
                  address_type:               'PO - PURCHASE ORDER',
                  address_1:                  'PO Box 54777',
                  address_2:                  '(127 Matt Street)',
                  city:                       'Hanover',
                  state:                      'MA',
                  zipcode:                    '02359',
                  country:                    'United States',
                  method_of_po_transmission:  'US MAIL',
                  supplier_diversity:         'VETERAN OWNED',
                  supplier_diversity_expiration_date: '09/10/2015',
                  attachment_file_name:       'vendor_attachment_test.png',
                  contract_po_limit:          '100000',
                  contract_name:              'MH Drums',
                  contract_description:       'MH Drums Master Agreement',
                  contract_begin_date:        '02/05/2014',
                  contract_end_date:          '02/05/2016',
                  contract_campus_code:       get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
                  contract_manager_code:      'Scott Otey',
                  po_cost_source_code:        'Pricing Agreement',
                  b2b_contract_indicator:     'No',
                  vendor_pmt_terms_code:      'Net 5 Days',
                  insurance_requirements_complete:      'Yes',
                  cornell_additional_ins_ind:           'Yes'
              }
            when 'Contract' #KFSQA-636
              default_fields = {
                  vendor_type:                'PO - PURCHASE ORDER',
                  vendor_name:                'Phil Lesh Bass',
                  foreign:                    'No',
                  tax_number_type_ssn:        nil,
                  tax_number_type_fein:       :set,
                  ownership:                  'CORPORATION',
                  w9_received:                'Yes',
                  w9_received_date:           '02/01/2014',
                  address_type:               'PO - PURCHASE ORDER',
                  address_1:                  'PO Box 54777',
                  address_2:                  '25 Boylston St.',
                  city:                       'Boston',
                  state:                      'MA',
                  zipcode:                    '02359',
                  country:                    'United States',
                  method_of_po_transmission:  'US MAIL',
                  supplier_diversity:         'VETERAN OWNED',
                  supplier_diversity_expiration_date: '09/10/2015',
                  attachment_file_name:       'vendor_attachment_test.png',
                  contract_name:              'Lesh Bass Agreement',
                  contract_description:       'Lesh Bass Agreement, 8 String Bass',
                  contract_begin_date:        '02/05/2014',
                  contract_end_date:          '02/05/2016',
                  contract_campus_code:       get_aft_parameter_values(ParameterConstants::DEFAULT_CAMPUS_CODE),
                  contract_manager_code:      'Scott Otey',
                  po_cost_source_code:        'Pricing Agreement',
                  b2b_contract_indicator:     'No',
                  vendor_pmt_terms_code:      'Net 5 Days',
              }

          end
        when 'eShop'  # KFSQA-633
          default_fields = {
              vendor_name:                'J Garcia Guitars',
              foreign:                    'No',
              tax_number_type_ssn:        nil,
              tax_number_type_fein:       :set,
              ownership:                  'CORPORATION',
              w9_received:                'Yes',
              w9_received_date:           '02/01/2014',
              address_type:               'PO - PURCHASE ORDER',
              address_1:                  'PO Box 63RF',
              address_2:                  '(127 Matt and Dave Street)	',
              city:                       'Hanover',
              state:                      'MA',
              zipcode:                    '02359',
              country:                    'United States',
              method_of_po_transmission:  'US MAIL',
              supplier_diversity:         'VETERAN OWNED',
              supplier_diversity_expiration_date: '09/10/2015',
              attachment_file_name:       'vendor_attachment_test.png',
          }
      end
    when 'Individual'
      case sub_type
        when 'Non-Foreign'
          case tab_1
            when 'Insurance' # KFSQA-637
              default_fields = {
                  vendor_type:                'PO - PURCHASE ORDER',
                  vendor_name:                'Ron McKernan Enterprises',
                  foreign:                    'No',
                  address_type:               'PO - PURCHASE ORDER',
                  address_1:                  '66 Sunset Blvd',
                  address_2:                  '(127 Walkway)',
                  city:                       'Hollywood',
                  state:                      'CA',
                  zipcode:                    '91190',
                  country:                    'United States',
                  method_of_po_transmission:  'US MAIL',
                  supplier_diversity:         'HUBZONE',
                  supplier_diversity_expiration_date: '09/10/2015',
                  attachment_file_name:       'vendor_attachment_test.png',
                  insurance_requirements_complete:      'Yes',
                  cornell_additional_ins_ind:           'Yes'
              }
          end
      end
  end
  @vendor = create VendorObject, default_fields

end

And /^I add an Attachment to the Vendor document$/ do
  on VendorPage do |page|
    page.note_text.fit  random_alphanums(20, 'AFT')
    page.attach_notes_file.set($file_folder+@vendor.attachment_file_name)
    page.add_note

  end
end
And /^I add a Contract to the Vendor document$/ do
  on VendorPage do |page|
    page.contract_po_limit.fit @vendor.contract_po_limit
    page.contract_name.fit @vendor.contract_name
    page.contract_description.fit @vendor.contract_description
    page.contract_begin_date.fit @vendor.contract_begin_date
    page.contract_end_date.fit @vendor.contract_end_date
    page.po_cost_source_code.fit @vendor.po_cost_source_code
    page.contract_campus_code.fit @vendor.contract_campus_code
    page.contract_manager_code.fit @vendor.contract_manager_code
    page.b2b_contract_indicator.fit @vendor.b2b_contract_indicator
    page.vendor_pmt_terms_code.fit @vendor.vendor_pmt_terms_code

    page.add_vendor_contract
    page.contract_name_1.should exist #verify that contract is indeed added
  end
end

Then /^the Vendor document should be in my action list$/ do
  visit(MainPage).action_list

  on ActionList do |page|
    page.sort_results_by('Id')
    page.sort_results_by('Id')
    page.result_item(@vendor.document_id).should exist
  end
end

And /^I edit a Vendor with Vendor Number (.*)$/ do |vendor_number|
  visit(MainPage).vendor
  on VendorLookupPage do |page|
    page.vendor_number.fit vendor_number
    page.search
    page.edit_item(vendor_number)
  end
  on VendorPage do |page|
    page.description.fit random_alphanums(40, 'AFT')
    @vendor = make VendorObject
    @vendor.document_id = page.document_id
    @document_id = page.document_id
  end
end

And /^the Tax Number and Notes are Not Visible on Vendor page$/ do
  on VendorPage do |page|
    page.notes_table.rows.length.should == 2 # no notes displayed
    # can't locate this table with id/name/summary, so do this ugly way? # tax number is masked
    page.ownership.parent.parent.parent.parent[11][3].text == '*********'
  end
end

And /^I change the Phone (\w+) on Vendor Phone tab$/ do |phone_field|
  on VendorPage do |page|
    @changed_addr_phone = {} unless !@changed_addr_phone.nil?
    page.expand_all
    if page.updated_phone_number.exists?
      case phone_field
        when 'Number'
          page.updated_phone_number.fit "607-#{rand(100..999)}-#{rand(1000..9999)}"
          @changed_addr_phone.merge!(updated_phone_number: page.updated_phone_number.value)
        when 'Extension'
          page.updated_phone_ext.fit rand(100..999)
          @changed_addr_phone.merge!(updated_phone_ext: page.updated_phone_ext.value)
        when 'Type'
          page.updated_phone_type.fit 'MOBILE'
          @changed_addr_phone.merge!(updated_phone_type: page.updated_phone_type.value)
      end
    else
      page.phone_number.fit "607-#{rand(100..999)}-#{rand(1000..9999)}"
      page.phone_type.fit 'SALES'
      page.add_phone_number
      @changed_addr_phone.merge!(updated_phone_type: page.updated_phone_type.value, updated_phone_number: page.updated_phone_number.value)
    end
  end
end

And /^I change the Address (\w+) ?(\w)? on Vendor Address tab$/ do |address_field_1, address_field_2|
  on VendorPage do |page|
    @changed_addr_phone = {} unless !@changed_addr_phone.nil?

    case address_field_1
      when 'Line'
        case address_field_2
          when '1'
            page.updated_address_1.fit random_alphanums(30, 'AFT')
            @changed_addr_phone.merge!(updated_address_1: page.updated_address_1.value)
          when '2'
            page.updated_address_2.fit random_alphanums(30, 'AFT')
            @changed_addr_phone.merge!(updated_address_2: page.updated_address_2.value)
        end
      when 'Attention'
        page.updated_address_attention.fit random_alphanums(20, 'AFT')
        @changed_addr_phone.merge!(updated_address_attention: page.updated_address_attention.value)
    end
  end
end

When /^I select Vendor document from my Action List$/ do
  visit(MainPage).action_list
  on(ActionList).last if on(ActionList).last_link.exists?
  on(ActionList).open_item(@vendor.document_id)
end

And /^the Address and Phone Number changes persist$/ do
  on VendorPage do |page|
    page.expand_all
    page.updated_address_1.value.should == @changed_addr_phone[:updated_address_1]
    page.updated_phone_type.value.should == @changed_addr_phone[:updated_phone_type] unless @changed_addr_phone[:updated_phone_type].nil?
    page.updated_address_2.value.should == @changed_addr_phone[:updated_address_2] unless @changed_addr_phone[:updated_address_2].nil?
    page.updated_phone_number.value.should == @changed_addr_phone[:updated_phone_number]
    page.updated_address_attention.value.should == @changed_addr_phone[:updated_address_attention] unless @changed_addr_phone[:updated_address_attention].nil?
    page.updated_phone_ext.value.should == @changed_addr_phone[:updated_phone_ext] unless @changed_addr_phone[:updated_phone_ext].nil?
  end
end

And /^I add an Address to a Vendor with following fields:$/ do |table|
  vendor_address = table.rows_hash
  vendor_address.delete_if { |k,v| v.empty? }
  on VendorPage do |page|
    page.expand_all
    page.address_type.fit vendor_address['Address Type']
    page.address_1.fit vendor_address['Address 1']
    page.address_2.fit random_alphanums(30, 'Grntd') # new address indicator ? better way to do it ?
    @vendor.address_2 = page.address_2.value
    page.default_address.fit 'No'
    page.city.fit vendor_address['City']
    page.zipcode.fit vendor_address['Zip Code']
    page.country.fit vendor_address['Country']
    page.add_address
  end
end

And /^I update the General Liability with expired date$/ do
  @changed_liability = {} unless !@changed_liability.nil?
  on VendorPage do |page|
    page.expand_all
    page.insurance_requirements_complete.fit 'Yes'
    page.cornell_additional_ins_ind.fit 'Yes'
    page.insurance_requirement_indicator.set
    page.general_liability_coverage_amt.fit '100.00'
    page.general_liability_expiration_date.fit yesterday[:date_w_slashes]
    @changed_liability.merge!(general_liability_coverage_amt: page.general_liability_coverage_amt.value)
    @changed_liability.merge!(general_liability_expiration_date: page.general_liability_expiration_date.value)
  end
end

When /^I (#{BasePage::available_buttons}) the Vendor document with expired liability date$/ do |button|
  #doc_object = snake_case document
  button.gsub!(' ', '_')
  @vendor.send(button)
  on(YesOrNoPage).yes
  sleep 10 if (button == 'blanket approve' || button == 'approve' || 'submit')
end

When /^I close and save the Vendor document$/ do
  on (VendorPage) {|page| page.close}
  on(YesOrNoPage).yes
end

And /^the changes to Vendor document have persisted$/ do
  step 'the Address and Phone Number changes persist'
  unless @changed_liability.nil?
    on VendorPage do |page|
      page.general_liability_coverage_amt.value.should == @changed_liability[:general_liability_coverage_amt]
      page.general_liability_expiration_date.value.should == @changed_liability[:general_liability_expiration_date]
    end
  end
end


And /^I create a DV Vendor$/  do
  @vendor = create VendorObject,
                   vendor_type:                'DV - DISBURSEMENT VOUCHER',
                   vendor_name:                 nil,
                   vendor_last_name:           'Twenty**************',
                   vendor_first_name:          'Twenty-Three***********',
                   foreign:                    'No',
                   tax_number:                 "999#{rand(9)}#{rand(1..9)}#{rand(1..9999).to_s.rjust(4, '0')}",
                   tax_number_type_ssn:         nil,
                   tax_number_type_fein:        :set,
                   ownership:                  'CORPORATION',
                   w9_received:                'Yes',
                   w9_received_date:           yesterday[:date_w_slashes],
                   address_type:               'RM - REMIT',
                   address_1:                  'PO Box 54777',
                   address_2:                  '(127 Matt Street)',
                   city:                       'Hanover',
                   state:                      'MA',
                   zipcode:                    '02359',
                   country:                    'United States',
                   default_address:            'Yes',
                   method_of_po_transmission:  nil,
                   supplier_diversity:         'HUBZONE',
                   supplier_diversity_expiration_date: tomorrow[:date_w_slashes],
                   attachment_file_name:       'vendor_edit_attachment_2.png'
end

And /^I can not view the Tax ID and Attachments on Vendor page$/ do
  on VendorPage do |page|
    page.hidden_tax_number.parent.text.should include ('Tax Number: *********')
    page.notes_table.rows.length.should == 2
  end
end

And /^I enter a default payment method (\w+) on Vendor Page$/ do |payment_method|
  on (VendorPage) {|page|  page.default_payment_method.fit  payment_method}
end

And /^the Address changes persist$/ do
  on VendorPage do |page|
    page.expand_all
    page.updated_address_1.value.should == @changed_addr[:updated_address_1]
    page.updated_2nd_address_2.value.should == @changed_addr[:updated_2nd_address_2]
  end
end

And /^I change Remit Address and the Foreign Tax Address$/ do
  on VendorPage do |page|
    @changed_addr = {} unless !@changed_addr.nil?
    page.updated_address_1.fit random_alphanums(30, 'AFT')
    @changed_addr.merge!(updated_address_1: page.updated_address_1.value)
    page.updated_2nd_address_2.fit random_alphanums(30, 'AFT')
    @changed_addr.merge!(updated_2nd_address_2: page.updated_2nd_address_2.value)
  end
end

And /^I edit a random PO Vendor$/ do
  visit(MainPage).vendor
  on VendorLookupPage do |page|
    page.search
    page.edit_random
  end
  on VendorPage do |page|
    page.description.fit random_alphanums(40, 'AFT')
    @vendor = make VendorObject
    @vendor.document_id = page.document_id
    @document_id = page.document_id
  end
end

And /^I add a new Supplier Diversity to the Vendor document$/ do
  on VendorPage do |page|
    page.expand_all
    pending
  end
end

And /^I add a Search Alias to the Vendor document$/ do
  on(VendorPage).expand_all
  @vendor.search_aliases.update_from_page!
  @vendor.search_aliases.add Hash.new # We'll just add the default value.
                                      # For some reason, we still need to provide an empty hash.
end


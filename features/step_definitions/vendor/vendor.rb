When /^I start an empty Vendor document$/ do
  @vendor = create VendorObject
end

When /^I create an? (Corporation|Individual) and (Foreign|Non-Foreign|e-SHOP) Vendor( with .*)?$/ do |ownership_type, sub_type, tab_1|
  tab_1.gsub!(/^ with /, '') unless tab_1.nil?
  default_fields = Hash.new
  new_address = Hash.new
  new_supplier_diversity = Hash.new
  new_contract = Hash.new
  file_to_attach = ''
  case ownership_type
    when 'Corporation'
      case sub_type
        when 'Foreign' # KFSQA-634
          default_fields = {
            vendor_type:          'PO - PURCHASE ORDER',
            vendor_name:          'Bob Weir Guitars',
            foreign:              'Yes',
            tax_number_type_ssn:  nil,
            tax_number_type_fein: :set,
            ownership:            'CORPORATION'
          }
          file_to_attach = 'vendor_attachment_test.png'
          new_supplier_diversity = {
            type:                          'VETERAN OWNED',
            certification_expiration_date: '09/10/2015',
          }
          new_address = {
            type:                      'PO - PURCHASE ORDER',
            address_1:                 'PO Box 5466',
            address_2:                 '(127 Matt Street)',
            city:                      'Hanover',
            state:                     'MA',
            postal_code:               '02359',
            country:                   'United States',
            method_of_po_transmission: 'US MAIL'
          }
        when 'Non-Foreign'
          case tab_1
            when 'Contract and Insurance' #KFSQA-635
              default_fields = {
                vendor_type:                     'PO - PURCHASE ORDER',
                vendor_name:                     'M Hart Drums',
                foreign:                         'No',
                tax_number_type_ssn:             nil,
                tax_number_type_fein:            :set,
                ownership:                       'CORPORATION',
                w9_received:                     'Yes',
                w9_received_date:                '02/01/2014',
                attachment_file_name:            'vendor_attachment_test.png',
                insurance_requirements_complete: 'Yes',
                cornell_additional_ins_ind:      'Yes'
              }
              new_contract = {
                name:              'MH Drums',
                description:       'MH Drums Master Agreement',
                campus_code:       get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
                begin_date:        '02/05/2014',
                end_date:          '02/05/2016',
                manager:           'Scott Otey',
                po_cost_source:    'Pricing Agreement',
                b2b:               'No',
                payment_terms:     'Net 5 Days',
                default_apo_limit: '100000'
              }
              new_supplier_diversity = {
                type:                          'VETERAN OWNED',
                certification_expiration_date: '09/10/2015'
              }
              new_address = {
                type:                      'PO - PURCHASE ORDER',
                address_1:                 'PO Box 54777',
                address_2:                 '(127 Matt Street)',
                city:                      'Hanover',
                state:                     'MA',
                postal_code:               '02359',
                country:                   'United States',
                method_of_po_transmission: 'US MAIL'
              }
            when 'Contract' #KFSQA-636
              default_fields = {
                vendor_type:            'PO - PURCHASE ORDER',
                vendor_name:            'Phil Lesh Bass',
                foreign:                'No',
                tax_number_type_ssn:    nil,
                tax_number_type_fein:   :set,
                ownership:              'CORPORATION',
                w9_received:            'Yes',
                w9_received_date:       '02/01/2014'
              }
              file_to_attach = 'vendor_attachment_test.png'
              new_contract = {
                name:              'Lesh Bass Agreement',
                description:       'Lesh Bass Agreement, 8 String Bass',
                campus_code:       get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
                begin_date:        '02/05/2014',
                end_date:          '02/05/2016',
                manager:           'Scott Otey',
                po_cost_source:    'Pricing Agreement',
                b2b:               'No',
                payment_terms:     'Net 5 Days',
                default_apo_limit: '100000'
              }
              new_supplier_diversity = {
                type:                          'VETERAN OWNED',
                certification_expiration_date: '09/10/2015',
              }
              new_address = {
                type:                      'PO - PURCHASE ORDER',
                address_1:                 'PO Box 54777',
                address_2:                 '25 Boylston St.',
                city:                      'Boston',
                state:                     'MA',
                postal_code:               '02359',
                country:                   'United States',
                method_of_po_transmission: 'US MAIL'
              }

          end
        when 'e-SHOP'  # KFSQA-633
          default_fields = {
            vendor_name:          'J Garcia Guitars',
            foreign:              'No',
            tax_number_type_ssn:  nil,
            tax_number_type_fein: :set,
            ownership:            'CORPORATION',
            w9_received:          'Yes',
            w9_received_date:     '02/01/2014'
          }
          file_to_attach = 'vendor_attachment_test.png'
          new_supplier_diversity = {
            type:                          'VETERAN OWNED',
            certification_expiration_date: '09/10/2015'
          }
          new_address = {
            type:                      'PO - PURCHASE ORDER',
            address_1:                 'PO Box 63RF',
            address_2:                 '(127 Matt and Dave Street)	',
            city:                      'Hanover',
            state:                     'MA',
            postal_code:               '02359',
            country:                   'United States',
            method_of_po_transmission: 'US MAIL'
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
                insurance_requirements_complete: 'Yes',
                cornell_additional_ins_ind:      'Yes'
              }
              file_to_attach = 'vendor_attachment_test.png'
              new_supplier_diversity = {
                type:                          'HUBZONE',
                certification_expiration_date: '09/10/2015'
              }
              new_address = {
                type:                      'PO - PURCHASE ORDER',
                address_1:                 '66 Sunset Blvd',
                address_2:                 '(127 Walkway)',
                city:                      'Hollywood',
                state:                     'CA',
                postal_code:                   '91190',
                country:                   'United States',
                method_of_po_transmission: 'US MAIL'
              }
          end
      end
  end
  @vendor = create VendorObject, default_fields
  @vendor.update_line_objects_from_page!
  unless file_to_attach.empty?
    @vendor.notes_and_attachments_tab.add file: file_to_attach
  end
  unless new_address.empty?
    if @vendor.addresses.length.zero?
      @vendor.addresses.add new_address
    else
      @vendor.addresses.first.edit new_address
    end
  end
  unless new_supplier_diversity.empty?
    if @vendor.supplier_diversities.length.zero?
      @vendor.supplier_diversities.add new_supplier_diversity
    else
      @vendor.supplier_diversities.first.edit new_supplier_diversity.delete_if{ |k,v| k == :type }
    end
  end
  unless new_contract.empty?
    if @vendor.contracts.length.zero?
      @vendor.contracts.add new_contract
    else
      @vendor.contracts.first.edit new_contract
    end
  end

end

And /^I add a Contract to the Vendor document$/ do
  @vendor.contracts.add Hash.new # This relies on defaults being specified for a Contract. May need revision/replacement to be more useful.
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
  step "I lookup a Vendor with Vendor Number #{vendor_number}"
  on VendorPage do |page|
    page.description.fit random_alphanums(40, 'AFT')
    @vendor = make VendorObject, description: page.description.text.strip,
                                 document_id: page.document_id
    @vendor.absorb :old
    @document_id = @vendor.document_id
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
    page.expand_all
    if page.updated_phone_number.exists?
      case phone_field
        when 'Number'
          @vendor.phone_numbers.first.edit number: "607-#{rand(100..999)}-#{rand(1000..9999)}"
        when 'Extension'
          @vendor.phone_numbers.first.edit extension: rand(100..999)
        when 'Type'
          current_selection = @vendor.phone_numbers.first.type
          @vendor.phone_numbers.first.edit type: '::random::'
          while current_selection == @vendor.phone_numbers.first.type
            @vendor.phone_numbers.first.edit type: '::random::' # Try again if the random selector picked the current value
          end
      end
    else
      @vendor.phone_numbers.add number: "607-#{rand(100..999)}-#{rand(1000..9999)}", type: 'SALES'
    end
  end
end

And /^I change the Address (\w+) ?(\d)? on Vendor Address tab$/ do |line_or_attention, which_line|
  on VendorPage do |page|
    case line_or_attention
      when 'Line'
        case which_line
          when 1
            @vendor.addresses.first.edit address_1: random_alphanums(30, 'AFT')
          when 2
            @vendor.addresses.first.edit address_2: random_alphanums(30, 'AFT')
        end
      when 'Attention'
        @vendor.addresses.first.edit attention: random_alphanums(20, 'AFT')
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
    page.updated_address_1.value.strip.should == @vendor.addresses.first.address_1
    page.updated_phone_type.selected_options.first.text.should == @vendor.phone_numbers.first.type
    page.updated_address_2.value.strip.should == @vendor.addresses.first.address_2
    page.updated_phone_number.value.strip.should == @vendor.phone_numbers.first.number.to_s
    page.updated_address_attention.value.strip.should == @vendor.addresses.first.attention
    page.updated_phone_ext.value.strip.should == @vendor.phone_numbers.first.extension.to_s
  end
end

And /^I add an Address to a Vendor with following fields:$/ do |table|
  vendor_address = table.rows_hash
  vendor_address.delete_if { |k,v| v.empty? }
  @vendor.addresses.add type:        vendor_address['Address Type'] ||= '',
                        address_1:   vendor_address['Address 1'] ||= '',
                        address_2:   vendor_address['Address 2'] ||= '',
                        city:        vendor_address['City'] ||= '',
                        state:       vendor_address['State'] ||= '',
                        postal_code: vendor_address['Zip Code'] ||= '',
                        province:  vendor_address['Province'] ||= '',
                        country:   vendor_address['Country'] ||= '',
                        attention: vendor_address['Attention'] ||= '',
                        url:    vendor_address['URL'] ||= '',
                        fax:    vendor_address['Fax'] ||= '',
                        email:  vendor_address['Email'] ||= '',
                        active: yesno2setclear(vendor_address['Active'] ||= 'YES'),
                        set_as_default: vendor_address['Set As Default?'] ||= 'No',
                        method_of_po_transmission: vendor_address['Method of PO Transmission'] ||= '' # Cornell-specific mod
  @added_address = @vendor.addresses.find_all do |addr|
    addr.type == (vendor_address['Address Type'] ||= '') and
    addr.address_1 == (vendor_address['Address 1'] ||= '') and
    addr.address_2 == (vendor_address['Address 2'] ||= '') and
    addr.city == (vendor_address['City'] ||= '') and
    addr.state == (vendor_address['State'] ||= '') and
    addr.postal_code == (vendor_address['Zip Code'] ||= '') and
    addr.province == (vendor_address['Province'] ||= '') and
    addr.country == (vendor_address['Country'] ||= '') and
    addr.attention == (vendor_address['Attention'] ||= '') and
    addr.url == (vendor_address['URL'] ||= '') and
    addr.fax == (vendor_address['Fax'] ||= '') and
    addr.email == (vendor_address['Email'] ||= '') and
    addr.active == (yesno2setclear(vendor_address['Active'] ||= 'YES')) and
    addr.set_as_default == (vendor_address['Set As Default?'] ||= 'No') and
    addr.method_of_po_transmission == (vendor_address['Method of PO Transmission'] ||= '')
  end.sort{|a, b| a.line_number <=> b.line_number}.last
end

And /^I update the General Liability with expired date$/ do
  @changed_liability = {} if @changed_liability.nil?
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
  on(VendorPage).close
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
                   w9_received_date:           yesterday[:date_w_slashes]
  new_supplier_diversity = {
      type:                          'HUBZONE',
      certification_expiration_date: tomorrow[:date_w_slashes]
  }
  new_address = {
    type:                      'RM - REMIT',
    address_1:                 'PO Box 54777',
    address_2:                 '(127 Matt Street)',
    city:                      'Hanover',
    state:                     'MA',
    postal_code:               '02359',
    country:                   'United States',
    set_as_default:            'Yes',
    method_of_po_transmission: ''
  }
  @vendor.update_line_objects_from_page!
  @vendor.notes_and_attachments_tab.add file: 'vendor_edit_attachment_2.png'
  unless new_address.empty?
    if @vendor.addresses.length.zero?
      @vendor.addresses.add new_address
    else
      @vendor.addresses.first.edit new_address
    end
  end
  unless new_supplier_diversity.empty?
    if @vendor.supplier_diversities.length.zero?
      @vendor.supplier_diversities.add new_supplier_diversity
    else
      @vendor.supplier_diversities.first.edit new_supplier_diversity.delete_if{ |k,v| k == :type }
    end
  end

end

And /^I can not view the Tax ID and Attachments on Vendor page$/ do
  on VendorPage do |page|
    page.hidden_tax_number.parent.text.should include ('Tax Number: *********')
    page.notes_table.rows.length.should == 2
  end
end

And /^I enter a default payment method (\w+) on Vendor Page$/ do |payment_method|
  # FIXME: Should probably use the VendorObject#edit method...
  @vendor.default_payment_method = payment_method
  on(VendorPage).default_payment_method.fit payment_method
end

And /^the Address changes persist$/ do
  on VendorPage do |page|
    page.expand_all
    page.updated_address_1.value.should == @vendor.addresses[0].address_1
    page.updated_2nd_address_2.value.should == @vendor.addresses[1].address_2
  end
end

And /^I change Remit Address and the Foreign Tax Address$/ do
  @vendor.addresses[0].edit address_1: random_alphanums(30, 'AFT')
  @vendor.addresses[1].edit address_2: random_alphanums(30, 'AFT')
end

And /^I lookup a Vendor with Vendor Number (.*)$/ do |vendor_number|
  visit(MainPage).vendor
  on VendorLookupPage do |page|
    page.active_indicator_yes.set
    page.vendor_number.fit vendor_number
    page.search
    page.edit_item vendor_number # This should throw a fail if the item isn't found.
  end
end

And /^I open the Vendor from the Vendor document$/ do
  visit(MainPage).vendor
  on VendorLookupPage do |page|
    page.vendor_number.fit @vendor.vendor_number
    page.search
    page.open_item_via_text @vendor.vendor_name, @vendor.vendor_name # This should throw a fail if the item isn't found.
  end
end

And /^I lookup a PO Vendor$/ do
  step "I lookup a Vendor with Vendor Number #{get_aft_parameter_value(ParameterConstants::DEFAULT_VENDOR_NUMBER)}"
end

And /^I edit a PO Vendor$/ do
  step 'I lookup a PO Vendor'
  @vendor = make VendorObject
  on(VendorPage).description.fit @vendor.description
  @vendor.absorb(:old)
  @document_id = @vendor.document_id
end

And /^I add a Search Alias to the Vendor document$/ do
    @vendor.search_aliases.update_from_page!
    @vendor.search_aliases.add Hash.new # We'll just add the default value.
                                        # For some reason, we still need to provide an empty hash.
end

And /^I add a Supplier Diversity to the Vendor document$/ do
  @vendor.supplier_diversities.update_from_page!
  @vendor.supplier_diversities.add Hash.new # We'll just add the default value.
                                            # For some reason, we still need to provide an empty hash.
end

Then /^the Address Tab displays Vendor Address Generated Identifiers for each Address$/ do
  on VendorPage do |vp|
    @vendor.addresses.each do |addr|
      vp.vendor_address_generated_identifier(addr.line_number).nil?.should_not
      addr.vendor_address_generated_identifier = vp.vendor_address_generated_identifier(addr.line_number) # Let's load this in, just in case
    end
  end
end

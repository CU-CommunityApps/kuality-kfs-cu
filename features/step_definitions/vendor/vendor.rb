When /^I create an? (Corporation|Individual) and (Foreign|Non-Foreign|e-SHOP) Vendor( with .*)?$/ do |ownership_type, sub_type, tab_1|
  tab_1.gsub!(/^ with /, '') unless tab_1.nil?
  default_fields = Hash.new
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
            ownership:            'CORPORATION',
            initial_supplier_diversities: [{
                                             type:                          'VETERAN OWNED',
                                             certification_expiration_date: '09/10/2015',
                                            }],
            initial_addresses: [{
                                  type:                      'PO - PURCHASE ORDER',
                                  address_1:                 'PO Box 5466',
                                  address_2:                 '(127 Matt Street)',
                                  city:                      'Hanover',
                                  state:                     'MA',
                                  postal_code:               '02359',
                                  country:                   'United States',
                                  method_of_po_transmission: 'US MAIL'
                                }]
          }
          file_to_attach = 'vendor_attachment_test.png'
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
                insurance_requirements_complete: 'Yes',
                cornell_additional_ins_ind:      'Yes',
                initial_contracts: [{
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
                                    }],
                initial_supplier_diversities: [{
                                                 type:                          'VETERAN OWNED',
                                                 certification_expiration_date: '09/10/2015'
                                               }],
                initial_addresses: [{
                                      type:                      'PO - PURCHASE ORDER',
                                      address_1:                 'PO Box 54777',
                                      address_2:                 '(127 Matt Street)',
                                      city:                      'Hanover',
                                      state:                     'MA',
                                      postal_code:               '02359',
                                      country:                   'United States',
                                      method_of_po_transmission: 'US MAIL'
                                    }]
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
                w9_received_date:       '02/01/2014',
                initial_contracts: [{
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
                                    }],
                initial_supplier_diversities: [{
                                                 type:                          'VETERAN OWNED',
                                                 certification_expiration_date: '09/10/2015',
                                               }],
                initial_addresses: [{
                                      type:                      'PO - PURCHASE ORDER',
                                      address_1:                 'PO Box 54777',
                                      address_2:                 '25 Boylston St.',
                                      city:                      'Boston',
                                      state:                     'MA',
                                      postal_code:               '02359',
                                      country:                   'United States',
                                      method_of_po_transmission: 'US MAIL'
                                    }]
              }
              file_to_attach = 'vendor_attachment_test.png'
            else
              pending "Supplied with-suffix (#{tab_1}) inputs have not been defined yet."
          end
        when 'e-SHOP'  # KFSQA-633
          default_fields = {
            vendor_name:          'J Garcia Guitars',
            foreign:              'No',
            tax_number_type_ssn:  nil,
            tax_number_type_fein: :set,
            ownership:            'CORPORATION',
            w9_received:          'Yes',
            w9_received_date:     '02/01/2014',
            initial_supplier_diversities: [{
                                             type:                          'VETERAN OWNED',
                                             certification_expiration_date: '09/10/2015'
                                           }],
            initial_addresses: [{
                                  type:                      'PO - PURCHASE ORDER',
                                  address_1:                 'PO Box 63RF',
                                  address_2:                 '(127 Matt and Dave Street)	',
                                  city:                      'Hanover',
                                  state:                     'MA',
                                  postal_code:               '02359',
                                  country:                   'United States',
                                  method_of_po_transmission: 'US MAIL'
                                }]
          }
          file_to_attach = 'vendor_attachment_test.png'
        else
          pending "Supplied ownership sub type (#{sub_type}) inputs have not been defined yet."
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
                cornell_additional_ins_ind:      'Yes',
                initial_supplier_diversities: [{
                                                 type:                          'HUBZONE',
                                                 certification_expiration_date: '09/10/2015'
                                               }],
                initial_addresses: [{
                                      type:                      'PO - PURCHASE ORDER',
                                      address_1:                 '66 Sunset Blvd',
                                      address_2:                 '(127 Walkway)',
                                      city:                      'Hollywood',
                                      state:                     'CA',
                                      postal_code:                   '91190',
                                      country:                   'United States',
                                      method_of_po_transmission: 'US MAIL'
                                    }]
              }
              file_to_attach = 'vendor_attachment_test.png'
            else
              pending "Supplied with-suffix (#{tab_1}) inputs have not been defined yet."
          end
        else
          pending "Supplied ownership sub type (#{sub_type}) inputs have not been defined yet."
      end
    else
      pending "Supplied ownership type (#{ownership_type}) inputs have not been defined yet."
  end
  @vendor = create VendorObject, default_fields
  @vendor.update_line_objects_from_page!
  @vendor.notes_and_attachments_tab.add file: file_to_attach unless file_to_attach.empty?


end

And /^I create a DV Vendor$/  do
  @vendor = create VendorObject,
                   vendor_type:                'DV - DISBURSEMENT VOUCHER',
                   vendor_name:                 nil,
                   vendor_last_name:           'Twenty**************',
                   vendor_first_name:          'Twenty-Three***********',
                   foreign:                    'No',
                   tax_number_type_ssn:         nil,
                   tax_number_type_fein:        :set,
                   ownership:                  'CORPORATION',
                   w9_received:                'Yes',
                   w9_received_date:           yesterday[:date_w_slashes],
                   note_text:                  'here is a note',
                   initial_supplier_diversities: [{
                                                    type:                          'HUBZONE',
                                                    certification_expiration_date: tomorrow[:date_w_slashes]
                                                  }],
                   initial_addresses: [{
                                         type:                      'RM - REMIT',
                                         address_1:                 'PO Box 54777',
                                         address_2:                 '(127 Matt Street)',
                                         city:                      'Hanover',
                                         state:                     'MA',
                                         postal_code:               '02359',
                                         country:                   'United States',
                                         set_as_default:            'Yes',
                                         method_of_po_transmission: ''
                                       }]
  @vendor.update_line_objects_from_page!
  @vendor.notes_and_attachments_tab.add file: 'vendor_edit_attachment_2.png'

end

When /^I start a Purchase Order Vendor document with the following fields:$/ do |fields|
  fields = fields.to_data_object_attr
  raise ArgumentError, 'Invalid Tax Number Type provided!' unless (fields[:tax_number_type].upcase == 'FEIN' ||
                                                                   fields[:tax_number_type].upcase == 'SSN' ||
                                                                   fields[:tax_number_type].upcase == 'NONE')

  unless fields[:tax_number_type].nil?
    fields["tax_number_type_#{fields[:tax_number_type].downcase}".to_sym] = :set
    fields[:tax_number_type_fein] = nil if fields[:tax_number_type_fein].nil?
    fields[:tax_number_type_ssn] = nil if fields[:tax_number_type_ssn].nil?
    fields[:tax_number_type_none] = nil if fields[:tax_number_type_none].nil?
    fields.delete_if { |k, v| k == :tax_number_type }
  end

  fields[:w9_received_date] = to_standard_date(fields[:w9_received_date]) unless fields[:w9_received_date].nil?

  fields[:initial_addresses] = [{
                                  type:                      'PO - PURCHASE ORDER',
                                  address_1:                 '123 Main Street',
                                  address_2:                 '',
                                  attention:                 '',
                                  url:                       '',
                                  fax:                       '',
                                  province:                  '',
                                  city:                      'Ithaca',
                                  state:                     'NY',
                                  postal_code:               '14850',
                                  country:                   'United States',
                                  email:                     'ksa23@cornell.edu',
                                  set_as_default:            'Yes',
                                  active:                    :set,
                                  method_of_po_transmission: 'E-MAIL'
                                }] if fields[:initial_addresses].nil?

  @vendor = create VendorObject, fields
end

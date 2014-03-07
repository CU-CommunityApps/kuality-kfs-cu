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
                      contract_campus_code:       'IT - Ithaca',
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
                  contract_campus_code:       'IT - Ithaca',
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
    page.note_text.fit @vendor.note_text
    page.attach_notes_file.set($file_folder+@vendor.attachment_file_name)
    page.add_note
    page.attach_notes_file_1.should exist #verify that note is indeed added

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
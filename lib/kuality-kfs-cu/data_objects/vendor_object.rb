#overriding kuality-kfs object
# class VendorObject
#
#   attr_accessor :supplier_diversities
#
#   def defaults
#     super.merge({
#       vendor_type:                'PO - PURCHASE ORDER',
#       vendor_name:                'Keith, inc',
#       foreign:                    'No',
#       tax_number:                 "999#{rand(9)}#{rand(1..9)}#{rand(1..9999).to_s.rjust(4, '0')}",
#       tax_number_type_ssn:        :set,
#       ownership:                  'INDIVIDUAL/SOLE PROPRIETOR',
#       w9_received:                'Yes',
#       w9_received_date:           yesterday[:date_w_slashes],
#       supplier_diversity:         'HUBZONE',
#       supplier_diversity_expiration_date: tomorrow[:date_w_slashes],
#       search_aliases:             collection('SearchAliasLineObject'),
#       phone_numbers:              collection('PhoneLineObject'),
#       addresses:                  collection('AddressLineObject'),
#       contacts:                   collection('ContactLineObject'),
#       supplier_diversities:       collection('SupplierDiversityLineObject')
#     })
#   end
#
#   def update_line_objects_from_page!
#     super
#     @phone_numbers.update_from_page!
#     @addresses.update_from_page!
#     @supplier_diversities.update_from_page!
#   end
#
# end

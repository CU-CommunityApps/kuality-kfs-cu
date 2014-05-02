#overriding kuality-kfs object
class VendorObject

   attr_accessor :w9_received_date, :default_payment_method,
                 :general_liability_coverage_amt, :general_liability_expiration_date,
                 :automobile_liability_coverage_amt, :automobile_liability_expiration_date,
                 :workman_liability_coverage_amt,:workman_liability_expiration_date,
                 :excess_liability_umb_amt, :excess_liability_umb_expiration_date,
                 :health_offset_lic_expiration_date, :health_offsite_catering_lic_req,
                 :cornell_additional_ins_ind, :insurance_note,
                 :insurance_requirements_complete, :insurance_requirement_indicator,
                 # == Collections ==
                 :supplier_diversities

   def defaults
     super.merge({
       vendor_type:                'PO - PURCHASE ORDER',
       vendor_name:                'Keith, inc',
       foreign:                    'No',
       tax_number:                 "999#{rand(9)}#{rand(1..9)}#{rand(1..9999).to_s.rjust(4, '0')}",
       tax_number_type_ssn:        :set,
       ownership:                  'INDIVIDUAL/SOLE PROPRIETOR',
       w9_received:                'Yes',
       w9_received_date:           yesterday[:date_w_slashes],
       search_aliases:             collection('SearchAliasLineObject'),
       phone_numbers:              collection('PhoneLineObject'),
       addresses:                  collection('AddressLineObject'),
       contacts:                   collection('ContactLineObject'),
       contracts:                  collection('ContractLineObject'),
       supplier_diversities:       collection('SupplierDiversityLineObject')
     })
   end

  def fill_out_extended_attributes
    fill_out page, :w9_received_date, :default_payment_method
    @supplier_diversities.add Hash.new
  end

  def update_line_objects_from_page!(target=:new)
    super
    @phone_numbers.update_from_page!(target)
    @addresses.update_from_page!(target)
    @contacts.update_from_page!(target)
    @contracts.update_from_page!(target)
    @supplier_diversities.update_from_page!(target) # FIXME: Copy this entire method to kuality-kfs-cu project, then remove this line here
  end

   # @return [Hash] The return values of extended attributes for the old Vendor
   # @param [Symbol] target The set of Vendor data to pull in
   def pull_vendor_extended_data(target=:new)
     pulled_vendor = Hash.new
     on VendorPage do |vp|
       case target
         when :old
           pulled_vendor = {
             w9_received_date: vp.old_w9_received_date,
             default_payment_method: vp.old_default_payment_method,
             general_liability_coverage_amt:       vp.old_general_liability_coverage_amt,
             general_liability_expiration_date:    vp.old_general_liability_expiration_date,
             automobile_liability_coverage_amt:    vp.old_automobile_liability_coverage_amt,
             automobile_liability_expiration_date: vp.old_automobile_liability_expiration_date,
             workman_liability_coverage_amt:       vp.old_workman_liability_coverage_amt,
             workman_liability_expiration_date:    vp.old_workman_liability_expiration_date,
             excess_liability_umb_amt: vp.old_excess_liability_umb_amt,
             excess_liability_umb_expiration_date: vp.old_excess_liability_umb_expiration_date,
             health_offset_lic_expiration_date:    vp.old_health_offset_lic_expiration_date,
             insurance_note: vp.old_insurance_note,
             cornell_additional_ins_ind:      vp.old_cornell_additional_ins_ind,
             health_offsite_catering_lic_req: vp.old_health_offsite_catering_lic_req,
             insurance_requirements_complete: vp.old_insurance_requirements_complete,
             insurance_requirement_indicator: vp.old_insurance_requirement_indicator
           }
         when :new
           pulled_vendor = {
             w9_received_date: vp.new_w9_received_date.value.strip,
             default_payment_method: vp.new_default_payment_method.value.strip,
             general_liability_coverage_amt:       vp.new_general_liability_coverage_amt.value.strip,
             general_liability_expiration_date:    vp.new_general_liability_expiration_date.value.strip,
             automobile_liability_coverage_amt:    vp.new_automobile_liability_coverage_amt.value.strip,
             automobile_liability_expiration_date: vp.new_automobile_liability_expiration_date.value.strip,
             workman_liability_coverage_amt:       vp.new_workman_liability_coverage_amt.value.strip,
             workman_liability_expiration_date:    vp.new_workman_liability_expiration_date.value.strip,
             excess_liability_umb_amt: vp.new_excess_liability_umb_amt.value.strip,
             excess_liability_umb_expiration_date: vp.new_excess_liability_umb_expiration_date.value.strip,
             health_offset_lic_expiration_date:    vp.new_health_offset_lic_expiration_date.value.strip,
             insurance_note: vp.new_insurance_note.value.strip,
             cornell_additional_ins_ind:      vp.new_cornell_additional_ins_ind.selected_options.first.text.strip,
             health_offsite_catering_lic_req: vp.new_health_offsite_catering_lic_req.selected_options.first.text.strip,
             insurance_requirements_complete: vp.new_insurance_requirements_complete.selected_options.first.text.strip,
             insurance_requirement_indicator: yesno2setclear(vp.new_insurance_requirement_indicator.value.strip)
           }
       end
     end
     pulled_vendor
   end

end

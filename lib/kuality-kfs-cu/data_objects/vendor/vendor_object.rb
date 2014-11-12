#overriding kuality-kfs object
class VendorObject

  include SupplierDiversityLinesMixin

  attr_accessor :w9_received_date, :default_payment_method,
                # == Insurance Tracking Tab (wouldn't hurt to break it off eventually) ==
                :general_liability_coverage_amt, :general_liability_expiration_date,
                :automobile_liability_coverage_amt, :automobile_liability_expiration_date,
                :workman_liability_coverage_amt,:workman_liability_expiration_date,
                :excess_liability_umb_amt, :excess_liability_umb_expiration_date,
                :health_offset_lic_expiration_date, :health_offsite_catering_lic_req,
                :cornell_additional_ins_ind, :insurance_note,
                :insurance_requirements_complete, :insurance_requirement_indicator

  def extended_defaults
    { default_payment_method: 'P - ACH/CHECK', w9_received_date: yesterday[:date_w_slashes] }.merge(default_supplier_diversities)
  end

  def fill_out_extended_attributes
    on(VendorPage) do |page|
      fill_out page, :w9_received_date, :default_payment_method,
                     :general_liability_coverage_amt, :general_liability_expiration_date,
                     :automobile_liability_coverage_amt, :automobile_liability_expiration_date,
                     :workman_liability_coverage_amt, :workman_liability_expiration_date,
                     :excess_liability_umb_amt, :excess_liability_umb_expiration_date,
                     :health_offset_lic_expiration_date, :health_offsite_catering_lic_req,
                     :cornell_additional_ins_ind, :insurance_note,
                     :insurance_requirements_complete, :insurance_requirement_indicator
    end
  end

  # @return [Hash] The return values of extended attributes for the old Vendor
  # @param [Symbol] target The set of Vendor data to pull in
  def pull_vendor_extended_data(target=:new)
    pulled_vendor = Hash.new
    on VendorPage do |vp|
      case target
      when :old
        pulled_vendor = {
            w9_received_date: vp.w9_received_date_old,
            default_payment_method: vp.default_payment_method_old,
            general_liability_coverage_amt:       vp.general_liability_coverage_amt_old,
            general_liability_expiration_date:    vp.general_liability_expiration_date_old,
            automobile_liability_coverage_amt:    vp.automobile_liability_coverage_amt_old,
            automobile_liability_expiration_date: vp.automobile_liability_expiration_date_old,
            workman_liability_coverage_amt:       vp.workman_liability_coverage_amt_old,
            workman_liability_expiration_date:    vp.workman_liability_expiration_date_old,
            excess_liability_umb_amt: vp.excess_liability_umb_amt_old,
            excess_liability_umb_expiration_date: vp.excess_liability_umb_expiration_date_old,
            health_offset_lic_expiration_date:    vp.health_offset_lic_expiration_date_old,
            insurance_note: vp.insurance_note_old,
            cornell_additional_ins_ind:      vp.cornell_additional_ins_ind_old,
            health_offsite_catering_lic_req: vp.health_offsite_catering_lic_req_old,
            insurance_requirements_complete: vp.insurance_requirements_complete_old,
            insurance_requirement_indicator: yesno2setclear(vp.insurance_requirement_indicator_old)
        }
      when :new
        pulled_vendor = {
            w9_received_date: vp.w9_received_date_new,
            default_payment_method: vp.default_payment_method_new,
            general_liability_coverage_amt:       vp.general_liability_coverage_amt_new,
            general_liability_expiration_date:    vp.general_liability_expiration_date_new,
            automobile_liability_coverage_amt:    vp.automobile_liability_coverage_amt_new,
            automobile_liability_expiration_date: vp.automobile_liability_expiration_date_new,
            workman_liability_coverage_amt:       vp.workman_liability_coverage_amt_new,
            workman_liability_expiration_date:    vp.workman_liability_expiration_date_new,
            excess_liability_umb_amt: vp.excess_liability_umb_amt_new,
            excess_liability_umb_expiration_date: vp.excess_liability_umb_expiration_date_new,
            health_offset_lic_expiration_date:    vp.health_offset_lic_expiration_date_new,
            insurance_note: vp.insurance_note_new,
            cornell_additional_ins_ind:      vp.cornell_additional_ins_ind_new,
            health_offsite_catering_lic_req: vp.health_offsite_catering_lic_req_new,
            insurance_requirements_complete: vp.insurance_requirements_complete_new,
            insurance_requirement_indicator: yesno2setclear(vp.insurance_requirement_indicator_new)
        }
      end
    end
    pulled_vendor
  end

end

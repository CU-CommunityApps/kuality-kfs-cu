When /^I start an empty Disbursement Voucher document$/ do
  @disbursement_voucher = create DisbursementVoucherObject
end

When /^I save a Disbursement Voucher document with only the Description field populated$/ do
  default_fields = {
      auto_populate:               'N'
  }
  @disbursement_voucher = create DisbursementVoucherObject, default_fields.merge({press: :save})
end

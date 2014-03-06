When /^I start an empty Disbursement Voucher document$/ do
  @disbursement_voucher = create DisbursementVoucherObject
end

When /^I save a Disbursement Voucher document with only the Description field populated$/ do
  @disbursement_voucher = create DisbursementVoucherObject, {press: :save}
end

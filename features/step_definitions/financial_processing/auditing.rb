And /^I add accounting lines to test the notes tab for the Budget Adjustment doc$/ do

  on BudgetAdjustmentPage do

    @budget_adjustment.add_source_line({
      account_number: 'G003704',
      object: '4480',
      current_amount: '250'
    })
    @budget_adjustment.add_source_line({
      account_number: 'G003704',
      object: '6510',
      current_amount: '250'
    })
    @budget_adjustment.add_target_line({
      account_number: 'G013300',
      object: '4480',
      current_amount: '250'
    })
    @budget_adjustment.add_target_line({
      account_number: 'G013300',
      object: '6510',
      current_amount: '250'
    })
  end
end

And /^I add accounting lines to test the notes tab for the Auxiliary Voucher doc$/   do
  on AuxiliaryVoucherPage do
  @auxiliary_voucher.add_source_line({
    account_number: 'H853800',
    object: '6690',
    debit: '100'
  })
  @auxiliary_voucher.add_source_line({
    account_number: 'H853800',
    object: '6690',
    credit: '100'
  })
  end
end

And /^I add accounting lines to test the notes tab for the General Error Correction doc$/ do
  on GeneralErrorCorrectionPage do

    @general_error_correction.add_source_line({
      account_number: 'G003704',
      object: '4480',
      amount: '255.55',
      reference_origin_code: '01',
      reference_number: '777001'
    })

    @general_error_correction.add_target_line({
      account_number: 'G013300',
      object: '4480',
      amount: '255.55',
      reference_origin_code: '01',
      reference_number: '777002'
    })
  end
end

And /^I add accounting lines to test the notes tab for the Pre-Encumbrance doc$/ do
  on PreEncumbrancePage do
    @pre_encumbrance.add_source_line({
      account_number: 'G003704',
      object: '6540',
      amount: '345000'
    })
  end
end

And /^I add accounting lines to test the notes tab for the Non Check Disbursement doc$/ do
  on NonCheckDisbursementPage do
    @non_check_disbursement.add_source_line({
      account_number: 'G003704',
      object: '6540',
      amount: '200000.22',
      reference_number: '1234'
    })
  end
end

And  /^I create the Auxiliary Voucher document with a Reversal Date$/ do
    @auxilary_voucher = create AuxiliaryVoucherObject,
                               auxiliary_voucher_type_accrual: :set

end

And /^I add a "(Debit|Credit)" Accounting Line with:$/ do |deb_cred, table|
  updates = table.rows_hash

  case deb_cred

    when 'Debit'
     on AuxiliaryVoucherPage do
       @auxiliary_voucher.add_from_line({
          from_account_number: updates['account number'],
          from_object_code: updates['object code'],
          debit: updates['debit']
        })
     end

    when 'Credit'

      on AuxiliaryVoucherPage do
        @auxiliary_voucher.add_from_line({
          from_account_number: updates['account number'],
          from_object_code: updates['object code'],
          credit: updates['credit']
        })
      end

  end
end
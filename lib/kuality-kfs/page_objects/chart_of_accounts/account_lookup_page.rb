class AccountLookup < Lookups

    element(:chart_code) { |b| b.frm.text_field(id: 'chartOfAccountsCode') }
    element(:number) { |b| b.frm.text_field(id: 'accountNumber') }

end
class AccountLookup < Lookups

  element(:chart_code) { |b| b.frm.text_field(name: 'chartOfAccountsCode') }
  element(:number) { |b| b.frm.text_field(name: 'accountNumber') }
  element(:name) { |b| b.frm.text_field(name: 'accountName') }
  element(:org_cd) { |b| b.frm.text_field(name: 'organizationCode') }
  element(:type_cd) { |b| b.frm.select(name: 'accountTypeCode') }
  element(:sub_fnd_group_cd) { |b| b.frm.text_field(name: 'subFundGroupCode') }
  element(:fo_principal_name) { |b| b.frm.text_field(name: 'accountFiscalOfficerUser.principalName') }
  element(:closed) { |b| b.frm.text_field(name: 'closed') }

end
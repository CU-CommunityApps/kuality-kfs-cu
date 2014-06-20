#overriding kuality-kfs object
class AccountingLine

  element(:source_auto_dis_encumber_type) { |b| b.frm.select(name: 'newSourceLine.autoDisEncumberType') }
  element(:source_partial_transaction_count) { |b| b.frm.text_field(name: 'newSourceLine.partialTransactionCount') }
  element(:source_start_date) { |b| b.frm.text_field(name: 'newSourceLine.startDate') }
  element(:source_end_date) { |b| b.frm.text_field(name: 'newSourceLine.endDate') }
  element(:source_partial_amount) { |b| b.frm.text_field(name: 'newSourceLine.partialAmount') }

end
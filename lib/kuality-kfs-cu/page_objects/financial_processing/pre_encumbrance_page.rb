#overriding kuality-kfs object
class PreEncumbrancePage

  #accounting_lines_encumbrance_disencumbrance
  #ENCUMBRANCE
  #CU specific attributes
  element(:source_auto_dis_encumber_type) { |b| b.frm.select(name: 'newSourceLine.autoDisEncumberType') }
  alias_method :encumbrance_auto_dis_encumber_type, :source_auto_dis_encumber_type

  element(:source_partial_transaction_count) { |b| b.frm.text_field(name: 'newSourceLine.partialTransactionCount') }
  alias_method :encumbrance_count, :source_partial_transaction_count

  element(:source_start_date) { |b| b.frm.text_field(name: 'newSourceLine.startDate') }
  alias_method :encumbrance_start_date, :source_start_date

  element(:source_end_date) { |b| b.frm.text_field(name: 'newSourceLine.endDate.div') }
  alias_method :encumbrance_end_date, :source_end_date

  element(:source_partial_amount) { |b| b.frm.text_field(name: 'newSourceLine.partialAmount') }
  alias_method :encumbrance_partial_amount, :source_partial_amount

  #DISENCUMBRANCE
  #CU specific attribute
  alias_method :disencumbrance_line_description, :target_line_description

end

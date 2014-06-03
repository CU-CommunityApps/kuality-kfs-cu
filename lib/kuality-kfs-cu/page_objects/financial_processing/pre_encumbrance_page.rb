#overriding kuality-kfs object
class PreEncumbrancePage

  #accounting_lines_encumbrance_disencumbrance
  #ENCUMBRANCE
  #CU specific attributes
  element(:encumbrance_auto_disencumber_type) { |b| b.frm.select(name: 'newSourceLine.autoDisEncumberType') }
  element(:encumbrance_count) { |b| b.frm.text_field(name: 'newSourceLine.partialTransactionCount') }
  element(:encumbrance_start_date) { |b| b.frm.text_field(name: 'newSourceLine.startDate') }
  element(:encumbrance_partial_amount) { |b| b.frm.text_field(name: 'newSourceLine.partialAmount') }

  #DISENCUMBRANCE
  #CU specific attribute
  element(:disencumbrance_line_description) { |b| b.frm.text_field(name: 'newTargetLine.financialDocumentLineDescription') }

end

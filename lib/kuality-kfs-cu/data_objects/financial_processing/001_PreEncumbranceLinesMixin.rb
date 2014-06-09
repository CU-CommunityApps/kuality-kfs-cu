module PreEncumbranceLinesMixin
  include AccountingLinesMixin
  extend AccountingLinesMixin

  def default_accounting_lines(opts={})
    {
        accounting_lines: {
            source: collection('PreEncumbranceLineObject'),
            target: collection('PreEncumbranceLineObject')
        },
        initial_lines:    [],
        immediate_import: true
    }.merge(opts)
  end

end

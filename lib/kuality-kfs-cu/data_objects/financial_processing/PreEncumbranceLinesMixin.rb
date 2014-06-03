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

  def add_line(type, al)
    @accounting_lines[type].add(al.merge({type: type}))
  end

  def add_target_line(al)
    add_line(:target, al)
  end

  def add_source_line(al)
    add_line(:source, al)
  end

end
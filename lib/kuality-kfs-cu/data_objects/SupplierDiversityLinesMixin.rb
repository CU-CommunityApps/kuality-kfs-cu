module SupplierDiversityLinesMixin

  attr_accessor :supplier_diversities, :initial_supplier_diversities

  def default_supplier_diversities(opts={})
    # This just makes it so we don't have to be so repetitive. It can certainly be
    # overridden in a subclass if you don't want to chuck things in via opts.
    {
      supplier_diversities:         collection('SupplierDiversityLineObject'),
      initial_supplier_diversities: [ Hash.new ] # Let's always add a supplier diversity.
    }.merge(opts)
  end

  def post_create
    super
    @initial_supplier_diversities.each{ |il| @supplier_diversities.add il }
    @initial_supplier_diversities = nil
  end

  def update_extended_line_objects_from_page!(target=:new)
    @supplier_diversities.update_from_page! target
    super
  end

end
class SupplierDiversityLineObject < DataFactory

  include DateFactory
  include StringFactory

  attr_accessor   :line_number,
                  :type, :certification_expiration_date, :active

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      type:                          '',
      certification_expiration_date: tomorrow[:date_w_slashes],
      active:                        :set
    }

    set_options(defaults.merge(opts))
  end

  def create
    on VendorPage do |vp|
      vp.new_supplier_diversity_type.fit                          @type
      vp.new_supplier_diversity_active.fit                        @active
      vp.new_supplier_diversity_certification_expiration_date.fit @certification_expiration_date
      fill_out_extended_attributes
      vp.add_supplier_diversity
    end
  end

  def edit(opts={})
    raise ArgumentError, 'Supplier Diversity type cannot be updated!' unless opts[:type].nil?
    on(VendorPage).supplier_diversity_certification_expiration_date(@line_number).fit opts[:certification_expiration_date] unless opts[:certification_expiration_date].nil?
    on(VendorPage).supplier_diversity_active(@line_number).fit opts[:active] unless opts[:active].nil?
    update_options(opts)
  end

  def delete
    raise NoMethodError, 'There is no way to delete a Supplier Diversity from a Vendor. Perhaps you have a site-specific extension?'
  end

  def fill_out_extended_attributes
    # Override this method if you have site-specific extended attributes.
  end

  def update_extended_attributes(opts = {})
    # Override this method if you have site-specific extended attributes.
  end
  alias_method :edit_extended_attributes, :update_extended_attributes

end

class SupplierDiversityLineObjectCollection < LineObjectCollection

  contains SupplierDiversityLineObject

  def update_from_page!
    on VendorPage do |lines|
      clear # Drop any cached lines. More reliable than sorting out an array merge.

      lines.expand_all
      unless lines.current_supplier_diversity_count.zero?
        (0..(lines.current_supplier_diversity_count - 1)).to_a.collect!{ |i|
          lines.pull_existing_supplier_diversity(i).merge(pull_extended_existing_supplier_diversity(i))
        }.each { |new_obj|
          # Update the stored lines
          self << (make contained_class, new_obj)
        }
      end

    end
  end

  # @return [Hash] The return values of extended attributes for the given line
  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Watir::Browser] b The current browser object
  # @return [Hash] The known line values
  def pull_extended_existing_supplier_diversity(i=0)
    # This can be implemented for site-specific attributes. See the Hash returned in
    # the #collect! in #update_from_page! above for the kind of way to get the
    # right return value.
    Hash.new
  end

end
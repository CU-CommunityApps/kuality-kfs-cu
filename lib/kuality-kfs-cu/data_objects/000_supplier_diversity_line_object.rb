class SupplierDiversityLineObject < DataFactory

  include DateFactory
  include StringFactory
  include GlobalConfig

  attr_accessor   :line_number,
                  :type, :certification_expiration_date, :active

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
      type:                          '::random::',
      certification_expiration_date: tomorrow[:date_w_slashes],
      active:                        :set
    }

    set_options(defaults.merge(opts))
  end

  def create
    on VendorPage do |vp|
      if !@type.nil? && @type.empty?
        vp.new_supplier_diversity_type.pick!                      ''
      else
        vp.new_supplier_diversity_type.pick!                      @type
        while @type.empty?
          # This will only happen when we try to pick a random one and it selects the
          # empty type. We want it to actually pick a valid one if we're going to add it.
          @type = '::random::'
          vp.new_supplier_diversity_type.pick!                    @type
        end
      end
      vp.new_supplier_diversity_active.fit                        @active
      vp.new_supplier_diversity_certification_expiration_date.fit @certification_expiration_date
      fill_out_extended_attributes
      vp.add_supplier_diversity
    end
  end

  def edit(opts={})
    raise ArgumentError, 'Supplier Diversity type cannot be updated!' unless opts[:type].nil?
    on(VendorPage).update_supplier_diversity_certification_expiration_date(@line_number).fit opts[:certification_expiration_date]
    on(VendorPage).update_supplier_diversity_active(@line_number).fit opts[:active]
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

  def update_from_page!(target=:new)
    on VendorPage do |lines|
      clear # Drop any cached lines. More reliable than sorting out an array merge.

      lines.expand_all
      unless lines.current_supplier_diversity_count.zero?
        (0..(lines.current_supplier_diversity_count - 1)).to_a.collect!{ |i|
          pull_existing_supplier_diversity(i, target).merge(pull_extended_existing_supplier_diversity(i, target))
        }.each { |new_obj|
          # Update the stored lines
          self << (make contained_class, new_obj)
        }
      end

    end
  end

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which supplier diversity to pull from (most useful during a copy action). Defaults to :new
  # @return [Hash] The return values of attributes for the given line
  def pull_existing_supplier_diversity(i=0, target=:new)
    pulled_supplier_diversity = Hash.new

    on VendorPage do |vp|
      case target
        when :old
          pulled_supplier_diversity = {
              type:                          vp.old_supplier_diversity_type(i),
              certification_expiration_date: vp.old_supplier_diversity_certification_expiration_date(i),
              active:                        yesno2setclear(vp.old_supplier_diversity_active(i))
          }
        when :new
          pulled_supplier_diversity = {
              type:                          vp.update_supplier_diversity_type(i).text.strip,
              certification_expiration_date: vp.update_supplier_diversity_certification_expiration_date(i).value.strip,
              active:                        yesno2setclear(vp.update_supplier_diversity_active(i).value.strip)
          }
      end
    end

    pulled_supplier_diversity
  end

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which supplier diversity to pull from (most useful during a copy action). Defaults to :new
  # @return [Hash] The return values of attributes for the given line
  def pull_extended_existing_supplier_diversity(i=0, target=:new)
    # This can be implemented for site-specific attributes. See the Hash returned in
    # the #collect! in #update_from_page! above for the kind of way to get the
    # right return value.
    Hash.new
  end

end
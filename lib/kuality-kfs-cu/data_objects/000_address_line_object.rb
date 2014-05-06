#overriding kuality-kfs object
class AddressLineObject

  attr_accessor :method_of_po_transmission

  def fill_out_extended_attributes
    @method_of_po_transmission = 'US MAIL' if @method_of_po_transmission.nil? # This'll give us a default value for now.
    on(VendorPage) { |vp| fill_out vp, :method_of_po_transmission }
  end

  def update_extended_attributes(opts={})
    on(VendorPage).update_method_of_po_transmission(@line_number).pick! opts[:method_of_po_transmission]
    @method_of_po_transmission = opts[:method_of_po_transmission]
  end

end

class AddressLineObjectCollection

  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Symbol] target Which address to pull from (most useful during a copy action). Defaults to :new
  # @return [Hash] The return values of attributes for the given line
  def pull_extended_existing_address(i=0, target=:new)
    result = Hash.new

    on VendorPage do |b|
      case target
        when :old; result = { method_of_po_transmission: b.old_method_of_po_transmission(i) }
        when :new; result = { method_of_po_transmission: b.update_method_of_po_transmission(i).selected_options.first.text }
      end
    end

    result
  end

end
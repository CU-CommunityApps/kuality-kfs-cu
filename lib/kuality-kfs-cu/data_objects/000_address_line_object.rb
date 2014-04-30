#overriding kuality-kfs object
class AddressLineObject

  attr_accessor :method_of_po_transmission

  def fill_out_extended_attributes
    @method_of_po_transmission = 'US MAIL' if @method_of_po_transmission.nil? # This'll give us a default value for now.
    on(VendorPage) { |vp| fill_out vp, :method_of_po_transmission }
  end

  def update_extended_attributes(opts={})
    on(VendorPage).update_method_of_po_transmission(@line_number).fit opts[:method_of_po_transmission] unless opts[:method_of_po_transmission].nil?
    @method_of_po_transmission = opts[:method_of_po_transmission]
  end

end

class AddressLineObjectCollection

  # @return [Hash] The return values of extended attributes for the given line
  # @param [Fixnum] i The line number to look for (zero-based)
  # @param [Watir::Browser] b The current browser object
  # @return [Hash] The known line values
  def pull_extended_existing_address(i=0)
    result = Hash.new
    on(VendorPage){ |b| result = { method_of_po_transmission: b.update_method_of_po_transmission(i).selected_options.first.text } }
    result
  end

end
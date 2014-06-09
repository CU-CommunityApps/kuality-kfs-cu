#overriding kuality-kfs object
class AddressLineObject

  attr_accessor :method_of_po_transmission, :vendor_address_generated_identifier

  def fill_out_extended_attributes
    @method_of_po_transmission = 'US MAIL' if @method_of_po_transmission.nil? # This'll give us a default value for now.
    @vendor_address_generated_identifier = nil
    on(VendorPage) { |vp| fill_out vp, :method_of_po_transmission }
  end

  def update_extended_attributes(opts={})
    on(VendorPage).update_method_of_po_transmission(@line_number).pick! opts[:method_of_po_transmission]
    @method_of_po_transmission = opts[:method_of_po_transmission] unless opts[:method_of_po_transmission].nil?
    @vendor_address_generated_identifier = opts[:vendor_address_generated_identifier] unless opts[:vendor_address_generated_identifier].nil? # We're simply tracking this, if provided
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
        when :old
          result = {
            method_of_po_transmission: b.old_method_of_po_transmission(i),
            vendor_address_generated_identifier: b.old_vendor_address_generated_identifier(i)
          }
        when :new
          result = {
            method_of_po_transmission: b.update_method_of_po_transmission(i).selected_options.first.text,
            vendor_address_generated_identifier: b.new_vendor_address_generated_identifier(i)
          }
        when :readonly
          result = {
            method_of_po_transmission: b.readonly_method_of_po_transmission(i),
            vendor_address_generated_identifier: b.old_vendor_address_generated_identifier(i)
          }
        else
          raise ArgumentError, "AddressLineObject does not know how to pull the provided existing address type (#{target})!"
      end
    end

    result
  end

end
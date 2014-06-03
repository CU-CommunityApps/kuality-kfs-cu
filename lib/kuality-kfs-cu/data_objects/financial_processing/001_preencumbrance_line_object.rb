class PreEncumbranceLineObject < AccountingLineObject

  attr_accessor :auto_disencumber_type, :start_date, :partial_transaction_count, :partial_amount

  def extended_create_mappings
    mappings = Hash.new
    mappings.merge!({"#{@type}_auto_disencumber_type".to_sym => @auto_disencumber_type}) unless @auto_disencumber_type.nil?
    mappings.merge!({"#{@type}_start_date".to_sym => @start_date}) unless @start_date.nil?
    mappings.merge!({"#{@type}_partial_transaction_count".to_sym => @partial_transaction_count}) unless @partial_transaction_count.nil?
    mappings.merge!({"#{@type}_partial_amount".to_sym => @partial_amount}) unless @partial_amount.nil?
  end

  def extended_update_mappings
    mappings = Hash.new
    mappings.merge!({"update_#{@type}_auto_disencumber_type".to_sym => opts[:auto_disencumber_type]}) unless @auto_disencumber_type.nil?
    mappings.merge!({"update_#{@type}_start_date".to_sym => opts[:start_date]}) unless @start_date.nil?
    mappings.merge!({"update_#{@type}_partial_transaction_count".to_sym => opts[:partial_transaction_count]}) unless @partial_transaction_count.nil?
    mappings.merge!({"update_#{@type}_partial_amount".to_sym => opts[:partial_amount]}) unless @partial_amount.nil?
  end

  def fill_out_extended_attributes
    mappings = Hash.new
    mappings.merge!({"#{@type}_auto_disencumber_type".to_sym => @auto_disencumber_type}) unless @auto_disencumber_type.nil?
    mappings.merge!({"#{@type}_start_date".to_sym => @start_date}) unless @start_date.nil?
    mappings.merge!({"#{@type}_partial_transaction_count".to_sym => @partial_transaction_count}) unless @partial_transaction_count.nil?
    mappings.merge!({"#{@type}_partial_amount".to_sym => @partial_amount}) unless @partial_amount.nil?
  end


  class PreEncumbranceLineObjectCollection < AccountingLineObjectCollection
    contains PreEncumbranceLineObjectCollection

    # @param [Symbol] type The type of line to import (source or target). You may want to use AccountingLineObject#get_type_conversion
    # @param [Fixnum] i The line number to look for (zero-based)
    def pull_existing_line_values(type, i)
      on AccountingLine do |lines|
        super.merge({
                       auto_disencumber_type: (lines.update_auto_disencumber_type(type, i).value if lines.update_auto_disencumber_type(type, i).exists?),
                       start_date: (lines.update_start_date(type, i).value if lines.update_start_date(type, i).exists?),
                       partial_transaction_count: (lines.partial_transaction_count(type, i).value if lines.partial_transaction_count(type, i).exists?),
                       partial_amount: (lines.partial_amount(type, i).value if lines.partial_amount(type, i).exists?)
                    })
        .merge(pull_preencumbrance_extended_existing_line_values(type, i))
      end
    end

    # @param [Symbol] type The type of line to import (source or target). You may want to use AccountingLineObject#get_type_conversion
    # @param [Fixnum] i The line number to look for (zero-based)
    def pull_extended_existing_preencumbrance_line_values(type, i)
      # This can be implemented for site-specific attributes particular to the PreEncumbranceLineObject.
      # See the Hash returned in the #collect! in #update_from_page! above for the kind of way
      # to get the right return value.
      Hash.new
    end
  end

end
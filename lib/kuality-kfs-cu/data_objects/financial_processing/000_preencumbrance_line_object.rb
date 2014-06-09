class PreEncumbranceLineObject < AccountingLineObject

  attr_accessor :auto_dis_encumber_type, :start_date, :end_date, :partial_transaction_count, :partial_amount

  def fill_out_extended_attributes
    mappings = Hash.new
    mappings.merge!({"#{@type}_auto_dis_encumber_type".to_sym => @auto_dis_encumber_type}) unless @auto_dis_encumber_type.nil?
    mappings.merge!({"#{@type}_start_date".to_sym => @start_date}) unless @start_date.nil?
    mappings.merge!({"#{@type}_partial_transaction_count".to_sym => @partial_transaction_count}) unless @partial_transaction_count.nil?
    mappings.merge!({"#{@type}_partial_amount".to_sym => @partial_amount}) unless @partial_amount.nil?

    on AccountingLine do |page|
      mappings.each do |field, value|
        lmnt = page.send(*[field, nil].compact)
        var = value.nil? ? instance_variable_get("@#{field}") : value
        lmnt.class.to_s == 'Watir::Select' ? lmnt.pick!(var) : lmnt.fit(var)
      end
    end
  end
end

class PreEncumbranceLineObjectCollection < AccountingLineObjectCollection

  contains PreEncumbranceLineObject


  # @param [Symbol] type The type of line to import (source or target). You may want to use AccountingLineObject#get_type_conversion
  # @param [Fixnum] i The line number to look for (zero-based)
  def pull_existing_line_values(type, i)
    on AccountingLine do |lines|
      super.merge({
                      auto_dis_encumber_type:  (lines.update_auto_dis_encumber_type(type, i).value  if lines.update_auto_dis_encumber_type(type, i).exists?),
                      start_date:  (lines.update_start_date(type, i).value  if lines.update_start_date(type, i).exists?),
                      end_date:  (lines.update_end_date(type, i).value  if lines.update_end_date(type, i).exists?),
                      partial_transaction_count:  (lines.update_partial_transaction_count(type, i).value  if lines.update_partial_transaction_count(type, i).exists?),
                      partial_amount:  (lines.update_partial_amount(type, i).value  if lines.update_partial_amount(type, i).exists?)
                  })
      .merge(pull_preencumbrance_extended_existing_line_values(type, i))
    end
  end

  # @param [Symbol] type The type of line to import (source or target). You may want to use AccountingLineObject#get_type_conversion
  # @param [Fixnum] i The line number to look for (zero-based)
  def pull_preencumbrance_extended_existing_line_values(type, i)
    # This can be implemented for site-specific attributes particular to the PreEncumbranceLineObject.
    # See the Hash returned in the #collect! in #update_from_page! above for the kind of way
    # to get the right return value.
    Hash.new
  end

end
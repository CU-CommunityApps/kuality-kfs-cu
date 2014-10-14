#overriding kuality-kfs object
class AccountObject

  attr_accessor :subfund_program_code, :labor_benefit_rate_category_code,
                :major_reporting_category_code, :appropriation_account_number

  def extended_defaults
    {
      labor_benefit_rate_category_code: 'CC'
    }.merge(get_aft_parameter_values_as_hash(ParameterConstants::DEFAULTS_FOR_ACCOUNT))
  end

  def fill_out_extended_attributes(attribute_group=nil)
    #case attribute_group # Don't actually use this yet.
    #  else
        # These should map to non-required, or otherwise un-grouped attributes
        on AccountPage do |p|
          fill_out p, :subfund_program_code, :labor_benefit_rate_category_code,
                      :major_reporting_category_code, :appropriation_account_number
        end
    #end
  end

  # Class Methods:
  class << self

    alias_method :base_uncopied_attributes, :uncopied_attributes
    # Attributes that don't copy over to a new document's fields during a copy.
    # @return Array List of Symbols for attributes that aren't copied to the new side of a copy
    def uncopied_attributes
      base_uncopied_attributes | [:labor_benefit_rate_category_code, :major_reporting_category_code]
    end

  end

end

#overriding kuality-kfs object
class AccountGlobalObject

  attr_accessor :major_reporting_category_code

  def fill_out_extended_attributes
    on(AccountGlobalPage) { |p| fill_out p, :major_reporting_category_code }
  end

end

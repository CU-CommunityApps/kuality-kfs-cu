#overriding kuality-kfs object
class AccountGlobalExtendedAttributesObject

  attr_accessor :major_reporting_category_code

  def create
    on AccountGlobalPage do |page|
      fill_out page, :major_reporting_category_code
    end
  end

end

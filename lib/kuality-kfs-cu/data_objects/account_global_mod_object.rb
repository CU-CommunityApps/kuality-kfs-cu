#overriding kuality-kfs object
class AccountGlobalModObject
  #include StringFactory
  attr_accessor :major_reporting_category_code

  def create()
    #attr_accessor :major_reporting_category_code


    on AccountGlobalPage do |page|
    fill_out page, :major_reporting_category_code
    end
  end
end #class

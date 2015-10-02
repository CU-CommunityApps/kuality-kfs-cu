#overriding kuality-kfs object
class ObjectCodeGlobalObject

  attr_accessor :suny_object_code

  #method extended_defaults is not currently needed since this attribute's value is being left blank

  def fill_out_extended_attributes
    on(ObjectCodeGlobalPage) do |page|
      fill_out page, :suny_object_code
    end
  end

end

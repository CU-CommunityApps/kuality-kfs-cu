#overriding kuality-kfs object
class ObjectCodeGlobalObject

  attr_accessor :suny_object_code

  def fill_out_extended_attributes
    on(ObjectCodeGlobalPage) { |p| fill_out p, :suny_object_code }
  end

end

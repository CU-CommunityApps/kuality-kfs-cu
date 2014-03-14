#overriding kuality-kfs object
class ObjectCodeObject < KFSDataObject

  attr_accessor :suny_object_code

  def fill_out_extended_attributes
    on(ObjectCodePage) { |page| fill_out page, :suny_object_code }
  end

end

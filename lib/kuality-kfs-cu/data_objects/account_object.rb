#overriding kuality-kfs object
class AccountObject

  attr_accessor :subfund_program_code

  def fill_out_extended_attributes
    on(AccountPage) { |p| fill_out p, :subfund_program_code }
  end

end

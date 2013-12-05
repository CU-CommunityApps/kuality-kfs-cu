class LoginPage < BasePage
  page_url "#{$base_url}backdoorlogin.do"

  element(:username) { |b| b.text_field(name: 'backdoorId')}
  button 'Login'
end
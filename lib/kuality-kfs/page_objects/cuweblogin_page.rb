class CUWebLoginPage < BasePage
  page_url "#{$base_url}portal.do"

  element(:netid) { |b| b.text_field(name: 'netid')}
  element(:password) { |b| b.text_field(name: 'password')}
  value(:page_header) { |b| b.h1(text: 'CUWebLogin')}
  button 'Login'

end
class CUWebLoginPage < BasePage
  page_url "#{$base_url}portal.do"

  element(:netid) { |b| b.text_field(name: 'netid') }
  element(:password) { |b| b.text_field(name: 'password') }
  element(:page_header_element) { |b| b.h1(text: 'CUWebLogin') }
  value(:page_header) { |b| b.page_header_element.text }
  button 'Login'

end
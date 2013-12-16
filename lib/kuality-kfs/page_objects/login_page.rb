class LoginPage < BasePage
  page_url "#{$base_url}backdoorlogin.do"

  element(:username) { |b| b.text_field(name: 'backdoorId')}
  action(:login_as) { |user_id, b| b.username.set user_id; b.login}
  button 'Login'
end

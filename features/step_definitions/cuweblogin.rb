Given /^I am logged in via CUWebLogin$/ do
  @config = YAML.load_file("#{File.dirname(__FILE__)}/../support/config.yml")[:basic]
  visit CUWebLoginPage do |page|
    page.netid.set @config[:cuweblogin_user]
    page.password.set @config[:cuweblogin_password]
    page.login
  end
end
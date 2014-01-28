Given /^I am logged in via CUWebLogin$/ do
  @config = YAML.load_file("#{File.dirname(__FILE__)}/../support/config.yml")[:basic]
  visit CUWebLoginPage do |page|
    if page.page_header_element.exists?
      page.netid.set @config[:cuweblogin_user]
      page.password.set @config[:cuweblogin_password]
      page.login
    end
    # Otherwise, we're already logged in (or not actually using CUWebLogin)
    # and we can safely continue on our way. Something else should break if
    # anything is amiss.
  end
end

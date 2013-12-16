class AdministrationPage < BasePage

  page_url "#{$base_url}portal.do?selectedTab=administration"

  links 'Person', 'Group', 'Role'

end
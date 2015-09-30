module GlobalConfig

  def global_config
    @@global_config ||= YAML.load_file("#{File.dirname(__FILE__)}/config.yml")[:basic]
  end

  def ksb_client
    #sub string to remove trailing 
    rice_url = ENV['RICE_URL'] ? ENV['RICE_URL'] : global_config[:rice_url]
    @@ksb_client ||= KSBServiceClient.new("#{File.dirname(__FILE__)}/client-sign.properties", "cynergy-dev", rice_url.sub(/(\/)+$/,''))
  end

  def perform_university_login(page)
    @@global_config ||= YAML.load_file("#{File.dirname(__FILE__)}/config.yml")[:basic]
    cuwaform = page.form('login')
    page = page.form_with(:name => 'login') do |form|
      form.netid = @@global_config[:cuweblogin_user]
      form.password = @@global_config[:cuweblogin_password]
    end.submit
    page.form('bigpost').submit
  end

end

module GlobalConfig
  def global_config
    @@global_config ||= YAML.load_file("#{File.dirname(__FILE__)}/config.yml")[:basic]
  end
  def ksb_client
    #sub string to remove trailing 
    @@ksb_client ||= KSBServiceClient.new("#{File.dirname(__FILE__)}/client-sign.properties", "cynergy-dev", global_config[:rice_url].sub(/(\/)+$/,''))
  end
end

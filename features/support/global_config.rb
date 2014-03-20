module GlobalConfig
  def global_config
    @@global_config ||= YAML.load_file("#{File.dirname(__FILE__)}/config.yml")[:basic]
  end
  def ksb_client
    @@ksb_client ||= KSBServiceClient.new("#{File.dirname(__FILE__)}/client-sign.properties", "cynergy-dev", global_config[:rice_url].sub(/(\/)+$/,''))
  end
  def role_service
    @@role_service ||= ksb_client.getRoleService()
  end
  def identity_service
    @@identity_service ||= ksb_client.getIdentityService()
  end
  def get_first_principal_id_for_role(name_space, role_name)
    role_service.getRoleMemberPrincipalIds(name_space, role_name, StringMapEntryListType.new).getPrincipalId().get(0)
  end
  def get_principal_name_for_principal_id(principal_name)
    identity_service.getEntityByPrincipalId(principal_name).getPrincipals().getPrincipal().get(0).getPrincipalName()
  end
  def get_first_principal_name_for_role(name_space, role_name)
    get_principal_name_for_principal_id(get_first_principal_id_for_role(name_space, role_name))
  end
end

World(GlobalConfig)
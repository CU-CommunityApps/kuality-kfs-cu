module GlobalConfig
  def global_config
    @@global_config ||= YAML.load_file("#{File.dirname(__FILE__)}/config.yml")[:basic]
  end
  def ksb_client
    #sub string to remove trailing 
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
  #def get_random_principal_id_for_role(name_space, role_name)
  #  principal_ids ||= role_service.getRoleMemberPrincipalIds(name_space, role_name, StringMapEntryListType.new)
  #  principal_ids.sample
  #end
  def get_principal_name_for_principal_id(principal_name)
    identity_service.getEntityByPrincipalId(principal_name).getPrincipals().getPrincipal().get(0).getPrincipalName()
  end
  def get_first_principal_name_for_role(name_space, role_name)
    @@prinicpal_names ||= Hash.new{|hash, key| hash[key] = Hash.new}

    if !@@prinicpal_names[name_space][role_name].nil?
      @@prinicpal_names[name_space][role_name]
    else
      @@prinicpal_names[name_space][role_name] = get_principal_name_for_principal_id(get_first_principal_id_for_role(name_space, role_name))
    end
  end
  #def get_random_principal_name_for_role(name_space, role_name)
  #  @@prinicpal_names ||= Hash.new{|hash, key| hash[key] = Hash.new}
  #
  #  if !@@prinicpal_names[name_space][role_name].nil?
  #    @@prinicpal_names[name_space][role_name]
  #  else
  #    @@prinicpal_names[name_space][role_name] = get_principal_name_for_principal_id(get_random_principal_id_for_role(name_space, role_name))
  #  end
  #end
end

World(GlobalConfig)
class SalaryExpenseTransferTestData

  include GlobalConfig

  attr_accessor :user_and_from_acct_org_same, :user_and_to_acct_org_same, :emp_funded_and_acct_org_same,
                :to_acct_type, :to_acct_rate,
                :user_principal_id, :user_principal_name, :user_dept_code,
                :employee_id


  def initialize (arguments)
    read_arguments(arguments)
  end

  def determine_labor_orgs (user_principal_id)
    puts role_service.methods()
    principal_names_in_role2 = role_service.findRoleMemberships('namespaceCode = "KFS-SEC" and name like "*abor for org*"')
    orgs = principal_names_in_role2
  end

  def determine_employee (dept_code)
    on PersonLookup do |search|
      search.primary_department_code dept_code
      search.search
      search.return_value(emp)
    end
    @employee_id = identity_service.getEntityByPrincipalId(user_principal_id).getPrimaryEmployment().getEmployeeId()
  end

  def determine_user()
    @user_principal_id = get_first_principal_id_for_role('KFS-LD', 'Salary Transfer Initiator (cu)')
    @user_principal_name = get_principal_name_for_principal_id(user_principal_id)

#same as get_principal_name_for_principal_id both work
#    user_emplid = identity_service.getEntityByPrincipalId(user_principal_id).getPrimaryEmployment().getEmployeeId()
#    user_primary_dept_code = identity_service.getEntityByPrincipalId(user_principal_id).getPrimaryEmployment().getPrimaryDepartmentCode()
  end

  def determine_dept_code (principal_id)
    identity_service.getEntityByPrincipalId(principal_id).getPrimaryEmployment().getPrimaryDepartmentCode()
  end

  def read_arguments (arguments)
    # determine which required argument values were passed
    case arguments['From Account']
      when 'In Same Organization'
        user_and_from_acct_org_same = true
      when 'Out of Organization'
        user_and_from_acct_org_same = false
      else
        user_and_from_acct_org_same = nil
    end
    case arguments['To Account']
      when 'In Same Organization'
        user_and_to_acct_org_same = true
      when 'Out of Organization'
        user_and_to_acct_org_same = false
      else
        user_and_to_acct_org_same = nil
    end
    case arguments['Employee Funded From']
      when 'In Same Organization'
        emp_funded_and_acct_org_same = true
      when 'Out of Organization'
        emp_funded_and_acct_org_same = false
      else
        emp_funded_and_acct_org_same = nil
    end

    # do not continue, required parameters not sent
    if user_and_to_acct_org_same.nil? || user_and_to_acct_org_same.nil? || emp_funded_and_acct_org_same.nil?
      fail(ArgumentError.new('Required parameters were not specified.'))
    end

    # determine which optional argument values were passed
    case arguments['To Account Type']
      when 'Same'
        to_acct_type = true
      when 'Different'
        to_acct_type = false
      else
        to_acct_type = nil
    end
    case arguments['To Account Rate']
      when 'Same'
        to_acct_rate = true
      when 'Different'
        to_acct_rate = false
      else
        to_acct_rate = nil
    end
  end

end
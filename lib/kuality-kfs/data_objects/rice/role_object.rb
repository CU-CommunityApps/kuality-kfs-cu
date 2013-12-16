class RoleObject < DataObject

  include Navigation
  include StringFactory

  attr_accessor :id, :name, :type, :namespace, :description,
                :permissions

  ROLES = {
      # Add roles here as needed for testing...
      'Aggregator'                      => '110',
      'approver'                        => '103',
      'Award Budget Aggregator'         => '113',
      'Award Budget Approver'           => '112',
      'Award Budget Modifier'           => '102',
      'Award Budget Viewer'             => '101',
      'Award Viewer'                    => '123',
      'Award Modifier'                  => '126',
      'Budget Creator'                  => '108',
      'Create Proposal Log'             => '140',
      'Departments Awards Viewer'       => '121',
      'Institutional Proposal Viewer'   => '118',
      'IRB Administrator'               => '128',
      'IRB Approver'                    => '99',
      'IRB Reviewer'                    => '127',
      'KC Super User'                   => '177',
      'Maintain IRB Questionnaire'      => '161',
      'Maintain Proposal Questionnaire' => '162',
      'Manager'                         =>  '98',
      'Narrative Writer'                => '109',
      'Negotiation Creator'             => '1399',
      'OSP Administrator'               => '131',
      'OSPApprover'                     => '100',
      'Proposal Creator'                => '111',
      'Protocol Aggregator'             => '105',
      'Protocol Approver'               => '149',
      'Protocol Creator'                => '129',
      'Protocol Viewer'                 => '104',
      'System User'                     => '90',
      'Unassigned'                      => '106',
      'Viewer'                          => '107',
      'View Subaward'                   => '1426',
      'View Proposal Log'               => '142'
  }

  def initialize(browser, opts={})
    @browser = browser

    defaults = {
        description:      random_alphanums,
        type:             'Unit',
        name:             random_alphanums,
        namespace:        'KC-UNT - Kuali Coeus - Department',
        assignees:        collection('RoleAssignees'),
        permissions:      [],
        responsibilities: [],
        # TODO: Add this when needed:
        #delegations:      collection('Delegation')
    }

    set_options(defaults.merge(opts))
  end

  def create
    visit(AdministrationPage).role
    on(RoleLookup).create
    on KimTypeLookup do |page|
      page.type_name.set @type
      page.search
      page.return_value @type
    end
    on RolePage do |create|
      @id=create.id
      fill_out create, :namespace, :name, :description
      @permissions.each { |id|
        create.add_permission_id.set id
        create.add_permission
      }
      @responsibilities.each { |id|
        create.add_responsibility_id.set id
        create.add_responsibility
      }
      create.blanket_approve
    end
  end

  def add_permission(id)
    view # TODO: Add conditional navigation code here
    on RolePage do |page|
      page.add_permission_id.set id
      page.add_permission
      page.blanket_approve
    end
    @permissions << id
  end

  def add_assignee(opts)
    view # TODO: Add conditional navigation code here
    @assignees.add opts
  end

  def view
    exists?
    on(RoleLookup).edit_item @name
  end

  def exists?
    $users.admin.log_in if $users.current_user==nil
    visit(AdministrationPage).role
    on RoleLookup do |look|
      fill_out look, :name, :id
      look.search
      if look.results_table.present?
        # TODO: May need to add code that grabs the id value of the RolePage.
        return true
      else
        return false
      end
    end
  end

end
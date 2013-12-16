class RolePage < BasePage

  description_field
  error_messages
  global_buttons
  tab_buttons

  value(:id) { |b| b.overview_tab.table[0][1].text }
  value(:type) { |b| b.overview_tab.table[0][3].text }
  
  element(:namespace) { |b| b.nmsp_ed.present? ? b.nmsp_ed : b.nmsp_ro }
  element(:name) { |b| b.frm.text_field(name: 'document.roleName') }

  element(:add_permission_id) { |b| b.frm.text_field(name: 'permission.permissionId') }
  action(:add_permission) { |b| b.frm.button(name: 'methodToCall.addPermission.anchorPermissions').click; b.loading }
  
  element(:add_responsibility_id) { |b| b.frm.text_field(name: 'responsibility.responsibilityId') }
  action(:add_responsibility) { |b| b.frm.button(name: 'methodToCall.addResponsibility.anchorResponsibilities').click; b.loading }
  
  element(:assignee_type_code) { |b| b.frm.select(name: 'member.memberTypeCode') }
  element(:assignee_id) { |b| b.frm.text_field(name: 'member.memberId') }
  element(:assignee_unit_number) { |b| b.frm.text_field(id: /^member/, title: '* Unit Number') }
  action(:add_assignee) { |b| b.frm.button(name: 'methodToCall.addMember.anchorAssignees').click; b.loading }

  element(:delegation_type_code) { |b| b.frm.select(name: 'delegationMember.memberTypeCode') }
  element(:delegation_id) { |b| b.frm.text_field(name: 'delegationMember.memberId') }
  element(:delegation_unit_number) { |b| b.frm.text_field(id: /^delegationMember/, title: '* Unit Number') }
  action(:add_delegation) { |b| b.frm.button(name: 'methodToCall.addDelegationMember.anchorDelegations').click; b.loading }
  
  # ===========
  private
  # ===========

  element(:overview_tab) { |b| b.frm.div(id: 'tab-Overview-div') }
  element(:nmsp_ed) { |b| b.frm.select(name: 'document.roleNamespace') }
  element(:nmsp_ro) { |b| b.overview_tab.table[1][1].text }

end
class GroupPage < BasePage

  description_field
  error_messages
  global_buttons
  tab_buttons

  value(:id) { |b| b.overview_tab.table[0][1].text }

  # DANGER! 
  # Note: these elements are dynamic, in that they are either
  # editable fields or text strings, depending on whether you're creating
  # or editing the group...
  element(:namespace) { |b| b.gnspc_select.present? ? b.gnspc_select : b.gnsp_ro }
  element(:name) { |b| b.gr_nm.present? ? b.gr_nm : b.gr_nm_ro }

  element(:type_code) { |b| b.frm.select(name: 'member.memberTypeCode') }
  element(:member_identifier) { |b| b.frm.text_field(name: 'member.memberId') }
  element(:member_name) { |b| b.frm.text_field(name: 'member.memberName') }
  action(:add_member) { |b| b.frm.button(name: 'methodToCall.addMember.anchorAssignees').click; b.loading }

  action(:inactivate_member) { |member, b| b.assignees_table.row(text: /#{member}/).button(name: /methodToCall.deleteMember/).click; b.loading }

  # =========
  private
  # =========
  
  element(:overview_tab) { |b| b.frm.div(id: 'tab-Overview-div') }
  element(:assignees_tab) { |b| b.frm.div(id: 'tab-Assignees-div') }
  element(:gnspc_select) { |b| b.frm.select(name: 'document.groupNamespace') }
  value(:gnspc_ro) { |b| b.overview_tab.table[1][1].text }
  element(:gr_nm) { |b| b.frm.text_field(name: 'document.groupName') }
  value(:gr_nm_ro) { |b| b.overview_tab.table[1][3].text }
  element(:assignees_table) { |b| b.assignees_tab.div(class: 'tab-container').table(index: 1) }

end
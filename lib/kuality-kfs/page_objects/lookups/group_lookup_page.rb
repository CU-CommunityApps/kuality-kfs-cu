class GroupLookupPage < Lookups

  element(:group_id) { |b| b.frm.text_field(name: 'id') }
  
end
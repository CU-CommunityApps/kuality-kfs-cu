class RoleLookup < Lookups

  element(:id) { |b| b.frm.text_field(name: 'id') }
  element(:name) { |b| b.frm.text_field(name: 'name') }

end
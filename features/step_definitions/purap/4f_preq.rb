When(/^I visit the "(.*)" page$/) do   |go_to_page|
  go_to_pages = go_to_page.downcase.gsub!(' ', '_')
  on(MainPage).send(go_to_pages)
end

And(/^I print out all "(field|button|select|checkbox|radio|link)" on the page$/) do |item_type|
  # For page object creation
  on MainPage do |page|
    case item_type
      when 'field'
        puts 'TEXT FIELDS '
        puts 'TEXT FIELDS '
        puts 'TEXT FIELDS '
        page.frm.text_fields.each { |t| puts 'element(:) { |b| b.frm.text_field(name: \'' + t.name.to_s + '\') }' "\n" }
        puts ' '
        puts ' '
        puts ' '
      when 'button'
        puts 'BUTTONS'
        puts 'BUTTONS'
        puts 'BUTTONS'
        page.frm.buttons.each { |t| puts 'action(:'+ t.title.to_s.downcase.gsub(' ', '_').gsub('-','_') + ') { |b| b.frm.button(title: \'' + t.title.to_s + '\').click }' "\n" }
        puts ' '
        puts ' '
        puts ' '
      when 'select'
        puts 'SELECT'
        puts 'SELECT'
        puts 'SELECT'
        page.frm.select_lists.each { |t| puts 'element(:) { |b| b.frm.select(name: \''+t.name.to_s+'\') }' }
        puts ' '
        puts ' '
        puts ' '
      when 'checkbox'
        puts 'CHECKBOX'
        puts 'CHECKBOX'
        puts 'CHECKBOX'
        page.frm.checkboxes.each { |t| puts 'element(:) { |b| b.frm.checkbox(name: \''+t.name.to_s+'\') }' }
        puts ' '
        puts ' '
        puts ' '
      when 'radio'
        puts 'RADIO'
        puts 'RADIO'
        puts 'RADIO'
        page.frm.radios.each { |r| puts 'element(:) { |b| b.frm.radio(id: \''+r.id.to_s+'\') }' "\n"}
        puts ' '
        puts ' '
        puts ' '
      when 'link'
        puts 'LINK'
        puts 'LINK'
        puts 'LINK'
        page.frm.links.each { |t| puts 'element(:) { |b| b.frm.link(text: \''+t.text.to_s+'\') }' }
        puts ' '
        puts ' '
        puts ' '
    end
  end
end #print all



And(/^I create the Requisition document with:$/) do |table|
  updates = table.rows_hash

  @requistion = create RequisitionObject, payment_request_positive_approval_required: updates['payment request'],
  vendor_number: updates['vendor number'],
  item_quantity: updates['item quanity'],
  item_unit_cost: updates['item cost'],
  item_commodity_code: updates['item commodity code'],
  item_account_number: updates['account number'],
  item_object_code: updates['object code'],
  item_percent: updates['percent']

end
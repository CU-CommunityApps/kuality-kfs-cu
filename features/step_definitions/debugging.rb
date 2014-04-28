# These steps can be useful for debugging, but *should not*
# be used in production/master runs.

And /^I sleep for (\d+)$/ do |time|
  sleep time.to_i
end

And /^I stop here because (.*)$/ do |msg|
  pending msg
end

And /^I stop here$/ do
  pending
end

And /^I inspect the (.*) document$/ do |document|
  puts document_object_for(document).inspect
end

And(/^I print out all "(field|button|select|checkbox|radio|link)" on the page$/) do |item_type|
  # For page object creation
  on MainPage do |page|
    case item_type
      when 'field'
        puts 'TEXT FIELDS '
        puts 'TEXT FIELDS '
        page.frm.text_fields.each { |t| puts 'element(:) { |b| b.frm.text_field(name: \'' + t.name.to_s + '\') }' "\n" }
        puts ' '
        puts ' '
      when 'button'
        puts 'BUTTONS'
        puts 'BUTTONS'
        page.frm.buttons.each { |t| puts 'action(:'+ t.title.to_s.downcase.gsub(' ', '_').gsub('-','_') + ') { |b| b.frm.button(title: \'' + t.title.to_s + '\').click }' "\n" }
        puts ' '
        puts ' '
      when 'select'
        puts 'SELECT'
        puts 'SELECT'
        page.frm.select_lists.each { |t| puts 'element(:) { |b| b.frm.select(name: \''+t.name.to_s+'\') }' }
        puts ' '
        puts ' '
      when 'checkbox'
        puts 'CHECKBOX'
        puts 'CHECKBOX'
        page.frm.checkboxes.each { |t| puts 'element(:) { |b| b.frm.checkbox(name: \''+t.name.to_s+'\') }' }
        puts ' '
        puts ' '
      when 'radio'
        puts 'RADIO'
        puts 'RADIO'
        page.frm.radios.each { |r| puts 'element(:) { |b| b.frm.radio(id: \''+r.id.to_s+'\') }' "\n"}
        puts ' '
        puts ' '
      when 'link'
        puts 'LINK'
        puts 'LINK'
        page.frm.links.each { |t| puts 'element(:) { |b| b.frm.link(text: \''+t.text.to_s+'\') }' }
        puts ' '
        puts ' '
    end
  end
end #print all
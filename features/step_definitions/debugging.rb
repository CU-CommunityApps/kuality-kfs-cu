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

When /^I visit the '(.*)' page$/  do   |goto_page|
  go_to_page = goto_page.downcase.gsub!(' ', '_')
  visit(MainPage).send(go_to_page)
end

And /^I print out all "(field|textarea|button|select|checkbox|radio|link)" on the page$/ do |item_type|
  # For page object creation
  on MainPage do |page|
    case item_type
      when 'field'
        puts '#TEXT FIELDS '
        page.frm.text_fields.each { |t| puts 'element(:' + t.name.to_s.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.frm.text_field(name: \'' + t.name.to_s + '\') }' "\n" }
        #puts ' '
      when 'field'
        puts '#TEXT AREA '
        page.frm.textareas.each { |t| puts 'element(:' + t.name.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.frm.textarea(name: \'' + t.name.to_s + '\') }' "\n" }
        #puts ' '
      when 'button'
        puts '#BUTTONS'
        page.frm.buttons.each { |t| puts 'action(:'+ t.title.to_s.downcase.gsub(' ', '_').gsub('-','_').gsub('#','number') + ') { |b| b.frm.button(title: \'' + t.title.to_s + '\').click }' "\n" }
        #puts ' '
      when 'select'
        puts '#SELECT'
        page.frm.select_lists.each { |t| puts 'element(:' + t.name.to_s.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.frm.select(name: \''+t.name.to_s+'\') }' }
        #puts ' '
      when 'checkbox'
        puts '#CHECKBOX'
        page.frm.checkboxes.each { |t| puts 'element(:' + t.name.to_s.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.frm.checkbox(name: \''+t.name.to_s+'\') }' }
        #puts ' '
      when 'radio'
        puts '#RADIO'
        page.frm.radios.each { |t| puts 'element(:' + t.id.to_s.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.frm.radio(id: \''+t.id.to_s+'\') }' "\n"}
        #puts ' '
      when 'link'
        puts '#LINK'
        page.frm.links.each { |t| puts 'element(:' + t.text.to_s.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.frm.link(text: \''+t.text.to_s+'\') }' }
        #puts ' '
    end
  end
end #print all

And /^I print out all "(field|textarea|button|select|checkbox|radio|link)" on the page without frame$/ do |item_type|
  # For page object creation
  on MainPage do |page|
    case item_type
      when 'field'
        puts '#TEXT FIELDS '
        page.text_fields.each { |t| puts 'element(:' + t.name.to_s.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.text_field(name: \'' + t.name.to_s + '\') }' "\n" }
        #puts ' '
      when 'field'
        puts '#TEXT AREA '
        page.textareas.each { |t| puts 'element(:' + t.name.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.textarea(name: \'' + t.name.to_s + '\') }' "\n" }
        #puts ' '
      when 'button'
        puts '#BUTTONS'
        page.buttons.each { |t| puts 'action(:'+ t.title.to_s.downcase.gsub(' ', '_').gsub('-','_').gsub('#','number') + ') { |b| b.button(title: \'' + t.title.to_s + '\').click }' "\n" }
        #puts ' '
      when 'select'
        puts '#SELECT'
        page.select_lists.each { |t| puts 'element(:' + t.name.to_s.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.select(name: \''+t.name.to_s+'\') }' }
        #puts ' '
      when 'checkbox'
        puts '#CHECKBOX'
        page.checkboxes.each { |t| puts 'element(:' + t.name.to_s.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.checkbox(name: \''+t.name.to_s+'\') }' }
        #puts ' '
      when 'radio'
        puts '#RADIO'
        page.radios.each { |t| puts 'element(:' + t.id.to_s.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.radio(id: \''+t.id.to_s+'\') }' "\n"}
        #puts ' '
      when 'link'
        puts '#LINK'
        page.links.each { |t| puts 'element(:' + t.text.to_s.gsub(/([a-z])([A-Z])/ , '\1_\2').downcase + ') { |b| b.link(text: \''+t.text.to_s+'\') }' }
        #puts ' '
    end
  end
end #print all

And /^I open the document with ID (\d+)$/ do |document_id|
  visit(MainPage).doc_search
  on DocumentSearch do |search|
    search.document_type.fit ''
    search.document_id.fit   document_id
    search.search
    search.wait_for_search_results
    search.open_doc document_id
  end
end

And /^I open the (.*) document with ID (\d+)$/ do |document, document_id|
  doc_object = snake_case document
  object_klass = object_class_for(document)
  set(doc_object, make(object_klass, document_id: document_id))

  visit(MainPage).doc_search
  on DocumentSearch do |search|
    search.document_type.fit ''
    search.document_id.fit   document_id
    search.search
    search.wait_for_search_results
    search.open_doc document_id
  end
end

When /^I inspect the variable named (.*)$/ do |var|
  located_var = get(var)
  puts located_var.inspect
end
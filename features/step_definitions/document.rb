And /^I copy a random (.*) document with (.*) status/ do |document, doc_status|
  doc_object = snake_case document
  doc_object_class = document.gsub(' ', '') + 'Object'
  doc_page_class = document.gsub(' ', '') + 'Page'
  object_klass = Kernel.const_get(doc_object_class)
  page_klass = Kernel.const_get(doc_page_class)

  on DocumentSearch do |search|
    search.document_type.set object_klass::DOC_INFO[:type_code]
    search.search
    @document_id = search.docs_with_status(doc_status, search).sample
    search.open_doc @document_id
  end

  on page_klass do |page|
    page.copy_current_document
    @document_id = page.document_id
  end

  set(doc_object, make(object_klass, document_id: @document_id))
  get(doc_object).save
#  get(doc_object).pull

end

When /^I view the (.*) document$/ do |document|
  doc_object = snake_case document
  get(doc_object).view
end

When /^I (#{BasePage::available_buttons}) the (.*) document$/ do |button, document|
  doc_object = snake_case document
  button.gsub!(' ', '_')
  get(doc_object).send(button)
  on(YesOrNoPage).yes if button == 'cancel'
end

Then /^the (.*) document goes to (.*)/ do |document, doc_status|
  doc_object = snake_case document

  sleep 10
  get(doc_object).view
  $current_page.document_status.should == doc_status
end

When /^I (#{BasePage::available_buttons}|start) an empty (.*) document$/ do |button, document|
  visit(MainPage).send(snake_case(document))
  on(Kernel.const_get("#{document.gsub(' ', '')}Page")) do
    $current_page.send(snake_case(button)) unless button == 'start'
  end
end
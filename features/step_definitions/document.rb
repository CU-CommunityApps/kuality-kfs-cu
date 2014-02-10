And /^I copy a random (.*) document with (.*) status/ do |document, doc_status|
  doc_object = snake_case document
  object_klass = Kernel.const_get(object_class_for(document))
  page_klass = Kernel.const_get(page_class_for(document))

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
  get(snake_case(document)).view
end

When /^I (#{BasePage::available_buttons}) the (.*) document$/ do |button, document|
  doc_object = snake_case document
  button.gsub!(' ', '_')
  get(doc_object).send(button)
  on(YesOrNoPage).yes if button == 'cancel'
end

When /^I (#{BasePage::available_buttons}) the (.*) document and confirm any questions$/ do |button, document|
  step "I #{button} the #{document} document"
  on YesOrNoPage do |page|
    sleep 10
    page.yes if page.yes_button.exists?
  end
end

When /^I (#{BasePage::available_buttons}) the (.*) document and deny any questions$/ do |button, document|
  step "I #{button} the #{document} document"
  on YesOrNoPage do |page|
    sleep 10
    page.no if page.no_button.exists?
  end
end

Then /^the (.*) document goes to (.*)/ do |document, doc_status|
  doc_object = snake_case document
  page_klass = Kernel.const_get(get(doc_object).class.to_s.gsub(/(.*)Object$/,'\1Page'))

  sleep 10
  get(doc_object).view
  on(page_klass).document_status.should == doc_status
end

When /^I (#{BasePage::available_buttons}|start) an empty (.*) document$/ do |button, document|
  visit(MainPage).send(snake_case(document))
  on(Kernel.const_get(page_class_for(document))) do
    $current_page.send(snake_case(button)) unless button == 'start'
  end
end

And /^I (#{BasePage::available_buttons}) the document$/ do |button|
  button.gsub!(' ', '_')
  on(KFSBasePage).send(button)
  on(YesOrNoPage).yes if button == 'cancel'
end

Then /^the document status is (.*)/ do |doc_status|
  on(KFSBasePage) { $current_page.document_status.should == doc_status }
end
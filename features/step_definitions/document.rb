And /^I copy a random (.*) document with (.*) status/ do |document, doc_status|
  doc_object = snake_case document
  object_klass = object_class_for(document)

  on DocumentSearch do |search|
    search.document_type.set object_klass::DOC_INFO[:type_code]
    search.search
    @document_id = search.docs_with_status(doc_status, search).sample
    search.open_doc @document_id
  end

  on page_class_for(document) do |page|
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
  sleep 10 if (button == 'blanket approve' || button == 'approve')
end

When /^I (#{BasePage::available_buttons}) the (.*) document if it is not already FINAL/ do |button, document|
  doc_object = snake_case document
  button.gsub!(' ', '_')
  unless on(KFSBasePage).document_status == 'FINAL'
    get(doc_object).send(button)
    on(YesOrNoPage).yes if button == 'cancel'
    sleep 10 if (button == 'blanket approve' || button == 'approve')
  end
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

Then /^the (.*) document goes to (PROCESSED|ENROUTE|FINAL|INITIATED|SAVED)$/ do |document, doc_status|
  doc_object = snake_case document
  sleep 10
  get(doc_object).view
  on(page_class_for(document)).document_status.should == doc_status
end

Then /^the (.*) document goes to one of the following statuses:$/ do |document, required_statuses|
  doc_object = snake_case document
  sleep 10
  get(doc_object).view
  on(page_class_for(document)) { |page| required_statuses.raw.flatten.should include page.document_status }
end

And /^I (#{BasePage::available_buttons}) the document$/ do |button|
  button.gsub!(' ', '_')
  on(KFSBasePage).send(button)
  on(YesOrNoPage).yes if button == 'cancel'
end

And /^I recall the financial document$/ do
  on(KFSBasePage).recall_current_document
  on RecallPage do |page|
    page.reason.fit 'Recall test'
    page.recall
  end
end

And /^I recall and cancel the financial document$/ do
  on(KFSBasePage).recall_current_document
  on RecallPage do |page|
    page.reason.set 'Recall and cancel test'
    page.recall_and_cancel
  end
end

Then /^the document status is (.*)/ do |doc_status|
  on(KFSBasePage) { $current_page.document_status.should == doc_status }
end
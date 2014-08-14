And /^I (#{BasePage::available_buttons}) a[n]? (.*) document$/ do |button, document|
  doc_object = snake_case document
  object_klass = object_class_for(document)

  if defined? object_klass::DOC_INFO && object_klass::DOC_INFO.transactional?
    visit(MainPage).send(doc_object)
  end

  set(doc_object, (create object_klass, press: button.gsub(' ', '_')))
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

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
  document_object_for(document).view
end

When /^I (#{BasePage::available_buttons}) the (.*) document$/ do |button, document|
  button.gsub!(' ', '_')
  document_object_for(document).send(button)
  on(YesOrNoPage).yes if button == 'cancel'
  sleep 10 if (button == 'blanket approve' || button == 'approve' || 'submit')

  @requisition_id = on(RequisitionPage).requisition_id if document == 'Requisition' && button == 'submit'
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

When /^I (#{BasePage::available_buttons}) the (.*) document, confirming any questions, if it is not already FINAL/ do |button, document|
  doc_object = snake_case document
  button.gsub!(' ', '_')
  unless on(KFSBasePage).document_status == 'FINAL'
    get(doc_object).send(button)
    on(YesOrNoPage).yes_if_possible
    sleep 10 if (button == 'blanket approve' || button == 'approve')
  end
end

When /^I (#{BasePage::available_buttons}) the (.*) document and confirm any questions$/ do |button, document|
  step "I #{button} the #{document} document"
  on(YesOrNoPage).yes_if_possible
end

When /^I (#{BasePage::available_buttons}) the (.*) document and deny any questions$/ do |button, document|
  step "I #{button} the #{document} document"
  on(YesOrNoPage).no_if_possible
end

Then /^the (.*) document goes to (PROCESSED|ENROUTE|FINAL|INITIATED|SAVED)$/ do |document, doc_status|
  sleep 10
  document_object_for(document).view
  on(page_class_for(document)).document_status.should == doc_status
end

Then /^the (.*) document goes to one of the following statuses:$/ do |document, required_statuses|
  sleep 10
  document_object_for(document).view
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

And /^I remember the (.*) document number$/ do |document|
  @remembered_document_id = on(page_class_for(document)).document_id
end

And /^I retain the (.*) document number from this transaction$/ do |document|
  @retained_document_id = on(page_class_for(document)).document_id
end

Then /^The value for (.*) field is "(.*)"$/ do |field_name, field_value|
  $current_page.send(StringFactory.damballa(field_name)).should==field_value
end

And /^I collapse all tabs$/ do
  on(KFSBasePage).collapse_all
end

And /^I expand all tabs$/ do
  on(KFSBasePage).expand_all
end

And /^I select yes to the question$/ do
  on(YesOrNoPage).yes
end

And /^I calculate the (.*) document$/ do |document|
  document_object_for(document).calculate
end
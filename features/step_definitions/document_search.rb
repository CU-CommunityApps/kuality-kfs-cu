include Navigation

And /^I access Document Search$/ do
  visit(DocumentSearch)
end

And /^I search for all (.*) documents$/ do |doc_type|
  on DocumentSearch do |page|
    page.date_created_from.set '01/01/2014'
    page.document_type.set doc_type
    page.search
  end
end

And /^I copy a random (.*) document$/ do |doc_status|
  on DocumentSearch do |search|
    @document_id = search.docs_with_status(doc_status, search).sample
    search.open_doc @document_id
    on KFSBasePage do |page|
      page.copy_current_document
      page.description.fit 'AFT testing copy'
      page.save
    end
  end
end

And /^I copy a random (.*) with (.*) status/ do |document, doc_status|
  doc_type = snake_case document
  raise "You've entered a document type that isn't in the list.\nPlease update your scenario, or add\nthe document to the list in the step: #{document}" if DOC_CLASSES[doc_type].nil?
  on DocumentSearch do |search|
    search.document_type.set DOC_CLASSES[doc_type][0]
    search.search
    @document_id = search.docs_with_status(doc_status, search).sample
    search.open_doc @document_id
  end
  on(Kernel.const_get(DOC_CLASSES[doc_type][2])) do |page|
    page.copy_current_document
    page.description.fit 'AFT testing copy'

    set(doc_type, make(Kernel.const_get(DOC_CLASSES[doc_type][1]), DOC_OPTIONS[doc_type]))

    page.save
  end
end


DOC_CLASSES = { account_delegate: ['AD', 'AccountDelegateObject', 'AccountDelegatePage'],
                other_object: [ 'OtherObjectDocumentType', 'OtherObject', 'OtherObjectPageClass']
                # More stuff goes here...
}


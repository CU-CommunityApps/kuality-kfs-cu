include Navigation

And /^I access Document Search$/ do
  visit(DocumentSearch)
end

And /^I search for all (.*) documents$/ do |doc_type|
  on DocumentSearch do |page|
    page.date_created_from.fit '01/01/2014'
    page.document_type.fit doc_type
    page.search
  end
end

When /^I copy a document with a (.*) status$/ do |status|
  on DocumentSearch do |page|
    docs = page.docs_with_status(status)
    page.open_doc(docs[rand(docs.length)])
  end
  on(KFSBasePage) do |document_page|
    document_page.copy_current_document
    @document_id = document_page.document_id
  end
end

When /^I reopen the document$/ do
  visit(DocumentSearch)
  on DocumentSearch do |page|
    page.document_id.fit @document_id
    page.search
    page.open_doc(@document_id)
  end
end
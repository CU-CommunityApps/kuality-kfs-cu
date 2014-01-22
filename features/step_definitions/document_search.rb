include Navigation

And /^I access Document Search$/ do
  visit(DocumentSearch)
end

And /^I search for all (.*) documents$/ do |doc_type|
  on DocumentSearch do |page|
    page.document_type.set doc_type
    page.search
  end
end

And /^I copy a random (.*) document$/ do |doc_status|
  on DocumentSearch do |search|
    search.item_row(doc_status).should exist
    if search.item_row(doc_status).present?
#      search.item_row(doc_status).td.link.click
#      open_document(search.item_row(doc_status).td.link.text)
      @document_id = search.item_row(doc_status).td.link.text
      doc_search
    end
    on KFSBasePage do |page|

      page.copy_current_document
      page.description.fit 'AFT testing copy'
      page.save
    end
  end
end
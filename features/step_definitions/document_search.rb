include Navigation

And /^I access Document Search$/ do
  visit(DocumentSearch)
end

And /^I search for all (.*) documents$/ do |doc_type|
  visit DocumentSearch do |page|
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
  visit DocumentSearch do |page|
    page.document_id.fit @document_id
    page.search
    page.open_doc(@document_id)
  end
end

When /^I lookup the document ID for the (.*) document from the General Ledger$/ do |document|
  target_document_id = document_object_for(document).document_id

  visit(MainPage).general_ledger_entry
  on GeneralLedgerEntryLookupPage do |page|
    # We're assuming that Fiscal Year and Fiscal Period default to today's values
    page.doc_number.fit        target_document_id
    page.balance_type_code.fit ''
    page.pending_entry_approved_indicator_all
    page.search
    page.open_item_via_text(target_document_id, target_document_id)
  end
end
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
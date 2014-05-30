When /^I visit the action list outbox$/ do
  visit(ActionList).outbox
end

Then /^I can access the proposal from my action list$/ do
  visit(ActionList).filter
  on ActionListFilter do |page|
    page.document_title.set @proposal.project_title
    page.filter
  end
  on(ActionList).open_item(@proposal.document_id)
end

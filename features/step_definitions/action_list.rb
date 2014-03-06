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

When /^I route the (.*) document to (.*) by clicking (.*) for each request$/ do |document, target_status, button|
  step "I view the #{document} document"

  unless on(KFSBasePage).document_status == target_status
    step 'I switch to the user with the next Pending Action in the Route Log'
    step "I view the #{document} document"
    step "I #{button} the #{document} document if it is not already FINAL"
  end

end
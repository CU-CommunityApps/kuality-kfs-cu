When /^I blanket approve a Pre-Encumbrance Document for Account number "([^"]*)"$/ do |acct_num|
  visit PreEncumbrancePage do |page|
    page.description.set    '[KFSQA-587] Test Account Pre-Encumbrance'
    page.chart_code.select     'IT'
    page.account_number.set acct_num
    page.object.set         '6100'
    page.amount.set         '0.01'

    page.add_encumbrance

    @document_id
    page.blanket_approve
  end
end

Then /^the Pre-Encumbrance posts a GL Entry with one of the following statuses$/ do |required_statuses|
  visit PreEncumbrancePage do |page|
    required_statuses.should include page.document_status
  end
end
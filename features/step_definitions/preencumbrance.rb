When /^I blanket approve a Pre-Encumbrance Document for the random Account$/ do
  # Note: You must have captured the account number of the random account in a previous step to use this step.
  @preencumbrance = create PreEncumbranceObject, encumbrance_account_number: @account_number, press: PreEncumbrancePage::BLANKET_APPROVE
end

Then /^the Pre-Encumbrance posts a GL Entry with one of the following statuses$/ do |required_statuses|
  required_statuses = required_statuses.raw.flatten

  visit(MainPage).general_ledger_entry
  on GeneralLedgerEntryLookupPage do |page|
    # We'll assume that fiscal year and fiscal period default to nowish
    page.chart_code.fit @preencumbrance.encumbrance_chart_code
    page.account_number.fit @preencumbrance.encumbrance_account_number
    page.balance_type_code.fit ''
    page.pending_entry_approved_indicator_all

    page.search

    # The description field gets truncated to 40 characters for this display. Joy.
    truncated_description = @preencumbrance.description.length > 40 ? @preencumbrance.description[0,39] : @preencumbrance.description
    page.open_item_via_text(truncated_description, @preencumbrance.document_id)

    on(PreEncumbrancePage) { |b| required_statuses.should include b.document_status }
  end
end

When /^I disencumber the Account$/ do
  visit(MainPage).general_ledger_entry
  on GeneralLedgerEntryLookupPage do |page|
    page.chart_code.fit @preencumbrance.encumbrance_chart_code
    page.account_number.fit @preencumbrance.encumbrance_account_number
    page.balance_type_code.fit ''
    page.pending_entry_approved_indicator_all

    page.search

    # The description field gets truncated to 40 characters for this display. Joy.
    truncated_description = @preencumbrance.description.length > 40 ? @preencumbrance.description[0,39] : @preencumbrance.description
    page.open_item_via_text(truncated_description, @preencumbrance.document_id)
  end

  on(PreEncumbrancePage) do |page|
    page.accounting_lines.
  end # Figure out how to actually grab the reference number...

exit

  # Note: You must have captured the account number of the random account in a previous step to use this step.
  @preencumbrance = create PreEncumbranceObject, disencumbrance_account_number: @account_number, press: PreEncumbrancePage::BLANKET_APPROVE
end
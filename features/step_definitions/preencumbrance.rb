When /^I (#{PreEncumbrancePage::available_buttons}) a Pre-Encumbrance Document that encumbers the random Account$/ do |button|
  # Note: You must have captured the account number of the random account in a previous step to use this step.
  @encumbrance = create PreEncumbranceObject, encumbrance_account_number: @account.number, press: button.gsub(' ', '_')
end

Then /^the Pre-Encumbrance posts a GL Entry with one of the following statuses$/ do |required_statuses|
  visit(MainPage).general_ledger_entry
  on(GeneralLedgerEntryLookupPage).find_preencumbrance_doc(@encumbrance)
  on(PreEncumbrancePage) { |b| required_statuses.raw.flatten.should include b.document_status }
end

When /^I (#{PreEncumbrancePage::available_buttons}) a Pre-Encumbrance Document that disencumbers the random Account$/ do |button|
  visit(MainPage).general_ledger_entry
  on(GeneralLedgerEntryLookupPage).find_preencumbrance_doc(@encumbrance)
  encumbrance_reference_number = on(PreEncumbrancePage).first_encumbrance_reference_number

  # Note: You must have captured the account number of the random account in a previous step to use this step.
  @disencumbrance = create PreEncumbranceObject, disencumbrance_account_number: @account_number,
                                                 disencumbrance_reference_number: encumbrance_reference_number,
                                                 press: button.gsub(' ', '_')
end
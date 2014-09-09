When /^I (#{PreEncumbrancePage::available_buttons}) a Pre\-Encumbrance Document that encumbers the random Account$/ do |button|
  # Note: You must have captured the account number of the random account in a previous step to use this step.
  @pre_encumbrance = create PreEncumbranceObject, press: button.gsub(' ', '_'),
                            initial_lines: [{
                                                type:           :source,
                                                account_number: @account.number,
                                                chart_code:     get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
                                                object:         '6100',
                                                amount:         '0.01'
                                            }]
  step 'I add the encumbrance to the stack'
end

When /^I (#{PreEncumbrancePage::available_buttons}) a Pre-Encumbrance document that encumbers Account (.*)$/ do |button, account_number|
  # Note: You must have captured the account number of the random account in a previous step to use this step.
  @pre_encumbrance = create PreEncumbranceObject, press: :save,
                            initial_lines: [{
                                                type:             :source,
                                                account_number:   account_number,
                                                chart_code:       get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
                                                object:           '6540',
                                                amount:           '200',
                                                line_description: 'Test 753 Encumbrance'
                                            }]
  on(PreEncumbrancePage).send(button.gsub(' ', '_'))
  step 'I add the encumbrance to the stack'
  sleep 10
end

When /^I (#{PreEncumbrancePage::available_buttons}) a Pre-Encumbrance Document that disencumbers the random Account$/ do |button|
  @pre_encumbrances[:encumbrance][0].should_not.nil? 'No Encumbrance line provided for Pre-Encumbrance Document!'
  visit(MainPage).general_ledger_entry
  on(GeneralLedgerEntryLookupPage).find_encumbrance_doc(@pre_encumbrances[:encumbrance][0])
  encumbrance_reference_number = on(PreEncumbrancePage).first_encumbrance_reference_number

  # Note: You must have captured the account number of the random account in a previous step to use this step.
  @pre_encumbrance = create PreEncumbranceObject, press: button.gsub(' ', '_'),
                            initial_lines: [{
                                                type:             :target,
                                                account_number:   @account_number,
                                                reference_number: encumbrance_reference_number,
                                                chart_code:       get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE),
                                                object:           '6100',
                                                amount:           '0.01'
                                            }]
  step 'I add the disencumbrance to the stack'
end

Then /^The outstanding encumbrance for account (.*) and object code (.*) is (.*)$/ do |account_number, object_code, amount|
  visit(MainPage).open_encumbrances
  on OpenEncumbranceLookupPage do |page|
    page.account_number.set account_number
    page.chart_code.set get_aft_parameter_value(ParameterConstants::DEFAULT_CHART_CODE)
    page.object_code.set object_code
    page.including_pending_ledger_entry_approved.set
    page.doc_number.set @remembered_document_id
    page.balance_type_code.set 'PE'
    page.search

    outstanding_amount_col = page.column_index(:outstanding_amount)
    page.results_table.rest[0][outstanding_amount_col].text.groom.should == amount.groom

  end
end

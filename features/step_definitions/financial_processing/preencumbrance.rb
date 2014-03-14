When /^I (#{PreEncumbrancePage::available_buttons}) a Pre-Encumbrance Document that encumbers the random Account$/ do |button|
  # Note: You must have captured the account number of the random account in a previous step to use this step.
  @pre_encumbrance = create PreEncumbranceObject, press: button.gsub(' ', '_'),
                                              initial_lines: [{
                                                  type:           :source,
                                                  account_number: @account.number,
                                                  chart_code:     'IT', #TODO grab this from config file
                                                  object:         '6100',
                                                  amount:         '0.01'
                                              }]
  step 'I add the encumbrance to the stack'
end

Then /^the Pre-Encumbrance posts a GL Entry with one of the following statuses$/ do |required_statuses|
  visit(MainPage).general_ledger_entry
  on(GeneralLedgerEntryLookupPage).find_encumbrance_doc(@pre_encumbrance)
  on(PreEncumbrancePage) { |b| required_statuses.raw.flatten.should include b.document_status }
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
                                                   chart_code:       'IT', #TODO grab this from config file
                                                   object:           '6100',
                                                   amount:           '0.01'
                                                 }]
  step 'I add the disencumbrance to the stack'
end

When /^I start an empty Pre\-Encumbrance document$/ do
  @pre_encumbrance = create PreEncumbranceObject
  step 'I add the encumbrance to the stack'
end

When /^I (.*) a Pre-Encumbrance document with an Encumbrance Accounting Line for the current Month$/ do |button|
  @account = make AccountObject, number: 'G003704' # TODO: Pick an appropriate account from the service
  step "I #{button} a Pre-Encumbrance Document that encumbers the random Account" # This works because the default is the current month
end

And /^I do an Open Encumbrances lookup for the Pre-Encumbrance document with Balance Type (.*) and Include All Pending Entries$/ do |balance_type|
  visit(MainPage).open_encumbrances
  on OpenEncumbranceLookupPage do |page|
    page.doc_number.set @encumbrance.document_id
    page.balance_type_code.set balance_type
    page.active_indicator_all.set
    page.search
  end
end

Then /^The oustanding encumbrance for account (.*) and object code (.*) is (.*)$/ do |account_number, object_code, amount|
  visit(MainPage).open_encumbrances
  on OpenEncumbranceLookupPage do |page|
    page.account_number.set account_number
    page.chart_code.set 'IT' #TODO get from config
    page.object_code.set object_code
    page.including_pending_ledger_entry_approved.set
    page.doc_number.set @remembered_document_id
    page.balance_type_code.set 'PE'
    page.search

    outstanding_amount_col = page.column_index(:outstanding_amount)
    page.results_table.rest[0][outstanding_amount_col].text.groom.should == amount.groom

  end
end

And /^I add the (encumbrance|disencumbrance) to the stack$/ do |type|
  if @pre_encumbrances.nil?
    @pre_encumbrances = {"#{type}" => [@pre_encumbrance]}
  elsif @pre_encumbrance[type.to_sym].nil?
    @pre_encumbrances.merge!({"#{type}" => [@pre_encumbrance]})
  else
    @pre_encumbrances[type.to_sym] << @pre_encumbrance
  end
end
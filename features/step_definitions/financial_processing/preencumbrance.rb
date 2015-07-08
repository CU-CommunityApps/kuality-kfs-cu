When /^I (#{PreEncumbrancePage::available_buttons}) a Pre\-Encumbrance Document that encumbers the random Account$/ do |button|
  # Note: You must have created a random account object in a previous step to use this step.
  # Note: This step WILL CREATE the random object code object and will use the parameter default source amount.
  step "I find a random Pre-Encumbrance Object Code"
  @encumbrance_amount = get_aft_parameter_value(ParameterConstants::DEFAULT_PREENCUMBRANCE_SOURCE_ACCOUNTING_LINE_AMOUNT)
  @pre_encumbrance = create PreEncumbranceObject,
                            initial_lines: [{
                                                type:              :source,
                                                account_number:    @account.number,
                                                chart_code:        @account.chart_code,
                                                object:            @object_code.object_code,
                                                amount:            @encumbrance_amount,
                                                line_description:  'Using previously created random account'
                                            }]
  step "I save the Pre-Encumbrance document"   # pre-encumbrance document must be saved before it can be submitted
  step "I #{button} the Pre-Encumbrance document"
  step 'I add the encumbrance to the stack'
end

When /^I (#{PreEncumbrancePage::available_buttons}) a Pre-Encumbrance document that encumbers a random Account$/ do |button|
  #Note: This step WILL CREATE the random account object and random object code object, and will use the parameter pre-encumbrance source amount.
  step "I find a random Pre-Encumbrance Account"
  step "I find a random Pre-Encumbrance Object Code"
  @encumbrance_amount = get_aft_parameter_value(ParameterConstants::DEFAULT_PREENCUMBRANCE_SOURCE_ACCOUNTING_LINE_AMOUNT)
  @pre_encumbrance = create PreEncumbranceObject,
                            initial_lines: [{
                                                type:              :source,
                                                account_number:    @account.number,
                                                chart_code:        @account.chart_code,
                                                object:            @object_code.object_code,
                                                amount:            @encumbrance_amount,
                                                line_description:  'Created random account and object code'
                                            }]
  step "I save the Pre-Encumbrance document"   # pre-encumbrance document must be saved before it can be submitted
  step "I #{button} the Pre-Encumbrance document" unless button.eql?('save')   # do not save a second time when step was requested to save
  step 'I add the encumbrance to the stack'
end


Then /^the outstanding encumbrance for the account and object code used is the difference between the amounts$/ do
  # Note: You must have created a random account object in a previous step to use this step.
  # Note: You must have created a random object code object in a previous step to use this step.
  # Note: You must have created the encumbrance amount in a previous step to use this step.
  # Note: You must have created the disencumbrance amount object in a previous step to use this step.
  visit(MainPage).open_encumbrances
  on OpenEncumbranceLookupPage do |page|
    page.account_number.set     @account.number
    page.chart_code.set         @account.chart_code
    page.object_code.set        @object_code.object_code
    page.including_pending_ledger_entry_approved.set
    page.doc_number.set         @remembered_document_id
    page.balance_type_code.set 'PE'
    page.search
    page.wait_for_search_results

    # before comparing deal with the possibility of money with no cents and compare the same data type of integer
    computed_outstanding_amount = ((@encumbrance_amount.to_f - @disencumbrance_amount.to_f) * 100).to_i
    outstanding_amount_col = page.column_index(:outstanding_amount)
    page_outstanding_amount = (((page.results_table.rest[0][outstanding_amount_col].text.groom).to_f) * 100).to_i
    page_outstanding_amount.should == computed_outstanding_amount
  end
end


And /^I add a target Accounting Line to the Pre-Encumbrance document that matches the source Accounting Line except for amount$/ do
  # Note: You must have captured the source account object and object code object in a previous step to use this step.
  @disencumbrance_amount = get_aft_parameter_value(ParameterConstants::DEFAULT_PREENCUMBRANCE_TARGET_ACCOUNTING_LINE_AMOUNT)
  step "I add a target Accounting Line for chart code #{@account.chart_code} and account number #{@account.number} and object code #{@object_code.object_code} and amount #{@disencumbrance_amount} to the Pre-Encumbrance document"
end


And /^I add a source Accounting Line to a Pre-Encumbrance document that automatically disencumbers an account with an existing encumbrance by a partial amount using a fixed monthly schedule$/ do
  parameter_to_use = ParameterConstants::DEFAULTS_FOR_PREENCUMBRANCE_AUTOMATIC_PARTIAL_DISENCUMBRANCE
  step "I obtain #{parameter_to_use} data values required for the test from the Parameter table"
  #do not continue if input data required for next step in test was not specified in the Parameter table
  fail ArgumentError, "Parameter #{parameter_to_use} required for this test does not exist in the Parameter table." if @test_input_data.nil? || @test_input_data.empty?
  fail ArgumentError, "Parameter #{parameter_to_use} does not specify required input test data value for auto disencumber type" if @test_input_data[:auto_disencumbrance_type].nil? || @test_input_data[:auto_disencumbrance_type].empty?
  fail ArgumentError, "Parameter #{parameter_to_use} does not specify required input test data value for count" if @test_input_data[:count].nil? || @test_input_data[:count].empty?
  fail ArgumentError, "Parameter #{parameter_to_use} does not specify required input test data value for partial_amount" if @test_input_data[:partial_amount].nil? || @test_input_data[:partial_amount].empty?
  # global encumbrance data item should have been set by a previous step
  @disencumbrance_amount = @encumbrance_amount
  # partial amount could be money with decimal, count should be a whole number,
  # NOTE: If string compares are performed in steps, recommend converting to cents first and then doing the compare
  @encumbrance_amount = (((@test_input_data[:partial_amount]).to_f * 100) * (@test_input_data[:count]).to_i) / 100

  step "I add a Source Accounting Line to the Pre-Encumbrance document with the following:",
       table = table(%Q{
              | Chart Code                | #{@account.chart_code}                         |
              | Number                    | #{@account.number}                             |
              | Object Code               | #{@object_code.object_code}             |
              | Amount                    | #{@encumbrance_amount}                         |
              | Auto Disencumber Type     | #{@test_input_data[:auto_disencumbrance_type]} |
              | Partial Transaction Count | #{@test_input_data[:count]}                    |
              | Partial Amount            | #{@test_input_data[:partial_amount]}           |
              | Start Date                | #{right_now[:date_w_slashes]}                  |
           })
end


And /^I add a target Accounting Line to a Pre-Encumbrance document to disencumber an existing encumbrance$/ do
  step "I add a Target Accounting Line to the Pre-Encumbrance document with the following:",
       table = table(%Q{
              | Chart Code       | #{@account.chart_code}             |
              | Number           | #{@account.number}                 |
              | Object Code      | #{@object_code.object_code} |
              | Amount           | #{@disencumbrance_amount}          |
              | Reference Number | #{@remembered_document_id}         |
           })
end


And /^I add a (source|target) Accounting Line for chart code (.*) and account number (.*) and object code (.*) and amount (.*) to the (.*) document$/ do |line_type, chart_code, account_number, object_code, amount, document|
  line_data_as_table = nil
  if line_type.eql?('source')
    line_data_as_table = table(%Q{
              | Chart Code  | #{chart_code}      |
              | Number      | #{account_number}  |
              | Object Code | #{object_code}     |
              | Amount      | #{amount}          |
           })
  elsif line_type.eql?('target')
    line_data_as_table = table(%Q{
              | Chart Code       | #{chart_code}              |
              | Number           | #{account_number}          |
              | Object Code      | #{object_code}             |
              | Amount           | #{amount}                  |
              | Reference Number | #{@remembered_document_id} |
           })
  end
  step "I add a #{line_type.capitalize} Accounting Line to the #{document} document with the following:", line_data_as_table
end


And /^I add a (source|target) Accounting Line with a random account, a random object code and a default amount to the (.*) document$/ do |line_type, document|
  amount = nil
  case
    when line_type.eql?('source')
      @encumbrance_amount = get_aft_parameter_value(ParameterConstants::DEFAULT_PREENCUMBRANCE_SOURCE_ACCOUNTING_LINE_AMOUNT)
      #fail the test if required parameter is not set
      @encumbrance_amount.nil?.should_not == true
      amount = @encumbrance_amount
    when line_type.eql?('target')
      @disencumbrance_amount = get_aft_parameter_value(ParameterConstants::DEFAULT_PREENCUMBRANCE_TARGET_ACCOUNTING_LINE_AMOUNT)
      #fail the test if required parameter is not set
      @disencumbrance_amount.nil?.should_not == true
      amount = @disencumbrance_amount
  end
  step "I find a random Pre-Encumbrance Account"
  step "I find a random Pre-Encumbrance Object Code"
  step "I add a #{line_type} Accounting Line for chart code #{@account.chart_code} and account number #{@account.number} and object code #{@object_code.object_code} and amount #{amount} to the #{document} document"
end

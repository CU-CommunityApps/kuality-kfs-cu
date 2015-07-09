###### Next four routines save and retrieve references to instance data between the scenario that creates it and
###### the scenario that uses it for validation when the batch jobs must be executed in order to achieve validation.
Then /^references to test (.*) instance data are saved for validation after batch job execution$/ do |aft_name|
  step "references to test #{aft_name} instance data for nil are saved for validation after batch job execution"
end


# A conscious decision was made to not refactor the case statement in this method. The instance data for each AFT is
# pertinent to that specific test and could change at any point in time when the test is updated. Keeping the instance
# data specific to each AFT simplifies maintenance and makes it clear which data elements are being used.
Then /^references to test (.*) instance data for (.*) are saved for validation after batch job execution$/ do |aft_name, doc_type|
  # create Hash for this test's instance data
  aft_data_hash = Hash.new
  # populate that instance data hash for the specific AFT with its information needed later for validation and store
  # that info in the global hash referencing by AFT JIRA number
  case aft_name
    when 'KFSQA-664' #Pre_Encumbrance
      aft_data_hash[:encumbrance_amount] = @encumbrance_amount
      aft_data_hash[:pre_encumbrance]    = @pre_encumbrance
      aft_data_hash[:account]            = @account
      aft_data_hash[:object_code]        = @object_code
      $aft_validation_data[aft_name]     = aft_data_hash
    when 'KFSQA-753' #Pre_Encumbrance
      aft_data_hash[:encumbrance_amount] = @encumbrance_amount
      aft_data_hash[:pre_encumbrance]    = @pre_encumbrance
      aft_data_hash[:account]            = @account
      aft_data_hash[:object_code]        = @object_code
      $aft_validation_data[aft_name]     = aft_data_hash
    when 'KFSQA-983' #Labor Distribution
      aft_data_hash[:test_data_parameter_name] = @test_data_parameter_name
      aft_data_hash[:test_input_data]          = @test_input_data
      aft_data_hash[:user_principal]           = @user_principal
      aft_data_hash[:employee_id]              = @employee_id
      aft_data_hash[:salary_expense_transfer]  = @salary_expense_transfer
      aft_data_hash[:fiscal_year]              = @fiscal_year
      $aft_validation_data[aft_name]           = aft_data_hash
    when 'KFSQA-970' #Labor Distribution
      aft_data_hash[:test_data_parameter_name] = @test_data_parameter_name
      aft_data_hash[:test_input_data]          = @test_input_data
      aft_data_hash[:user_principal]           = @user_principal
      aft_data_hash[:employee_id]              = @employee_id
      aft_data_hash[:salary_expense_transfer]  = @salary_expense_transfer
      aft_data_hash[:remembered_document_id]   = @remembered_document_id
      $aft_validation_data[aft_name]           = aft_data_hash
    when 'KFSQA-1012' #Labor Distribution
      aft_data_hash[:test_data_parameter_name] = @test_data_parameter_name
      aft_data_hash[:test_input_data]          = @test_input_data
      aft_data_hash[:employee_id]              = @employee_id
      aft_data_hash[:salary_expense_transfer]  = @salary_expense_transfer
      $aft_validation_data[aft_name]           = aft_data_hash
    when 'KFSQA-649' #General Ledger source outline test
      aft_data_hash[:document_id] = @document_id
      aft_data_hash[:account]     = @account
      case doc_type
        when 'AD'
          aft_data_hash[:advance_deposit] = @advance_deposit
        when 'AV'
          aft_data_hash[:auxiliary_voucher] = @auxiliary_voucher
        when 'CCR'
          aft_data_hash[:credit_card_receipt] = @credit_card_receipt
        when 'DI'
          aft_data_hash[:distribution_of_income_and_expense] = @distribution_of_income_and_expense
        when 'GEC'
          aft_data_hash[:general_error_correction] = @general_error_correction
        when 'IB'
          aft_data_hash[:internal_billing] = @internal_billing
        when 'TF'
          aft_data_hash[:transfer_of_funds] = @transfer_of_funds
        else raise ArgumentError, "Required Doc Type for AFT name #{aft_name} is not known by step that saves the instance data for validation post batch job execution."
      end
      composite_key = "#{aft_name}-#{doc_type}"
      $aft_validation_data[composite_key] = aft_data_hash
    else raise ArgumentError, 'Required AFT Name is not known by step that saves the instance data for validation post batch job execution.'
  end
end


And /^I can retrieve references to test (.*) instance data saved for validation after batch job execution$/ do |aft_name|
  step "I can retrieve references to test #{aft_name} instance data for nil saved for validation after batch job execution"
end


# A conscious decision was made to not refactor the case statement in this method. The instance data for each AFT is
# pertinent to that specific test and could change at any point in time when the test is updated. Keeping the instance
# data specific to each AFT simplifies maintenance and makes it clear which data elements are being used.
And /^I can retrieve references to test (.*) instance data for (.*) saved for validation after batch job execution$/ do |aft_name, doc_type|
  # ensure global Hash of Hashes contains something
  raise StandardError, 'Global hash of AFT data for validation is nil.' if $aft_validation_data.nil?
  raise StandardError, 'Global hash of AFT data for validation is empty.' if $aft_validation_data.empty?
  raise ArgumentError.new("Key for AFT Name #{aft_name} Doc Type #{doc_type} was not found in Global hash of AFT data for validation. Scenario that should have saved that data must have failed.") unless $aft_validation_data.key?(aft_name) || $aft_validation_data.key?("#{aft_name}-#{doc_type}")

  # populate all of the instance data for the specified AFT with the archived data needed for validation
  case aft_name
    when 'KFSQA-664' #Pre_Encumbrance
      aft_data_hash       = $aft_validation_data[aft_name]
      @encumbrance_amount = aft_data_hash[:encumbrance_amount]
      @pre_encumbrance    = aft_data_hash[:pre_encumbrance]
      @account            = aft_data_hash[:account]
      @object_code        = aft_data_hash[:object_code]
      $aft_validation_data.delete(aft_name)
    when 'KFSQA-753'  #Pre_Encumbrance
      aft_data_hash       = $aft_validation_data[aft_name]
      @encumbrance_amount = aft_data_hash[:encumbrance_amount]
      @pre_encumbrance    = aft_data_hash[:pre_encumbrance]
      @account            = aft_data_hash[:account]
      @object_code        = aft_data_hash[:object_code]
      $aft_validation_data.delete(aft_name)
    when 'KFSQA-983' #Labor Distribution
      aft_data_hash       = $aft_validation_data[aft_name]
      @test_data_parameter_name = aft_data_hash[:test_data_parameter_name]
      @test_input_data          = aft_data_hash[:test_input_data]
      @user_principal           = aft_data_hash[:user_principal]
      @employee_id              = aft_data_hash[:employee_id]
      @salary_expense_transfer  = aft_data_hash[:salary_expense_transfer]
      @fiscal_year              = aft_data_hash[:fiscal_year]
      $aft_validation_data.delete(aft_name)
    when 'KFSQA-970' #Labor Distribution
      aft_data_hash       = $aft_validation_data[aft_name]
      @test_data_parameter_name = aft_data_hash[:test_data_parameter_name]
      @test_input_data          = aft_data_hash[:test_input_data]
      @user_principal           = aft_data_hash[:user_principal]
      @employee_id              = aft_data_hash[:employee_id]
      @salary_expense_transfer  = aft_data_hash[:salary_expense_transfer]
      @remembered_document_id   = aft_data_hash[:remembered_document_id]
      $aft_validation_data.delete(aft_name)
    when 'KFSQA-1012' #Labor Distribution
      aft_data_hash       = $aft_validation_data[aft_name]
      @test_data_parameter_name = aft_data_hash[:test_data_parameter_name]
      @test_input_data          = aft_data_hash[:test_input_data]
      @employee_id              = aft_data_hash[:employee_id]
      @salary_expense_transfer  = aft_data_hash[:salary_expense_transfer]
      $aft_validation_data.delete(aft_name)
    when 'KFSQA-649' #General Ledger scenario outline test
      raise ArgumentError, "Required Doc Type for AFT name #{aft_name} is nil in step that retrieves the instance data for validation post batch job execution." if doc_type.nil?
      composite_key = "#{aft_name}-#{doc_type}"
      aft_data_hash = $aft_validation_data[composite_key]
      @document_id = aft_data_hash[:document_id]
      @account     = aft_data_hash[:account]
      case doc_type
        when 'AD'
          @advance_deposit = aft_data_hash[:advance_deposit]
        when 'AV'
          @auxiliary_voucher = aft_data_hash[:auxiliary_voucher]
        when 'CCR'
          @credit_card_receipt = aft_data_hash[:credit_card_receipt]
        when 'DI'
          @distribution_of_income_and_expense = aft_data_hash[:distribution_of_income_and_expense]
        when 'GEC'
          @general_error_correction = aft_data_hash[:general_error_correction]
        when 'IB'
          @internal_billing = aft_data_hash[:internal_billing]
        when 'TF'
          @transfer_of_funds = aft_data_hash[:transfer_of_funds]
        else raise ArgumentError, "Required Doc Type for AFT name #{aft_name} is not known by step that retrieves the instance data for validation post batch job execution."
      end
      $aft_validation_data.delete(composite_key)
    else raise ArgumentError, 'Required AFT Name is not known by step that retrieves the instance data for validation post batch job execution.'
  end
end

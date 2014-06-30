When /^I start an empty Distribution Of Income And Expense document$/ do
  @distribution_of_income_and_expense = create DistributionOfIncomeAndExpenseObject, initial_lines: []
  @distribution_of_income_and_expense.assets.shift # TODO : CA is not added yet. so remove it ??
end

And /^I change the DI from Account to one not owned by the current user$/ do
  @distribution_of_income_and_expense.accounting_lines['source'.to_sym][0].edit account_number: "A763900"
end

And /^I change the DI from Account to one owned by the current user$/ do
  @distribution_of_income_and_expense.accounting_lines['source'.to_sym][0].edit account_number: "1753302"
end

And /^I add a (From|To) amount of "(.*)" for account "(.*)" with object code "(.*)" with a line description of "(.*)" to the DI Document$/  do |target, amount, account_number, object_code, line_desc|
  on DistributionOfIncomeAndExpensePage do |page|
    case target
      when 'From'
        @distribution_of_income_and_expense.add_source_line({
                                                                account_number:   account_number,
                                                                object:           object_code,
                                                                amount:   amount,
                                                                line_description: line_desc
                                                            })
      when 'To'
        @distribution_of_income_and_expense.add_target_line({
                                                                account_number:   account_number,
                                                                object:           object_code,
                                                                amount:   amount,
                                                                line_description: line_desc
                                                            })
    end
  end
end

And /^I select accounting line and (create|modify) Capital Asset$/ do |action|
  on CapitalAssetsTab do |tab|
    tab.accounting_lines_for_capitalization_select.set
    tab.distribution_method.fit 'Distribute cost by amount'
    case action
      when 'create'
        tab.create_asset
      when 'modify'
        tab.modify_asset
    end
  end
  on DistributionOfIncomeAndExpensePage do |page|
    page.use_new_tab
    page.close_parents
  end
end

And /^I distribute new Capital Asset amount$/ do
  on CapitalAssetsTab do |tab|
    @asset_account_number = tab.asset_account_number
    @distribution_of_income_and_expense.assets.add   capital_asset_qty:           '1',
                                                     capital_asset_type:          '019',
                                                     capital_asset_manufacturer:  'CA manufacturer',
                                                     capital_asset_description:   random_alphanums(40, 'AFT'),
                                                     capital_asset_line_amount:   page.remain_asset_amount
    #page.capital_asset_line_amount.fit page.remain_asset_amount
    tab.capital_asset_number.fit @asset_number unless @asset_number.nil?
    tab.redistribute_amount
  end
end

And /^I distribute modify Capital Asset amount$/ do
  on CapitalAssetsTab do |tab|
    @asset_account_number = page.asset_account_number
    tab.capital_asset_line_amount.fit page.remain_asset_amount
    tab.capital_asset_number.fit @asset_number
    tab.redistribute_modify_amount
  end
end

And /^I add a tag and location for Capital Asset$/ do
  on(CapitalAssetsTab).vendor_search
  vendor_num = get_aft_parameter_value(ParameterConstants::REQS_NONB2B_VENDOR)

  on VendorLookupPage do |page|
    page.vendor_number.wait_until_present
    page.vendor_number.fit vendor_num
    page.search
    page.return_value(vendor_num)
  end
  on(CapitalAssetsTab).insert_tag

  on DistributionOfIncomeAndExpensePage do |page|
    page.use_new_tab
    page.close_parents
  end
  on CapitalAssetsTab do |tab|
    tab.tag_number.fit random_alphanums(8, 'T')
    tab.capital_asset_campus.fit 'IT - Ithaca'
    tab.capital_asset_building.fit '7000'
    tab.capital_asset_room.fit 'XXXXXXXX'
  end
end

And /^I build a Capital Asset from the General Ledger$/ do
  steps %Q{
    Given I Login as an Asset Processor
    And   I lookup a Capital Asset from GL transaction to process
    And   I create asset from General Ledger Processing
    And   I submit the Asset Global document
    Then  the Asset Global document goes to FINAL
   }
end

And /^I lookup a Capital Asset from GL transaction to process$/ do
  visit(MainPage).capital_asset_builder_gl_transactions
  on GeneralLedgerPendingEntryLookupPage do |page|
    page.account_number.fit @asset_account_number
    page.search
    page.process(@asset_account_number)
  end

  on(CapitalAssetInformationProcessingPage).process
end

And /^I create asset from General Ledger Processing$/ do
  on(GeneralLedgerProcessingPage).create_asset
  @asset_global = create AssetGlobalObject
end

Given  /^I create a Distribution of Income and Expense document with the following:$/ do |table|
  account_info = table.raw.flatten.each_slice(6).to_a
  account_info.shift # skip header row
  capital_asset_action = 'No'

  steps %Q{
            Given   I am logged in as a KFS User for the DI document
            And     I start an empty Distribution Of Income And Expense document
          }

  account_info.each do |line_type, chart_code, account_number, object_code, amount, capital_asset|
    account_amount = !@lookup_asset.nil? && amount.empty? ? @asset_amount : amount
    account_line_type = line_type.eql?('From') ? 'Source' : 'Target'
    capital_asset_action = line_type.eql?('From') && !capital_asset.empty? && capital_asset.eql?('Yes') ? 'modify' : 'No'
    capital_asset_action = capital_asset_action.eql?('No') && line_type.eql?('To') && !capital_asset.empty? && capital_asset.eql?('Yes') ? 'create' : 'No'
    step "I add a #{account_line_type} Accounting Line to the Distribution Of Income And Expense document with the following:",
         table(%Q{
              | Chart Code   | #{chart_code}       |
              | Number       | #{account_number}   |
              | Object Code  | #{object_code}      |
              | Amount       | #{account_amount}           |
         })
  end

  unless @lookup_asset.nil?
    capital_asset_action = 'modify'
    step "I add a Source Accounting Line to the Distribution Of Income And Expense document with the following:",
         table(%Q{
              | Chart Code   | #{@asset_chart}            |
              | Number       | #{@asset_account_number}   |
              | Object Code  | #{@asset_object_code}      |
              | Amount       | #{@asset_amount}           |
         })

  end
  case capital_asset_action
    when 'create'
      steps %Q{
              And     I select accounting line and create Capital Asset
              And     I distribute new Capital Asset amount
              And     I add a tag and location for Capital Asset
  }
    when 'modify'
      steps %Q{
              And   I select accounting line and modify Capital Asset
              And     I distribute modify Capital Asset amount
  }
  end

  steps %Q{
            And     I submit the Distribution Of Income And Expense document
            And     the Distribution Of Income And Expense document goes to ENROUTE
            And     I route the Distribution Of Income And Expense document to final
          }

end

And /^I lookup a Capital Asset with the following:$/ do |table|
  asset_info = table.rows_hash
  visit(MainPage).asset
  on AssetLookupPage do |page|
    page.campus.fit asset_info['Campus']
    page.building_code.fit asset_info['Building']
    page.building_room_number.fit asset_info['Room']
    page.asset_type_code.fit asset_info['Asset Type']
    page.asset_status_code.fit asset_info['Asset Code']
    page.search
    page.return_random_asset
    #  TODO slow to return. need to find more efficient to pick return asset
  end
end

And /^I select Capital Asset detail information$/ do
  on AssetInquiryPage do |page|
    page.toggle_payment
    @asset_number = page.asset_number
    @asset_account_number = page.asset_account_number
    @asset_object_code = page.asset_object_code
    @asset_amount = page.asset_amount
    @asset_chart = page.asset_chart
    puts @asset_number,@asset_account_number,@asset_object_code,@asset_amount
    @lookup_asset = 'Yes'
  end

end

And /^I modify a Capital Asset from the General Ledger and apply payment$/ do
  steps %Q{
    Given I am logged in as "jcs28"
    And   I lookup a Capital Asset from GL transaction to process
    And   I select and apply payment for General Ledger Capital Asset
    And   I submit the Asset Manual Payment document
    Then  the Asset Manual Payment document goes to FINAL
   }
end

And /^I select and apply payment for General Ledger Capital Asset$/ do
  on(GeneralLedgerProcessingPage).apply_payment
  @asset_manual_payment = create AssetManualPaymentObject
end


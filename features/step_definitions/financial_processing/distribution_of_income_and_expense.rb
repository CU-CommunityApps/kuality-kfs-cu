When /^I start an empty Distribution Of Income And Expense document$/ do
  @distribution_of_income_and_expense = create DistributionOfIncomeAndExpenseObject, initial_lines: []
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

And /^I select accounting line and create Capital Asset$/ do
  on DistributionOfIncomeAndExpensePage do |page|
    page.accounting_lines_for_capitalization_select.set
    page.distribution_method.fit 'Distribute cost by amount'
    page.create_asset
  end
end

And /^I distribute Capital Asset amount$/ do
  on DistributionOfIncomeAndExpensePage do |page|
    @asset_account_number = page.asset_account_number
    page.capital_asset_line_amount.fit page.remain_asset_amount
    page.redistribute_amount
  end
end

And /^I add a tag and location for Capital Asset$/ do
  on(DistributionOfIncomeAndExpensePage).vendor_search
  vendor_num = get_aft_parameter_value(ParameterConstants::REQS_NONB2B_VENDOR)

  on VendorLookupPage do |page|
    page.vendor_number.wait_until_present
    page.vendor_number.fit vendor_num
    page.search
    page.return_value(vendor_num)
  end
  on DistributionOfIncomeAndExpensePage do |page|
    page.capital_asset_qty.fit '1'
    page.capital_asset_type.fit '019'
    page.capital_asset_manufacturer.fit 'CA manufacturer'
    page.capital_asset_description.fit random_alphanums(40, 'AFT')
    page.insert_tag

    page.use_new_tab
    page.close_parents
    page.tag_number.fit random_alphanums(8, 'T')
    page.capital_asset_campus.fit 'IT - Ithaca'
    page.capital_asset_building.fit '7000'
    page.capital_asset_room.fit 'XXXXXXXX'
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
  on CabGlLookupPage do |page|
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

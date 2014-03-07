When /^I perform a (.*) Lookup using account number (.*)$/ do |gl_balance_inquiry_lookup, account_number|
  gl_balance_inquiry_lookup = gl_balance_inquiry_lookup.gsub!(' ', '_').downcase
  visit(MainPage).send(gl_balance_inquiry_lookup)
  if gl_balance_inquiry_lookup == 'current_fund_balance'
    on CurrentFundBalanceLookupPage do |page|
      page.chart_code.set 'IT'
      page.account_number.set account_number
      page.search
    end
  else
    on GeneralLedgerEntryLookupPage do |page|
      page.chart_code.set 'IT' #TODO get from config
      page.account_number.set account_number
      page.search
    end
  end
end
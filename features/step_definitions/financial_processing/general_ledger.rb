When /^I perform a (.*) Lookup using account number (.*)$/ do |gl_balance_inquiry_lookup, account_number|
  gl_balance_inquiry_lookup = gl_balance_inquiry_lookup.gsub!(' ', '_').downcase
  visit(MainPage).send(gl_balance_inquiry_lookup)
  puts gl_balance_inquiry_lookup
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

Then /^the (.*) document GL Entry Lookup matches the document's GL entry$/ do |document|
  pending
end

And /^the (.*) document has matching GL and GLPE offsets$/ do |document|
  pending
end
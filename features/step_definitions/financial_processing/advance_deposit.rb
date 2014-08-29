Then /^the AD document submits with no errors$/ do
  on(AdvanceDepositPage).document_status.should == 'ENROUTE'
end

When /^I start an empty Advance Deposit document$/ do
  visit(MainPage).advance_deposit
  @advance_deposit = create AdvanceDepositObject, initial_lines: []
end
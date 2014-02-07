Then /^"([^"]*)" should not be displayed in the Accounting Line section$/ do |msg|
 on(AdvanceDepositPage).errors.should_not include msg
end
Then /^The Notes and Attachment Tab includes "(.*)"$/ do |message|
  on(DistributionOfIncomeAndExpensePage).notes_tab.text.should include message
end
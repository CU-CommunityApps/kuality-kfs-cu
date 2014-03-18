Then /^the Notes and Attachment Tab says "(.*)"$/ do |message|
  on DistributionOfIncomeAndExpensePage do |page|
    page.expand_all
    page.notes_tab.text.should include message
  end
end
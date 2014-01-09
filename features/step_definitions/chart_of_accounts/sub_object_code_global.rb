And(/^I create a Sub-Object Code Global$/) do
  @subObjectCodeGlobal = create SubObjectCodeGlobalObject
end

, multiple_accounting_lines_account_number_lookup: '100071*'
And(/^ retrieve multiple account lines using Organization Code (.*)$/) do |org_code|
  @sub
end

Then(/^I should verify the organizations came as in the hierarchy \(complete\?\) how\?$/) do
  pending # express the regexp above with the code you wish you had
end



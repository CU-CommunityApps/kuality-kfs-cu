And(/^I create a Sub-Object Code Global$/) do
  @subObjectCodeGlobal = create SubObjectCodeGlobalObject
end

When(/^I add multiple account lines using Organization Code (.*)$/) do |org_code|
  @subObjectCodeGlobal.add_multiple_account_lines(org_code)
end

Then(/^Retrieved accounts equal all Active Accounts for Organization Code "(.*?)"$/) do |multiple_account_numbers|
  accounts = "#{multiple_account_numbers}".split(', ')
  accounts.each do |an_account_number|
    on SubObjectCodeGlobalPage do |page|
      page.verify_account_number('IT', an_account_number).should exist
    end
  end
end

And /^I (#{SubObjectCodeGlobalPage::available_buttons}) a Sub-Object Code Global document$/ do |button|
  button.gsub!(' ', '_')
  @sub_object_code_global = create SubObjectCodeGlobalObject, press: button
end

When /^I (#{SubObjectCodeGlobalPage::available_buttons}) the Sub-Object Code Global document$/ do |button|
  button.gsub!(' ', '_')
  on(SubObjectCodeGlobalPage).send(button)
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

When /^I add multiple account lines using Organization Code (.*)$/ do |org_code|
  @sub_object_code_global.add_multiple_account_lines(org_code)
end

Then /^Retrieved accounts equal all Active Accounts for Organization Code "(.*?)"$/ do |multiple_account_numbers|
  accounts = "#{multiple_account_numbers}".split(', ')
  accounts.each do |an_account_number|
    on SubObjectCodeGlobalPage do |page|
      page.verify_account_number('IT', an_account_number).should exist
    end
  end
end

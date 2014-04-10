And /^I press the (.*) key$/ do |key|
  @browser.send_keys snake_case(key)
end

Then /^my cursor is on the (.*) button$/ do |button|
  @browser.frm.input(title: button).focused?
end

Then /^my cursor is on the (.*) field$/ do |title|
  case title
    when 'Attach File'
      puts @browser.frm.input(id: 'attachmentFile').inspect
      @browser.frm.input(id: 'attachmentFile').focused?
  end
end

When /^I click the (.*) button$/ do |button|
  @browser.frm.input(title: button).click
end
And /^I press the (.*) key$/ do |key|
  puts "I press the #{key} key:"
  puts key.inspect
  puts @browser.inspect
  @browser.send_keys snake_case(key)
end

Then /^my cursor is on the (.*) button$/ do |button|
  puts "my cursor is on the #{button} button:"
  puts @browser.frm.input(title: button).inspect
  @browser.frm.input(title: button).focused?
end

Then /^my cursor is on the (.*) field$/ do |title|
  puts "my cursor is on the #{title} field:"
  case title
    when 'Attach File'
      puts @browser.frm.input(id: 'attachmentFile').inspect
      @browser.frm.input(id: 'attachmentFile').focused?
  end
end

When /^I click the (.*) button$/ do |button|
  puts "I click the #{button} button:"
  puts @browser.frm.input(title: button).inspect
  @browser.frm.input(title: button).click
end
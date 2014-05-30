And /^I press the ([A-Za-z0-9+ ]*) key$/ do |key|
  # puts "Got #{key.to_s.inspect}"
  # puts "Sending #{key.split('+').map{ |k| snake_case(k) }}!"
  @browser.send_keys key.split('+').map{ |k| snake_case k }
end

And /^I send the ([A-Za-z0-9+ ]*) key to the ([A-Za-z0-9+ ]*) button$/ do |key, button|
  case button
    when 'Attach File'
      @browser.frm.input(id: 'attachmentFile').send_keys key.split('+').map{ |k| snake_case k }
    else
      @browser.frm.input(title: button).send_keys key.split('+').map{ |k| snake_case k }
  end
end

And /^I press the ([A-Za-z0-9+ ]*) key (\d+) times$/ do |key, times|
  times.to_i.times{ step "I press the #{key} key" }
end

Then /^my cursor is on the (.*) button$/ do |button|
  puts @browser.frm.input(title: button).focused?
  @browser.frm.input(title: button).focused?.should be_true
end

Then /^my cursor is on the (.*) field$/ do |title|
  puts @browser.frm.input(id: 'attachmentFile').focused?
  case title
  when 'Attach File'
    @browser.frm.input(id: 'attachmentFile').focused?.should be_true
  else
    pending "The action for #{title} has not yet been defined for this step."
  end
end

When /^I click the (.*) button$/ do |button|
  case button
    when 'Attach File'
      @browser.frm.input(id: 'attachmentFile').click
    else
      @browser.frm.input(title: button).click
  end
end
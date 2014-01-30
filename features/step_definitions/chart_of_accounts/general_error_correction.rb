And /^I (#{GeneralErrorCorrectionPage::available_buttons}) a GEC document$/ do |button|
  button.gsub!(' ', '_')
  @gec = create GeneralErrorCorrectionObject, press: button
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

And /^I add an Accounting Line to the GEC document with "Account Expired Override" selected$/ do
  pending
end

When /^I (.*) a GEC document for an expired Account$/ do |button|
  button.gsub!(' ', '_')
  # TODO: Find an expired Account (chart, acct_number), and appropriate settings for Object, Ref Origin Code, and Reference Number
  # TODO: Create a GEC document with the Account using that button press
  @gec = create GeneralErrorCorrectionObject, press: button, from_lines: [{}], to_lines: [{}]
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
  pending
end

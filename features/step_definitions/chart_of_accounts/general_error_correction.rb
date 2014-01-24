And /^I (#{GeneralErrorCorrectionPage::available_buttons}) a GEC document$/ do |button|
  button.gsub!(' ', '_')
  @gec = create GeneralErrorCorrectionObject, press: button
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end

When /^I (#{GeneralErrorCorrectionPage::available_buttons}) the GEC document$/ do |button|
  button.gsub!(' ', '_')
  @gec.send(button)
  sleep 10 if (button == 'blanket_approve') || (button == 'approve')
end


And /^I (#{GeneralErrorCorrectionPage::available_buttons}) a GEC document with the Account and "(.*)" selected$/ do |button, action|
  # @account must be defined at this point
  selectable_actions = {'Account Expired Override' => :account_expired_override}

  # We're going to go with default values for this for now.
  @gec = create GeneralErrorCorrectionObject, selectable_actions[action].merge({press: button})
end
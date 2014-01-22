include BatchUtilities

And /^I (#{AdvanceDepositPage::available_buttons}) an AD document$/ do |button|
  @advance_deposit = create AdvanceDepositObject, press: button
end

And /^Nightly Batch Jobs run$/ do
  step 'I am logged in as a KFS Technical Administrator'
  run_nightly_out(true)
  run_scrubber(true)
  run_poster(true)
end

Then /^the AD document submits with no errors$/ do
  on(AdvanceDepositPage).document_status.should == 'ENROUTE'
end

Then /^the AD document goes to (.*)/ do |doc_status|
  sleep 5
  @advancde_deposit.view
  on(AdvanceDepositPage).document_status.should == doc_status
end

When /^I (#{AdvanceDepositPage::available_buttons}) the AD document$/ do |button|
  button.gsub!(' ', '_')
  @advance_deposit.view
  @advance_deposit.send(button)
  sleep 10 if button == 'blanket_approve'
end
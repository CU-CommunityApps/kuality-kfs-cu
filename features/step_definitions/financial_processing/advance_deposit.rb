include BatchUtilities

And /^I (#{AdvanceDepositPage::available_buttons}) an AD document$/ do |button|
  @advance_deposit = create AdvanceDepositObject, press: button.gsub(' ', '_')
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

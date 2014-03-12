
include BatchUtilities

And /^I (#{AdvanceDepositPage::available_buttons}) an Advance Deposit document$/ do |button|
  visit(MainPage).advance_deposit
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

When /^I start an empty Advance Deposit document$/ do
  visit(MainPage).advance_deposit
  @advance_deposit = create AdvanceDepositObject, initial_lines: []
end